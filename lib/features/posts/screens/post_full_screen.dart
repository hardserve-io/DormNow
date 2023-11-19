import 'dart:ffi';

import 'package:dormnow/models/post_model.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key, required this.order});

  final Post order;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

const img =
    "https://static.vecteezy.com/system/resources/previews/004/141/669/large_2x/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not-available-or-image-coming-soon-sign-simple-nature-silhouette-in-frame-isolated-illustration-vector.jpg";

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade900,
          title: Text(widget.order.title),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(25),
          child: Align(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.network((widget.order.pictures.isEmpty)
                      ? img
                      : widget.order.pictures[0]),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.order.description ?? ''),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      text: "Контакти: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: widget.order.contacts ?? '',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Гуртожиток: ${widget.order.address}" ?? ''),
                ),
              ],
            ),
          ),
        ));
  }
}
