import 'package:flutter/material.dart';

class ProductSize extends StatefulWidget {
  final List productSize;
  final Function(String) onSelected;
  const ProductSize({Key key, this.productSize, this.onSelected}) : super(key: key);


  @override
  _ProductSizeState createState() => _ProductSizeState();
}

class _ProductSizeState extends State<ProductSize> {
  int _selected =0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        bottom: 16,
      ),
      child: Row(
        children: <Widget>[
          for(var i=0;i<widget.productSize.length;i++)
            GestureDetector(
              onTap: (){
                widget.onSelected("${widget.productSize[i]}");
                setState(() {
                  _selected=i;
                });
              },
              child: Container(
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                  color:_selected==i ? Theme.of(context).accentColor : Colors.grey,
                  borderRadius: BorderRadius.circular(8.0)
                ),
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  "${widget.productSize[i]}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color:_selected==i ? Colors.white: Colors.black,
                    fontSize: 16
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
