import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/products.dart';

class EditeProductScreen extends StatefulWidget {

static const routeName='edite-product';
  @override
  State<EditeProductScreen> createState() => _EditeProductScreenState();
}

class _EditeProductScreenState extends State<EditeProductScreen> {
  final _priceFocusNode=FocusNode();
  final _imageUrlControler=TextEditingController();
  final _form =GlobalKey<FormState>();
  var _editedProduct=Product(id: '', title: '', imageUrl: '', description: '', price: 0);
  var isInit=true;
  var isLoading=false;
  var _initValues ={
    'title':'',
    'description':'',
    'price':'',
    'imageUrl':'',
  };
  @override
  void dispose() {
    _priceFocusNode.dispose();
    _imageUrlControler.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    if(isInit){
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if(productId!=null && productId.isNotEmpty  ){
        _editedProduct =  Provider.of<Products>(context,listen: false).findById(productId);
        _initValues= {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl':'',
        };
        _imageUrlControler.text=_editedProduct.imageUrl;
      }



    };
    isInit=false;


    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
void _saveForm() async{
    final isValid= _form.currentState!.validate();
    setState(() {
      isLoading=true;
    });
    if(!isValid){
      return;
    } _form.currentState!.save();
    if(!_editedProduct.id.isEmpty  )
      {
       await Provider.of<Products>(context,listen: false).updateProduct(_editedProduct.id, _editedProduct);

      }else{
      try {
        await Provider.of<Products>(context, listen: false).addProduct(
            _editedProduct);
      }catch(error){
     await  showDialog<Null>(context: context, builder: (context) => AlertDialog(
        title: Text('an erroe ocurred!'),
         content: Text('something went wrong'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('ok'))
        ],
      )
        ,);
    // }finally{
    //     setState(() {
    //       isLoading=false;
    //     });
    //     Navigator.of(context).pop();
    //   }
      }}
      setState(() {
        isLoading=false;
      });
      Navigator.of(context).pop();

}
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edite product'),
        actions: [
          IconButton(onPressed: () {
            _saveForm();
            print('jhv');
          }, icon: Icon(Icons.save))
        ],
      ),
      body: isLoading?Center(
        child: CircularProgressIndicator(),
      ) :Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(decoration: InputDecoration(labelText: 'Title',),
                initialValue: _initValues['title'],
                validator: (value) {
                  if(value==null|| value.isEmpty){
                    return 'pls provide value';
                  }else{
                    return null;
                  }
                },
                textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (newValue) {
                    _editedProduct=Product(id: _editedProduct.id, title: newValue.toString(), imageUrl: _editedProduct.imageUrl, description: _editedProduct.description, price: _editedProduct.price,isFavorite: _editedProduct.isFavorite);
                  },
                ),
                TextFormField(decoration: InputDecoration(labelText: 'Price'),
                  initialValue: _initValues['price'],
                  validator: (value) {
                    if ( value!=null && value.isEmpty) {
                      return 'Please enter a price.';
                    }
                    if (value==null || double.tryParse(value) == null) {
                      return 'Please enter a valid number.';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Please enter a number greater than zero.';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  focusNode: _priceFocusNode,
                  onSaved: (newValue) {
                    _editedProduct=Product(id: _editedProduct.id, title: _editedProduct.title, imageUrl: _editedProduct.imageUrl, description: _editedProduct.description, price: double.parse(newValue!),isFavorite: _editedProduct.isFavorite);
                  },
                ),
                TextFormField(decoration: InputDecoration(labelText: 'Description'),
                  initialValue: _initValues['description'],
                  validator: (value) {
                    if (value==null || value.isEmpty) {
                      return 'Please enter a description.';
                    }
                    if (value.length < 10) {
                      return 'Should be at least 10 characters long.';
                    }
                    return null;
                  },
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  // onFieldSubmitted: (_) {
                  //   FocusScope.of(context).requestFocus(_priceFocusNode);
                  // },
                  onSaved: (newValue) {
                    _editedProduct=Product(id: _editedProduct.id, title: _editedProduct.title, imageUrl: _editedProduct.imageUrl, description: newValue.toString(), price: _editedProduct.price,isFavorite: _editedProduct.isFavorite);
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8,right: 10),
                      decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.grey),
                      ),
                      child: _imageUrlControler.text.isEmpty ? Text('enter Url'):
                      FittedBox(
                        child: Image.network(_imageUrlControler.text,fit: BoxFit.cover,),
                      )
                      ,
                    ),
                    Expanded(
                      child: TextFormField(decoration: InputDecoration(labelText: 'Image Url'),

                        validator: (value) {
                          if (value==null|| value.isEmpty) {
                            return 'Please enter an image URL.';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please enter a valid URL.';
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith('.jpg') &&
                              !value.endsWith('.jpeg')) {
                            return 'Please enter a valid image URL.';
                          }
                          return null;
                        },
                      keyboardType:TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlControler,
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onSaved: (newValue) {
                          _editedProduct=Product(id: _editedProduct.id, title: _editedProduct.title, imageUrl: newValue.toString(), description: _editedProduct.description, price: _editedProduct.price,isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
