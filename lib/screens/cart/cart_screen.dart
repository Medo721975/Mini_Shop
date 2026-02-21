import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/cart_cubit.dart';
import '../../app_theme.dart';
import 'widgets/cart_app_bar.dart';
import 'widgets/cart_content.dart';
import 'widgets/cart_empty.dart';
import 'widgets/checkout_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            return Column(
              children: [
                CartAppBar(state: state),
                Expanded(
                  child: state.items.isEmpty
                      ? const CartEmpty()
                      : CartContent(state: state),
                ),
                if (state.items.isNotEmpty) const CheckoutButton(),
              ],
            );
          },
        ),
      ),
    );
  }
}