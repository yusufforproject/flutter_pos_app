import 'package:bloc/bloc.dart';
import 'package:flutter_pos_app/presentation/home/models/order_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/models/response/product_response_model.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';
part 'checkout_bloc.freezed.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(const _Success([], 0, 0)) {
    on<_AddCheckout>((event, emit) {
      var currentState = state as _Success;
      List<OrderItem> newCheckout = [...currentState.products];
      emit (const _Loading());
      if(newCheckout.any((element) => element.product == event.product)){
        var index = newCheckout.indexWhere((element) => element.product == event.product);
        newCheckout[index].quantity++;
      } else {
        newCheckout.add(OrderItem(product: event.product, quantity: 1));
      }

      int totalQty = 0;
      int totalPrice = 0;
      for (var element in newCheckout) {
        totalQty += element.quantity;
        totalPrice += element.quantity * element.product.price;
      }

      emit(_Success(newCheckout, totalQty, totalPrice));
    });

    on<_RemoveCheckout>((event, emit) {
      var currentState = state as _Success;
      List<OrderItem> newCheckout = [...currentState.products];
      emit (const _Loading());
      if(newCheckout.any((element) => element.product == event.product)){
        var index = newCheckout.indexWhere((element) => element.product == event.product);
        if(newCheckout[index].quantity > 1){
          newCheckout[index].quantity--;
        } else {
          newCheckout.removeAt(index);
        }
      } 

      int totalQty = 0;
      int totalPrice = 0;
      for (var element in newCheckout) {
        totalQty += element.quantity;
        totalPrice += element.quantity * element.product.price;
      }

      emit(_Success(newCheckout, totalQty, totalPrice));
    });

    on<_Started>((event, emit) {
      emit(const _Loading());
      emit(const _Success([], 0, 0));
    });
  }
}

