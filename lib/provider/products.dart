import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'dart:convert';
import 'product.dart';
import 'package:http/http.dart' as http;
class Products with ChangeNotifier {
  List<Product> _items=[
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //   'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //   'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  // var _showFavOnly=false;
   String authToken;
   String userId;
  Products(this.authToken,this.userId,this._items);

  List<Product> get items{
    // if (_showFavOnly){
    // return _items.where((element) => element.isFavorite).toList();
    // }
    return[..._items];
  }
  List<Product> get itemsFav{
    return _items.where((element) => element.isFavorite).toList();
  }
  // void showFavOnly(){
  //   _showFavOnly=true;
  //   notifyListeners();
  // }
  // void showAll(){
  //   _showFavOnly=false;
  //   notifyListeners();
  // }
  Product findById(String id){
    return _items.firstWhere((element) => element.id==id);

  }
  Future<void> fetchAndSetProduct([bool filterByUser=false])async{
    var filterString=filterByUser? 'orderBy="creatorId"&equalTo="$userId"':'';
    var url=Uri.parse('https://shop-app-1f90e-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    // var url=Uri.https('shop-app-1f90e-default-rtdb.firebaseio.com','/products.json?auth=$authToken',);
    final response= await http.get(url);
    final extractedData= json.decode(response.body) as Map<String,dynamic>;
    final List<Product>loadedProducts=[];
    if(extractedData==null){
      return;
    }
    var url2=Uri.parse('https://shop-app-1f90e-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
    final favoriteResponse=await http.get(url2);
    final favoriteData=json.decode(favoriteResponse.body);
    extractedData.forEach((key, value) {
      loadedProducts.add(
        Product(id: key, title: value['title'], imageUrl: value['imageUrl'], description: value['description'], price: value['price'],
            isFavorite:favoriteData==null? false :favoriteData[key]??false)
      );
    });
    _items=loadedProducts;
    notifyListeners();
    // print(json.decode(response.body));
  }

  Future<void> addProduct(Product product) async {
    var url=Uri.parse('https://shop-app-1f90e-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    // var url=Uri.https('shop-app-1f90e-default-rtdb.firebaseio.com','/products.json?auth=$authToken',);
       try{
      final response= await http.post(url,body:json.encode({
         'title':product.title,
         'description':product.description,
         'imageUrl':product.imageUrl,
         'price':product.price,
         'creatorId':userId,
         // 'isFavorite':product.isFavorite,
       }) ,);
      print(json.decode(response.body));
      final newProduct=Product(id:
      json.decode(response.body)['name'], title: product.title, imageUrl: product.imageUrl, description: product.description, price: product.price);
      _items.add(newProduct);

      notifyListeners();
       }
          catch (erorr){
            print(erorr);
            throw erorr;
          }
  }
  Future<void> updateProduct(String id,Product newProduct) async{
   final prdIndex= _items.indexWhere((e) => e.id==id);
   if(prdIndex>=0){
     var url=Uri.parse('https://shop-app-1f90e-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
   // var url=Uri.https('shop-app-1f90e-default-rtdb.firebaseio.com','/products/$id.json');
    await http.patch(url,body: json.encode({
     'title':newProduct.title,
     'description':newProduct.description,
     'imageUrl':newProduct.imageUrl,
     'price':newProduct.price,
   }),);
     _items[prdIndex]=newProduct;
     notifyListeners();
   }else{
     print('sdfsafd');
   }

  }
  Future<void> deleteProduct(String id)async {
    var url=Uri.parse('https://shop-app-1f90e-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final existingProductIndex =_items.indexWhere((element) => element.id==id);
    Product? existingProduct=_items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    // _items.insert(existingProductIndex, existingProduct!);

    // _items.removeWhere((element) => element.id==id);
    // notifyListeners();
   final response=await http.delete(url);
      if (response.statusCode>=400){
        _items.insert(existingProductIndex, existingProduct!);

        // _items.removeWhere((element) => element.id==id);
        notifyListeners();
        throw HttpException('could not delete product.');
      }
      existingProduct=null;
    }

}