import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product(
  {
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    this.isFavorite=false,
    required this.price,
  }
      );
  Future<void> toggleFavoriteStatus(String token,String userId) async{
    final oldStatus=isFavorite;
    isFavorite=!isFavorite;
    notifyListeners();
    var url=Uri.parse('https://shop-app-1f90e-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');
    // var url=Uri.https('shop-app-1f90e-default-rtdb.firebaseio.com','/products/$id.json');
    try{
    final response=await http.put(url,body: json.encode(
      isFavorite,
    ));
    if(response.statusCode>=400){
      isFavorite=oldStatus;
      notifyListeners();
    }
    }catch(error){
      isFavorite=oldStatus;
      notifyListeners();
    }
  }

}