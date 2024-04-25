import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';
import '../widgets/badge.dart'as Badge2;
import 'package:shop_app/provider/cart.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;

  // ProductDetailScreen(this.title);
static const routeName='/product-detail';
  @override
  Widget build(BuildContext context) {
   final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct= Provider.of<Products>(context,listen: false).findById(productId);

    return Scaffold(
      // appBar:AppBar(
      //   title: Text(loadedProduct.title),
      // ) ,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(title: Text(loadedProduct.title),
              background: Hero(
                  tag: loadedProduct.id,
                  child: Image.network(loadedProduct.imageUrl,fit: BoxFit.cover,)),
              ),

            ),
            SliverList(delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10,
                ),
                Text('${loadedProduct.price} ',style: TextStyle(fontSize: 20,color: Colors.grey),textAlign: TextAlign.center,),
                SizedBox(height: 10,),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal:10 ),
                    child: Text(loadedProduct.description,textAlign: TextAlign.center,softWrap: true,)),
                SizedBox(height: 700,)

              ]
            ))
          ],
          // child: Column(
          //   children: [
          //     Container(
          //       height: 300,
          //       width: double.infinity,
          //       child:
          //     ),
          //    ],
          // ),
        )


    );
  }
}
