

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../provider/orders.dart';
import '../widgets/order_item.dart' as ord;
class OrderScreen extends StatefulWidget {

  static const routName='/orders';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future _orderFuture;
  Future _obtainOrderFuture(){
    return Provider.of<Orders>(context,listen: false).fetchAndSetOrders();
  }
  @override
  void initState() {
    _orderFuture=_obtainOrderFuture();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // final orderData =Provider.of<Orders>(context);
    return Scaffold(
      appBar:AppBar(title: Text('your Orders'),) ,
      body:FutureBuilder(
        future: _orderFuture ,
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
          return  Center(child:CircularProgressIndicator() ,);
          }else{
            if(snapshot.error!=null){
              return Center(child: Text('error occured'),);
            }else{
             return Consumer<Orders>(builder: (context, orderData, child) =>ListView.builder(
               itemCount: orderData.orders.length,
               itemBuilder: (context, index) =>ord.OrderItem(orderData.orders[index]) ,

             ));
            }
          }
        },
      ),
drawer: AppDrawer(),
    ) ;
  }
}
