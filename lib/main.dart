import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/product_cubit.dart';
import 'cubits/cart_cubit.dart';
import 'services/product_service.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MiniShopApp());
}

class MiniShopApp extends StatelessWidget {
  const MiniShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductCubit(ProductService()),
        ),
        BlocProvider(
          create: (_) => CartCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Mini Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1565C0),
          ),
          useMaterial3: true,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
