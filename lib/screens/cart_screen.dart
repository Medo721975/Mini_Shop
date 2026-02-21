import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/cart_cubit.dart';
import '../models/product_model.dart';
import '../app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  String _formatEGP(double v) {
    return 'EGP ${v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            return Column(
              children: [
                _buildAppBar(context, state),
                Expanded(
                  child: state.items.isEmpty
                      ? _buildEmptyCart(context)
                      : _buildCartContent(context, state),
                ),
                if (state.items.isNotEmpty) _buildCheckoutButton(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, CartState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.cardBorder, width: 0.5)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              'assets/icons/Arrow_left.png',
              width: 28,
              height: 28,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: AppColors.primary,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'My Cart',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 26),
              if (state.totalCount > 0)
                Positioned(
                  top: -5,
                  right: -5,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${state.totalCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                _summaryRow('Items Total', _formatEGP(state.itemsTotal)),
                const SizedBox(height: 10),
                _summaryRowColored('Shipping Fee', 'Free', AppColors.freeGreen),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: AppColors.cardBorder),
                ),
                _summaryRow(
                  'Total',
                  _formatEGP(state.grandTotal),
                  titleBold: true,
                  valueBold: false,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              '${state.items.length} Items',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CartItemCard(item: state.items[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value,
      {bool titleBold = false, bool valueBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: titleBold ? FontWeight.bold : FontWeight.normal,
            color: AppColors.textGrey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _summaryRowColored(String title, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context, CartState state) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order placed successfully! 🎉'),
                backgroundColor: AppColors.freeGreen,
              ),
            );
            context.read<CartCubit>().clearCart();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: const Text(
            'Checkout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF3FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 46,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Add items to get started',
            style: TextStyle(color: AppColors.textGrey, fontSize: 14),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
class _CartItemCard extends StatelessWidget {
  final CartItem item;

  const _CartItemCard({required this.item});

  String _formatEGP(double v) {
    return 'EGP ${v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final egpPrice = CartState.productPriceEGP(product);
    final isHighlighted = product.id == 1002; // MacBook highlighted in design

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.cartHighlight : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted ? AppColors.primary : AppColors.cardBorder,
          width: isHighlighted ? 1.5 : 0.8,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 72,
              height: 72,
              color: const Color(0xFFF5F5F5),
              child: product.hasLocalImage
                  ? Image.asset(
                      product.localImage!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image, color: Colors.grey),
                    )
                  : (product.thumbnail.isNotEmpty
                      ? Image.network(
                          product.thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image, color: Colors.grey),
                        )
                      : const Icon(Icons.image, color: Colors.grey)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.brand.isNotEmpty ? product.brand : 'Product',
                  style: AppTextStyles.cartItemTitle,
                ),
                const SizedBox(height: 2),
                Text(
                  product.title,
                  style: AppTextStyles.cartItemSub,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      _formatEGP(egpPrice),
                      style: AppTextStyles.cartPrice,
                    ),
                    const Spacer(),
                    _QtyButton(
                      icon: Icons.remove,
                      onTap: () =>
                          context.read<CartCubit>().decreaseQuantity(product.id),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    _QtyButton(
                      icon: Icons.add,
                      color: AppColors.primary,
                      iconColor: Colors.white,
                      onTap: () => context.read<CartCubit>().addProduct(product),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => context.read<CartCubit>().removeProduct(product.id),
            child: const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(Icons.delete_outline, color: AppColors.deleteRed, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color iconColor;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    this.color = const Color(0xFFF0F0F0),
    this.iconColor = AppColors.textDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: iconColor),
      ),
    );
  }
}
