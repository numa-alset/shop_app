import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart' ;
import 'package:shop_app/provider/orders.dart';
import '../widgets/cart_item.dart' as car;

class CartScreen extends StatelessWidget {
static const routName='/cart';

  @override
  Widget build(BuildContext context) {
    final cart= Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text('your cart'),

      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total',style: TextStyle(fontSize: 20,),),
                  Spacer(),
                  SizedBox(width: 10,),
                  Chip(label: Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  ),
                    OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (context, index) => car.CartItem(
                  cart.items.values.toList()[index].id,
                  cart.items.keys.toList()[index],
                  cart.items.values.toList()[index].price,
                  cart.items.values.toList()[index].quantity,
                  cart.items.values.toList()[index].title
              ),
          ),
          )
        ],

      ),
    ) ;
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading=false;
  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed:(widget.cart.totalAmount<=0 || isLoading)?null: () async{
      setState(() {
        isLoading=true;
      });
     await Provider.of<Orders>(context,listen: false).addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
      setState(() {
        isLoading=false;
      });
      widget.cart.clear();
    }, child:isLoading? CircularProgressIndicator():Text('oreder now'),);
  }
}
