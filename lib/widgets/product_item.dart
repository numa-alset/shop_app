import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/product.dart';
import '../screens/product_detail_screen.dart';
class ProductItem extends StatelessWidget {
 // final String id;
 // final String title;
 // final String imgeUrl;
 // ProductItem(this.id,this.title,this.imgeUrl);

  @override
  Widget build(BuildContext context) {
   final product= Provider.of<Product>(context,listen: false);
   final cart= Provider.of<Cart>(context,listen: false);
   final authData=Provider.of<Auth>(context,listen: false);
   print('revbild');
    return  ClipRRect(
     borderRadius: BorderRadius.circular(10),
      child: GridTile(child: GestureDetector(
       onTap: () {
         Navigator.of(context).pushNamed(ProductDetailScreen.routeName,arguments: product.id, );
       },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image:NetworkImage(product.imageUrl) ,
              fit:BoxFit.cover ,
            ),
          ),
          // Image.network(product.imageUrl,fit: BoxFit.cover),
      ),

       footer: GridTileBar(title: Text(product.title,textAlign: TextAlign.center,),
        backgroundColor: Colors.black87,
        leading: Consumer<Product>(

          builder:(_, value, child) =>  IconButton(icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
           color: Theme.of(context).primaryColor,
           onPressed: () {
            product.toggleFavoriteStatus(authData.token!,authData.userId!);
          },),
        ),
        trailing: IconButton(icon: Icon(Icons.shopping_cart),
         color: Theme.of(context).primaryColor,
         onPressed: () {
          cart.addItem(product.id, product.price, product.title);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added item to cart!'),
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label:'undo',
              onPressed: () {
                cart.removeSingleItem(product.id);
              },
            ),
            ),

          );
         },) ,

       ),

      ),
    );
  }
}
