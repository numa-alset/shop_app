import 'package:flutter/material.dart';
import '../provider/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';
class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  @override
  var _expanded=false;
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      height: _expanded?min(widget.order.products.length*20.0+110.0, 200):100,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(widget.order.dateTime)),
              trailing: IconButton(icon: Icon(_expanded?Icons.expand_less:Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded=!_expanded;
                });
              },
              ),
            ),
            // if(_expanded)
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                height:  _expanded?min(widget.order.products.length*20.0+10.0, 100):0,
                child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14,vertical: 4),
                height:min(widget.order.products.length*20.0+10.0, 100) ,
                child: ListView(
                  children: widget.order.products.map((e) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      Text('${e.quantity}x \$${e.price}' ,style: TextStyle(color: Colors.grey,fontSize: 20),),
                    ],
                  )).toList(),
                ),
            ),
              )
          ],
        ),
      ),
    );
  }
}
