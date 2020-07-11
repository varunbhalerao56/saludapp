import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:saludsingapore/models/Bundles.dart';
import 'package:saludsingapore/models/Products.dart';
import 'package:saludsingapore/seller_settings//edit_product.dart';


class RowSlider extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final productName = Provider.of<List<products>>(context);
    return Center(
      child: Container(
        width: width > 992 ? 992 : width * 0.95,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (var data in productName)
                ProductCard(text: data.text, img: data.img, price: data.price,),
              SizedBox(
                width: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ProductCard extends StatelessWidget {
  const ProductCard({
    Key key, this.text, this.img, this.price, this.cardWidth }) :super (key:key);

  final int cardWidth;
  final String text;
  final String img;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 200,
      child: Card(
        elevation: 5,
        child: Column(children:  <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          SizedBox(height:  30,),
          Container(
            height: 200.0,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
              child:  Image(image: NetworkImage(img))
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 9),
            child: Text(
              price,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ],),
      ),
    );
  }
}
