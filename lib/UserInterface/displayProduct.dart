import 'package:flutter/material.dart';

class ProductDisplay extends StatelessWidget {
  const ProductDisplay({
    Key key,
    this.img,
  }) : super(key: key);

  final String img;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Products"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ProductGridCard(img: img),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductGridCard extends StatelessWidget {
  const ProductGridCard({
    Key key,
    this.img,
  }) : super(key: key);

  final String img;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(children: <Widget>[
          GridView.count(
            crossAxisCount: 2,
            primary: false,
            // to disable GridView's scrolling
            shrinkWrap: true,
            padding: const EdgeInsets.all(10.0),
            crossAxisSpacing: 10.0,
            childAspectRatio: 8.0 / 9.0,
            children: List.generate(49, (index) {
              return Container(
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        height: 160.0,
                        width: 200.0,
                        child: ClipRect(
                          child: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/saludapp-63b42.appspot.com/o/Untitled.png?alt=media&token=fd363bd9-2f84-4475-888a-1a4c74d883e6',
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(4.0),
                                    bottomRight: Radius.circular(4.0))),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Bottom",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              );
            }),
          ),
        ]),
      ),
    );
  }
}
