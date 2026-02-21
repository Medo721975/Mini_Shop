import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/product_model.dart';
import '../models/local_products.dart';
import '../services/product_service.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> localProducts;
  final List<Product> apiProducts;
  final bool apiLoading;
  final bool hasMore;
  final int currentSkip;

  ProductLoaded({
    required this.localProducts,
    required this.apiProducts,
    this.apiLoading = false,
    this.hasMore = true,
    this.currentSkip = 0,
  });

  List<Product> get allProducts => [...localProducts, ...apiProducts];

  @override
  List<Object?> get props => [localProducts, apiProducts, apiLoading, hasMore, currentSkip];

  ProductLoaded copyWith({
    List<Product>? localProducts,
    List<Product>? apiProducts,
    bool? apiLoading,
    bool? hasMore,
    int? currentSkip,
  }) {
    return ProductLoaded(
      localProducts: localProducts ?? this.localProducts,
      apiProducts: apiProducts ?? this.apiProducts,
      apiLoading: apiLoading ?? this.apiLoading,
      hasMore: hasMore ?? this.hasMore,
      currentSkip: currentSkip ?? this.currentSkip,
    );
  }
}

class ProductError extends ProductState {
  final String message;
  final List<Product> localProducts;

  ProductError(this.message, this.localProducts);

  @override
  List<Object?> get props => [message];
}
class ProductCubit extends Cubit<ProductState> {
  final ProductService _service;
  static const int _pageSize = 10;

  ProductCubit(this._service) : super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    final locals = LocalProducts.featured;
    emit(ProductLoaded(
      localProducts: locals,
      apiProducts: [],
      apiLoading: true,
    ));

    try {
      final apiProducts = await _service.fetchProducts(limit: _pageSize, skip: 0);
      emit(ProductLoaded(
        localProducts: locals,
        apiProducts: apiProducts,
        apiLoading: false,
        hasMore: apiProducts.length == _pageSize,
        currentSkip: _pageSize,
      ));
    } catch (e) {
      emit(ProductLoaded(
        localProducts: locals,
        apiProducts: [],
        apiLoading: false,
        hasMore: false,
      ));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! ProductLoaded || current.apiLoading || !current.hasMore) return;

    emit(current.copyWith(apiLoading: true));

    try {
      final more = await _service.fetchProducts(
        limit: _pageSize,
        skip: current.currentSkip,
      );
      emit(current.copyWith(
        apiProducts: [...current.apiProducts, ...more],
        apiLoading: false,
        hasMore: more.length == _pageSize,
        currentSkip: current.currentSkip + _pageSize,
      ));
    } catch (_) {
      emit(current.copyWith(apiLoading: false));
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      fetchProducts();
      return;
    }
    final locals = LocalProducts.featured;
    emit(ProductLoaded(localProducts: locals, apiProducts: [], apiLoading: true));
    try {
      final results = await _service.searchProducts(query);
      emit(ProductLoaded(
        localProducts: locals,
        apiProducts: results,
        apiLoading: false,
        hasMore: false,
      ));
    } catch (e) {
      emit(ProductLoaded(localProducts: locals, apiProducts: [], apiLoading: false));
    }
  }
}
