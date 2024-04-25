import 'package:flutter/material.dart';
import '../provider/products.dart';

import './product_item.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
final bool fav;
ProductGrid(this.fav);
  @override
  Widget build(BuildContext context) {
    final productsData=Provider.of<Products>(context);
    final products=fav? productsData.itemsFav:productsData.items;
    return GridView.builder(
      padding:const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
          childAspectRatio: 3/2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
             value:  products[index],
            child: ProductItem());
      },);
  }
}