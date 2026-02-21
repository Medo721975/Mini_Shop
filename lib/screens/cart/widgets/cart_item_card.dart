import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubits/cart_cubit.dart';
import '../../../models/product_model.dart';
import '../../../app_theme.dart';
import '../utils/egp_formatter.dart';
import 'qty_button.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final egpPrice = CartState.productPriceEGP(product);
    final isHighlighted = product.id == 1002;

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
          _ProductImage(product: product),
          const SizedBox(width: 12),
          Expanded(
            child: _ProductInfo(
              product: product,
              item: item,
              egpPrice: egpPrice,
            ),
          ),
          const SizedBox(width: 8),
          _DeleteButton(productId: product.id),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final Product product;

  const _ProductImage({required this.product});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final Product product;
  final CartItem item;
  final double egpPrice;

  const _ProductInfo({
    required this.product,
    required this.item,
    required this.egpPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
        _PriceAndQuantity(
          egpPrice: egpPrice,
          item: item,
          product: product,
        ),
      ],
    );
  }
}

class _PriceAndQuantity extends StatelessWidget {
  final double egpPrice;
  final CartItem item;
  final Product product;

  const _PriceAndQuantity({
    required this.egpPrice,
    required this.item,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          EGPFormatter.format(egpPrice),
          style: AppTextStyles.cartPrice,
        ),
        const Spacer(),
        QtyButton(
          icon: Icons.remove,
          onTap: () => context.read<CartCubit>().decreaseQuantity(product.id),
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
        QtyButton(
          icon: Icons.add,
          color: AppColors.primary,
          iconColor: Colors.white,
          onTap: () => context.read<CartCubit>().addProduct(product),
        ),
      ],
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final int productId;

  const _DeleteButton({required this.productId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<CartCubit>().removeProduct(productId),
      child: const Padding(
        padding: EdgeInsets.only(left: 4),
        child: Icon(Icons.delete_outline, color: AppColors.deleteRed, size: 22),
      ),
    );
  }
}
