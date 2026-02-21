import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product_model.dart';
import '../models/local_products.dart';
import '../cubits/cart_cubit.dart';
import '../app_theme.dart';
import '../screens/cart_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  String _formatPrice(double egp) {
    return egp
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }

  void _showAddedToCartSheet(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                product.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  Text('Added to cart', style: TextStyle(color: AppColors.textGrey, fontSize: 16)),
                  SizedBox(width: 8),
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<CartCubit>(),
                        child: const CartScreen(),
                      ),
                    ),
                  );
                },
                child: const Text(
                  'View Cart',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  side: const BorderSide(color: AppColors.cardBorder),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Continue Shopping',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final egpPrice = CartState.productPriceEGP(product);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder, width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: _buildImage(),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      style: AppTextStyles.productTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 13, color: AppColors.starColor),
                        const SizedBox(width: 3),
                        Text(
                          '${product.rating.toStringAsFixed(1)} (132 reviews)',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${_formatPrice(egpPrice)} EGP',
                          style: AppTextStyles.price,
                        ),
                        BlocBuilder<CartCubit, CartState>(
                          builder: (context, cartState) {
                            final cubit = context.read<CartCubit>();
                            if (cartState.isInCart(product.id)) {
                              final quantity = cubit.getQuantity(product.id);
                              return Container(
                                height: 32,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF3FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 30,
                                      height: 32,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        iconSize: 18,
                                        icon: const Icon(Icons.remove, color: AppColors.primary),
                                        onPressed: () => cubit.decreaseQuantity(product.id),
                                      ),
                                    ),
                                    Text(
                                      '$quantity',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    SizedBox(
                                      width: 30,
                                      height: 32,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        iconSize: 18,
                                        icon: const Icon(Icons.add, color: AppColors.primary),
                                        onPressed: () => cubit.addProduct(product),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  cubit.addProduct(product);
                                  _showAddedToCartSheet(context, product);
                                },
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEEF3FF),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 17,
                                    color: AppColors.primary,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (product.hasLocalImage) {
      return Container(
        color: const Color(0xFFF8F8F8),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              product.localImage!,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.image, color: Colors.grey),
            ),
          ),
        ),
      );
    }
    if (product.thumbnail.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: product.thumbnail,
        fit: BoxFit.cover,
        width: double.infinity,
        placeholder: (_, __) => Container(
          color: const Color(0xFFF5F5F5),
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
          ),
        ),
        errorWidget: (_, __, ___) => Container(
          color: const Color(0xFFF5F5F5),
          child: const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      );
    }
    return Container(
      color: const Color(0xFFF5F5F5),
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }
}
