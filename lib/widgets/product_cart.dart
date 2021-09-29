import 'package:ecommerce_app/screens/product_page.dart';
import 'package:flutter/material.dart';

class ProductCart extends StatelessWidget {
  final String productId;
  final Function onPressed;
  final String imageUrl;
  final String name;
  final String price;
  final String title;
  const ProductCart({Key key, this.onPressed, this.imageUrl, this.name, this.price, this.productId, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),

        margin: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "$imageUrl" ,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(title,
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w800
                      ) ,),
                    Text(price,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
