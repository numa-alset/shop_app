import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductsItem extends StatelessWidget {
  final String id;
 final String title;
 final String imageUrl;
 UserProductsItem(this.id,this.title,this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final scafold=ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(onPressed:() {
            Navigator.of(context).pushNamed(EditeProductScreen.routeName,arguments: id);
            }, icon: Icon(Icons.edit),
            color: Theme.of(context).primaryColor,),
            IconButton(onPressed:()async {
              try {
               await Provider.of<Products>(context, listen: false).deleteProduct(id);
              }catch(error){
                scafold.showSnackBar(SnackBar(content: Text('deleting faild')));
              }
            }, icon: Icon(Icons.delete),
            color: Theme.of(context).colorScheme.error,),
          ],
        ),
      ),
    );
  }
}
