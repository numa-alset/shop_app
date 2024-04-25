import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/orders.dart';
import 'package:shop_app/screens/auth-screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';
import './screens/products_overview_screen.dart';
import './provider/products.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers:
    [
      ChangeNotifierProvider(create: (_) => Auth(),),
      // update with ProxiyProvider
      // create: (contex)=>Products in addition if its wrong
      ChangeNotifierProxyProvider<Auth,Products>(create:(_)=>Products('','',[]) , update: (_, auth, previous) => Products(auth.token==null?'':auth.token!,auth.userId==null?'':auth.userId!,previous==null?[]:previous.items),),
      // ChangeNotifierProvider(create:(_)=> Products(),),
      ChangeNotifierProvider(create: (_) => Cart(),),
      ChangeNotifierProxyProvider<Auth,Orders>(create: (context) => Orders('','', []), update: (context, value, previous) => Orders(value.token!,value.userId!,previous==null? []: previous.orders),)
      // ChangeNotifierProvider(create: (_) => Orders(),),



    ],
      child:Consumer<Auth>(builder: (context, auth, _) =>MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme:
          ColorScheme.fromSeed(seedColor: Colors.deepOrange,onSecondary: Colors.deepOrange),
          primarySwatch: Colors.purple,
          textTheme: TextTheme(titleMedium: TextStyle(color: Colors.blue),),
          appBarTheme: AppBarTheme(color: Colors.purple),
          buttonTheme: ButtonThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange,onSecondary: Colors.deepOrange)),
          fontFamily: 'Lato',
          useMaterial3: true,
        ),
        home: auth.isAuth?ProductOverviewScreen() :FutureBuilder(future: auth.tryAutoLogin(), builder: (context, snapshot) =>snapshot.connectionState==ConnectionState.waiting? SplashScreen(): AuthScreen(),),
        routes: {
          ProductDetailScreen.routeName:(context) => ProductDetailScreen(),
          CartScreen.routName:(context) => CartScreen(),
          OrderScreen.routName:(context) => OrderScreen(),
          UserProductScreen.routeName:(context) => UserProductScreen(),
          EditeProductScreen.routeName:(context) => EditeProductScreen(),
        },
      ), )
    );
  }
}




