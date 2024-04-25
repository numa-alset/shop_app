import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';
import '../provider/products.dart';
class UserProductScreen extends StatelessWidget {
static const routeName='/user-product';
Future<void> _refreshProducts(BuildContext context)async {
 await Provider.of<Products>(context,listen: false).fetchAndSetProduct(true);
}
  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar:AppBar(
        title:const Text('your product'),
        actions: [
          IconButton(onPressed: () {
          Navigator.of(context).pushNamed(EditeProductScreen.routeName);
          }, icon:const Icon(Icons.add))
        ],
      ) ,
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder:(context, snapshot) =>  snapshot.connectionState==ConnectionState.waiting? Center(
          child:CircularProgressIndicator() ,
        )
            :RefreshIndicator(
          onRefresh: () {
           return _refreshProducts(context);
          },
          child: Consumer<Products>(
            builder:(context, productsData, _) =>  Padding(
              padding:const EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: productsData.items.length,
                  itemBuilder: (_, index) =>Column(
                    children: [
                      UserProductsItem(productsData.items[index].id,productsData.items[index].title, productsData.items[index].imageUrl),
                      Divider(),
                    ],
                  ) ,),
            ),
          ),
        ),
      ),
    );
  }
}
