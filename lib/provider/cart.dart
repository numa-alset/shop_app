import 'package:flutter/material.dart';

class CartItem{
  final String id;

  final String title;
  final int quantity;
  final double price;
  CartItem({
    required this.title,

    required this.id,
    required this.price,
    required this.quantity,
});
}

class Cart with ChangeNotifier{
  Map <String,CartItem> _items={};
  Map <String,CartItem>get items{
    return {..._items};
  }
  void addItem(String productId, double price, String title){
    if(_items.containsKey(productId)){
    _items.update(productId, (value) => CartItem(title: value.title, id: value.id, price:value.price, quantity: value.quantity+1));
    }else
      {
        _items.putIfAbsent(productId, () => CartItem(title: title, id: DateTime.now().toString(), price: price, quantity: 1));
      }
    notifyListeners();
  }
  int get itemCount{
    return _items.length ;

  }
  double get totalAmount{
    var total=0.0;
    _items.forEach((key, value) {total+=value.price*value.quantity;});
    return total;
  }
  void removeItem(String productId)
  {
    _items.remove(productId);
    notifyListeners();
  }
  void clear(){
    _items={};
    notifyListeners();
  }
  void removeSingleItem(String prodId){
    if(!_items.containsKey(prodId)){
      return;
    }
    if(_items[prodId]!.quantity > 1){
      _items.update(prodId, (e) => CartItem(title: e.title, id: e.id, price: e.price,
          quantity:(e.quantity -1)));
    }
    else{
        _items.remove(prodId);
    }
    notifyListeners();
  }
}