import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/product_cubit.dart';
import '../cubits/cart_cubit.dart';
import '../app_theme.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProducts();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<ProductCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<CartCubit>(),
          child: const CartScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductInitial ||
                      (state is ProductLoaded &&
                          state.apiLoading &&
                          state.apiProducts.isEmpty)) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  if (state is ProductError) {
                    return _buildErrorState(context, state);
                  }

                  if (state is ProductLoaded) {
                    return _buildProductGrid(context, state);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Image.asset('assets/icons/logo.png', height: 40),
          const Spacer(),
          BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              return GestureDetector(
                onTap: _goToCart,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    if (cartState.totalCount > 0)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${cartState.totalCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ProductError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50),
          const SizedBox(height: 10),
          Text(state.message, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => context.read<ProductCubit>().fetchProducts(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context, ProductLoaded state) {
    final products = state.allProducts;

    if (products.isEmpty) {
      return const Center(
        child: Text('No products to display'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ProductCubit>().fetchProducts(),
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: products.length + (state.apiLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == products.length) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }
          return ProductCard(
            product: products[index],
          );
        },
      ),
    );
  }
}
