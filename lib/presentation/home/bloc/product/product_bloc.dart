// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pos_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos_app/data/models/request/add_product_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_pos_app/data/datasources/product_remote_datasource.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/models/response/product_response_model.dart';

part 'product_bloc.freezed.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDatasource _productRemoteDatasource;
  List<Product> products = [];
  ProductBloc(
    this._productRemoteDatasource,
  ) : super(const _Initial()) {
    on<_Fetch>((event, emit) async {
      emit(const _Loading());
      final result = await _productRemoteDatasource.getProducts();
      result.fold(
        (l) => emit(_Error(l)), 
        (r) {
          products = r.data;
          emit(_Success(products));
        }
      );
    });

    on<_FetchLocal>((event, emit) async {
      emit(const _Loading());
      final localProducts = await ProductLocalDatasource.instance.getAllProduct();
      products = localProducts;
      
      emit(_Success(products));
    });

    on<_FetchByCategory>((event, emit) async {
      emit(const _Loading());
      final newProducts = event.category == 'all' 
        ? products 
        : products
          .where((element) => element.category == event.category)
          .toList();

      emit(_Success(newProducts));
    });

    on<_AddProduct>((event, emit) async {
      emit(const _Loading());
      final requestData = AddProductRequestModel(
        name: event.product.name, 
        price: event.product.price, 
        stock: event.product.stock, 
        category: event.product.category, 
        isBestSeller: event.product.isBestSelller ? 1 : 0, 
        image: event.image
      );
      final response = await _productRemoteDatasource.addProduct(requestData);
      // products.add(newProduct);
      response.fold(
        (l) => emit(_Error(l)),
        (r) {
          products.add(r.data);
          emit(_Success(
            products
          ));
        }
      );
      emit(_Success(products));
    });
  }
}