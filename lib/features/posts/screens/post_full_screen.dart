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
          backgroundColor: Color(0xff16382B),
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
                  child: Text(widget.order.description ?? '',
                      style: TextStyle(fontSize: 20)),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      text: "Контакти: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      children: [
                        TextSpan(
                          text: widget.order.contacts ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    (widget.order.address != null)
                        ? "Адреса: ${widget.order.address}"
                        : "Адреса відсутня",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
