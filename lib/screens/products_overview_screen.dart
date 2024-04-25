import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../provider/product.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart'as Badge2;

enum FilterOptions{
  Favorites,
  All

}


class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isLoading=false;
  // final List<Product> loadedProduct;
@override
  void initState() {
  setState(() {
    _isLoading=true;
  });

  Provider.of<Products>(context,listen: false).fetchAndSetProduct().then((value) {setState(() {
    _isLoading=false;
  });});
  // TODO: implement initState
    super.initState();
  }
 bool showFav=false;
  @override
  Widget build(BuildContext context) {
    // final productContainer=Provider.of<Products>(context,listen: false);
    return  Scaffold(
      appBar:AppBar(

        title: Text('myshop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions value) {
              setState(() {
                if(value== FilterOptions.Favorites){
                  showFav=true;
                }else
                {
                  showFav=false;
                }
              });

            },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(child: Text('only fav'),value: FilterOptions.Favorites,),
                PopupMenuItem(child: Text('show all'),value: FilterOptions.All,),
              ],),
         Consumer<Cart>(builder: (_, cart, cf) => Badge2.Badge(
           value: cart.itemCount.toString(),
           child:cf as Widget,
    ),
    child: IconButton(onPressed:() {
Navigator.of(context).pushNamed(CartScreen.routName);
    }, icon: Icon(Icons.shopping_cart),),

         ),
        ],
      ) ,
      drawer: AppDrawer(),
      body:_isLoading?Center(
        child: CircularProgressIndicator(),
      ) :ProductGrid(showFav),
    );
  }
}



