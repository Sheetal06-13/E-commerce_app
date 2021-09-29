import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/constants.dart';
import 'package:ecommerce_app/screens/product_page.dart';
import 'package:ecommerce_app/services/firebase_services.dart';
import 'package:ecommerce_app/widgets/custom_action_bar.dart';
import 'package:ecommerce_app/widgets/custom_input.dart';
import 'package:ecommerce_app/widgets/product_cart.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FirebaseServices _firebaseServices=FirebaseServices();

  String _searchString="";

  @override
  Widget build(BuildContext context) {
    return   Container(
      child: Stack(
        children: <Widget>[
          if(_searchString.isEmpty)
            Center(
              child: Container(
                child: Text("Search Results",
                style: Constants.regularDarkText,
                ),
              ),
            )
          else
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.productsRef.orderBy("name").
        startAt([_searchString]).endAt(["$_searchString\uf8ff"])
        .get(),
            builder: (context,snapshot){
              if(snapshot.hasError){
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              //Collection data ready to display
              if(snapshot.connectionState== ConnectionState.done){
                //Display the data inside a list value
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 100.0,
                      bottom: 24
                  ),
                  child: ListView(
                    children:snapshot.data.docs.map((document){
                      return ProductCart(
                        title: document.data()['name'],
                        imageUrl: document.data()['images'][0],
                        price: "\$${document.data()['price']}",
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context)=>ProductPage(
                                productId: document.id,
                              )));
                        },
                      );
                    }
                    ).toList(),
                  ),
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
          Padding(
            padding: const EdgeInsets.only(top: 45.0),
            child: CustomInput(
              hinText: "Search here...",
              onSubmitted: (value){
                if(value.isNotEmpty){
                setState(() {
                  _searchString=value;
                });
                }
              },
            ),
          ),



        ],
      )
    );
  }
}
