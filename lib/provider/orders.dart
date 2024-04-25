import 'package:flutter/material.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class OrderItem {

  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
OrderItem(
  {
    required this.dateTime,
    required this.id,
    required this.products,
    required this.amount,

}
    );

}


class Orders with ChangeNotifier{
  List <OrderItem> _orders=[];
   String authToken;
   String userId;
   Orders(this.authToken,this.userId,this._orders);
  List<OrderItem> get orders {
    return[..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total)async
  {
    var url=Uri.parse('https://shop-app-1f90e-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timestamp=DateTime.now();
  final response= await http.post(url,body: json.encode({
      'dateTime': timestamp.toIso8601String(),
      'products': cartProduct.map((e) =>{
        'id':e.id,
        'title':e.title,
        'quantity':e.quantity,
        'price':e.price
      }).toList(),
      'amount': total
    }),);
    _orders.insert(0, OrderItem(dateTime: timestamp, id: json.decode(response.body)['name'], products: cartProduct, amount: total));
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async{
    var url=Uri.parse('https://shop-app-1f90e-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    // var url=Uri.https('shop-app-1f90e-default-rtdb.firebaseio.com','/orders.json');
    final response=await http.get(url);
    final List<OrderItem>loadedOrders=[];
    final extractData=json.decode(response.body)as Map<String,dynamic>;
    if(extractData==null){
      return;
    }
    extractData.forEach((key, value) {
      loadedOrders.add(OrderItem(dateTime: DateTime.parse(value['dateTime']), id: key,
          products: (value['products']as List<dynamic>).map((e) => CartItem(title: e['title'], id: e['id'], price: e['price'], quantity: e['quantity'])).toList(),
          amount: value['amount']));
    });
    _orders=loadedOrders.reversed.toList();
    notifyListeners();
  }

}