import 'package:flutter/material.dart';
import '../../../cubits/cart_cubit.dart';
import '../../../app_theme.dart';
import 'cart_item_card.dart';
import 'cart_summary.dart';

class CartContent extends StatelessWidget {
  final CartState state;

  const CartContent({
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CartSummary(state: state),
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
                child: CartItemCard(item: state.items[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}