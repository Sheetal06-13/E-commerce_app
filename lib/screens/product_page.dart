import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/constants.dart';
import 'package:ecommerce_app/services/firebase_services.dart';
import 'package:ecommerce_app/widgets/custom_action_bar.dart';
import 'package:ecommerce_app/widgets/image_swipe.dart';
import 'package:ecommerce_app/widgets/product_size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  const ProductPage({Key key, this.productId}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}
class _ProductPageState extends State<ProductPage> {
  FirebaseServices _firebaseServices=FirebaseServices();
  String _selectedProductSize="0";

  //add the data to user cart query
  Future _addToCart(){
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(widget.productId)
        .set(
      {
        "size" :_selectedProductSize
      }
    );
  }

  Future _addToSaved(){
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Saved")
        .doc(widget.productId)
        .set(
        {
          "size" :_selectedProductSize
        }
    );
  }

  // user know that he added product to cart using snackbar
  final SnackBar _snackBar=SnackBar(content: Text("Product added to the Cart"),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FutureBuilder(
            future: _firebaseServices.productsRef.doc(widget.productId).get(),
            builder: (context,snapshot){
              if(snapshot.hasError){
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              if(snapshot.connectionState==ConnectionState.done){
                //firebase Document Data Map
                Map<String,dynamic> documentData =snapshot.data.data();

                //List of images
                List imageList=documentData['images'];
                List productSize=documentData['size'];

                //set an initial size
                _selectedProductSize=productSize[0];

                return ListView(
                  padding: EdgeInsets.all(0.0),
                  children: <Widget>[
                    ImageSwipe(
                      imageList:imageList,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24,
                        left: 24,
                        right: 24,
                        bottom: 4
                      ),
                      child: Text("${documentData['name']}" ?? "Product Name",style: Constants.boldHeading,),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 24),
                      child: Text("\₹${documentData['price']}" ?? "Price",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600
                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 24),
                      child: Text("${documentData['desc']}" ?? "Description",
                        style: TextStyle(
                            fontSize: 16.0,
                        ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 24),
                      child: Text("Select size",style: Constants.regularDarkText,),
                    ),
                    ProductSize(
                      productSize: productSize,
                      onSelected: (size){
                        _selectedProductSize=size;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async{
                              await _addToSaved();
                              Scaffold.of(context).showSnackBar(_snackBar);
                            },
                            child: Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                color: Color(0xFFDCDCDC),
                                borderRadius: BorderRadius.circular(12.0)
                              ),
                              alignment: Alignment.center,
                              child: Image(
                                  image:AssetImage("assets/images/saved.png"),

                                 height: 30.0,
                              ),

                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async{
                                await _addToCart();
                                Scaffold.of(context).showSnackBar(_snackBar);
                              },
                              child: Container(
                                height: 65,
                                margin: EdgeInsets.only(
                                  left: 20
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.0)
                                ),
                                alignment: Alignment.center,
                                child: Text("Add to Cart"
                                ,style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              }


              //loading state
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          CustomActionBar(
            hasBackArrow: true,
            hasTitle: false,
            hasBackground: false,
          )
        ],
      )
    );
  }
}
