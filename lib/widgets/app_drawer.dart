import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/screens/user_product_screen.dart';
import '../screens/order_screen.dart';
class AppDrawer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(title: Text('hello Freind'),
          automaticallyImplyLeading: false,),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('shop'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),

          ),Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('orders'),
            onTap: () => Navigator.of(context).pushReplacementNamed(OrderScreen.routName),

          ),Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('manage products'),
            onTap: () => Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName),

          ),Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log out'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
    // Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName)
    Provider.of<Auth>(context,listen: false).logout();
    },

          ),

        ],
      ),
    );
  }
}
