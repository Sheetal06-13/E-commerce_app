import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/constants.dart';
import 'package:ecommerce_app/screens/cart_page.dart';
import 'package:ecommerce_app/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrow;
  final bool hasTitle;
  final bool hasBackground;
   CustomActionBar({Key key, this.title, this.hasBackArrow, this.hasTitle, this.hasBackground}) : super(key: key);

  //for user cart
  //User->UserId(document) ->Cart ->ProductId(Document)
  final CollectionReference _usersRef =
  FirebaseFirestore.instance.collection("Users");

  FirebaseServices _firebaseServices=FirebaseServices();



  @override
  Widget build(BuildContext context) {
    bool _hasBackArrow=hasBackArrow ?? false;
    bool _hasTitle= hasTitle ?? true;
    bool _hasBackground=hasBackground ?? true;



    return Container(
      decoration: BoxDecoration(
        gradient:_hasBackground ? LinearGradient(colors: [
          Colors.white,
          Colors.white.withOpacity(0.0),
        ],
        begin: Alignment(0, 0),
          end: Alignment(0,1)
        ):null
      ),
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: 56.0,
        bottom: 50.0
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if(_hasBackArrow)
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(

                width: 42,
                height: 42,
                decoration:BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0)
                ),
                alignment: Alignment.center,
                child:Image(image: AssetImage("assets/images/backarrow.png"),
                color: Colors.white,
                  width: 24.0,
                  height: 24,
                ) ,
              ),
            ),

          if(_hasTitle)
            Text(title ?? "Action tab",
              style: Constants.boldHeading,
            ),

          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder:(context) => CartPage(),
              ));
            },
            child: Container(
              width: 42,
              height: 42,
              decoration:BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0)
              ),
              alignment: Alignment.center,
              child: StreamBuilder(
                stream: _usersRef.doc(_firebaseServices.getUserId()).collection("Cart").snapshots(),
                  builder: (context,snapshot){
                  int _totalItem=0;

                  if(snapshot.connectionState==ConnectionState.active){
                    List _documents=snapshot.data.docs;
                    _totalItem=_documents.length;
                  }

                    return Text("$_totalItem" ?? "0",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: Colors.white
                      ),
                    );
                  }
              ),
            ),
          )
        ],
      ),
    );
  }
}
