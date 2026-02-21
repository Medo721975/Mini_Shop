import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/product_model.dart';
import '../models/local_products.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  bool isInCart(int productId) =>
      items.any((e) => e.product.id == productId);

  double get itemsTotal =>
      items.fold(0, (sum, item) => sum + _itemTotalEGP(item));

  double get shippingFee => itemsTotal > 0 ? 0 : 0;

  double get grandTotal => itemsTotal + shippingFee;

  int get totalCount => items.fold(0, (sum, item) => sum + item.quantity);

  static double _itemTotalEGP(CartItem item) {
    final localPrice = LocalProducts.egpPrices[item.product.id];
    if (localPrice != null) {
      return localPrice * item.quantity;
    }
    return item.product.discountedPriceEGP * item.quantity;
  }

  static double productPriceEGP(Product p) {
    final localPrice = LocalProducts.egpPrices[p.id];
    if (localPrice != null) return localPrice;
    return p.discountedPriceEGP;
  }

  CartState copyWith({List<CartItem>? items}) =>
      CartState(items: items ?? this.items);

  @override
  List<Object?> get props => [items];
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addProduct(Product product) {
    final items = List<CartItem>.from(state.items);
    final idx = items.indexWhere((e) => e.product.id == product.id);
    if (idx >= 0) {
      items[idx] = CartItem(
        product: items[idx].product,
        quantity: items[idx].quantity + 1,
      );
    } else {
      items.add(CartItem(product: product));
    }
    emit(state.copyWith(items: items));
  }

  void removeProduct(int productId) {
    final items = state.items.where((e) => e.product.id != productId).toList();
    emit(state.copyWith(items: items));
  }

  void decreaseQuantity(int productId) {
    final items = List<CartItem>.from(state.items);
    final idx = items.indexWhere((e) => e.product.id == productId);
    if (idx >= 0) {
      if (items[idx].quantity <= 1) {
        items.removeAt(idx);
      } else {
        items[idx] = CartItem(
          product: items[idx].product,
          quantity: items[idx].quantity - 1,
        );
      }
    }
    emit(state.copyWith(items: items));
  }

  void clearCart() => emit(const CartState());

  int getQuantity(int productId) {
    try {
      return state.items.firstWhere((e) => e.product.id == productId).quantity;
    } catch (_) {
      return 0;
    }
  }
}
