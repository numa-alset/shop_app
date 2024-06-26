import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';

class CartItem extends StatelessWidget {
final String id;
final String productId;
final String title;
final int quantity;
final double price;
CartItem(this.id,this.productId,this.price,this.quantity,this.title);
  @override
  Widget build(BuildContext context) {

    return Dismissible(
     key: ValueKey(id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        child: Icon(Icons.delete,color: Colors.white,size: 40,),
        alignment: Alignment.bottomRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context,listen: false).removeItem(productId);
      },
      confirmDismiss: (direction) {
       return showDialog(context: context, builder: (context) =>
        AlertDialog(title: Text('are you sure'),
        content: Text('do u want to remove this item'),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop(false);
            },
                child: Text('No')),
                     TextButton(onPressed: () {
                       Navigator.of(context).pop(true);
            },
                child: Text('Yes')),

          ],
        )
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(child: Text('\$$price'))),),
            title: Text(title),
            subtitle: Text('Total \$${(price * quantity)}'),
          trailing: Text('$quantity x'),
          ),
        ),
      ),
    ) ;
  }
}
