import 'package:flutter/material.dart';
import '../../../cubits/cart_cubit.dart';
import '../../../app_theme.dart';
import '../utils/egp_formatter.dart';

class CartSummary extends StatelessWidget {
  final CartState state;

  const CartSummary({
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          _SummaryRow(
            title: 'Items Total',
            value: EGPFormatter.format(state.itemsTotal),
          ),
          const SizedBox(height: 10),
          _SummaryRowColored(
            title: 'Shipping Fee',
            value: 'Free',
            valueColor: AppColors.freeGreen,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: AppColors.cardBorder),
          ),
          _SummaryRow(
            title: 'Total',
            value: EGPFormatter.format(state.grandTotal),
            titleBold: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool titleBold;

  const _SummaryRow({
    required this.title,
    required this.value,
    this.titleBold = false,
  });

  @override
  Widget build(BuildContext context) {
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

class _SummaryRowColored extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const _SummaryRowColored({
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
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
}