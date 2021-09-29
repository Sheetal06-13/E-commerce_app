import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/constants.dart';
import 'package:ecommerce_app/screens/product_page.dart';
import 'package:ecommerce_app/widgets/custom_action_bar.dart';
import 'package:ecommerce_app/widgets/product_cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
final CollectionReference _productsRef =
FirebaseFirestore.instance.collection("Product");
  @override
  Widget build(BuildContext context) {
    return Container(
     child: Stack(
       children: <Widget>[
         FutureBuilder<QuerySnapshot>(
           future: _productsRef.get(),
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
         CustomActionBar(
           title: "Home",
           hasBackArrow:false,
         ),
       ],
     ),
    );
  }
}
