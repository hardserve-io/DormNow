import 'dart:ffi';

import 'package:dormnow/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          title: Text(
            widget.order.title,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: Image.network((widget.order.pictures.isEmpty)
                    ? img
                    : widget.order.pictures[0]),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.order.title ?? '',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  (widget.order.authorUsername != null)
                      ? "Опубліковано користувачем ${widget.order.authorUsername}"
                      : "Анонімне оголошення",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white54,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 30.h,
                    width: 110.w,
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Color(0xffFFCE0C),
                      width: 1,
                    )),
                    //margin: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Ціна: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    height: 30.h,
                    width: 232.w,
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Color(0xffFFCE0C),
                          width: 1,
                        ),
                        top: BorderSide(
                          color: Color(0xffFFCE0C),
                          width: 1,
                        ),
                        bottom: BorderSide(
                          color: Color(0xffFFCE0C),
                          width: 1,
                        ),
                      ),
                    ),
                    //margin: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.center,
                    child: Text(
                      (widget.order.isFree == false)
                          ? widget.order.price.toString()
                          : "Безкоштовно",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    height: 30.h,
                    width: 110.w,
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Color(0xffFFCE0C),
                          width: 1,
                        ),
                        bottom: BorderSide(
                          color: Color(0xffFFCE0C),
                          width: 1,
                        ),
                        left: BorderSide(
                          color: Color(0xffFFCE0C),
                          width: 1,
                        ),
                      ),
                    ),
                    //margin: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Контакти: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    height: 30.h,
                    width: 232.w,
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Color(0xffFFCE0C),
                          width: 1,
                        ),
                        bottom: BorderSide(
                          color: Color(0xffFFCE0C),
                          width: 1,
                        ),
                      ),
                    ),
                    //margin: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.center,
                    child: Text(
                      widget.order.contacts,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    height: 30.h,
                    width: 110.w,
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Color(0xffFFCE0C),
                          width: 1,
                        ),
                        bottom: BorderSide(
                          color: Color(0xffFFCE0C),
                          width: 1,
                        ),
                        left: BorderSide(
                          color: Color(0xffFFCE0C),
                          width: 1,
                        ),
                      ),
                    ),
                    //margin: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Адреса: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    height: 30.h,
                    width: 232.w,
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Color(0xffFFCE0C),
                          width: 1,
                        ),
                        bottom: BorderSide(
                          color: Color(0xffFFCE0C),
                          width: 1,
                        ),
                      ),
                    ),
                    //margin: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.center,
                    child: Text(
                      (widget.order.address == null)
                          ? "-"
                          : "${widget.order.address}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: 342.w,
                child: Column(
                  children: [
                    Container(
                      width: 342.w,
                      padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xffFFCE0C),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        "ОПИС:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        (widget.order.description == null ||
                                widget.order.description == '')
                            ? "-"
                            : widget.order.description,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                    border: Border(
                  right: BorderSide(
                    color: Color(0xffFFCE0C),
                    width: 1,
                  ),
                  bottom: BorderSide(
                    color: Color(0xffFFCE0C),
                    width: 1,
                  ),
                  left: BorderSide(
                    color: Color(0xffFFCE0C),
                    width: 1,
                  ),
                )),
                //alignment: Alignment.center,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Дата публікації: ${widget.order.createdAt.hour}:${widget.order.createdAt.minute} ${widget.order.createdAt.day}.${widget.order.createdAt.month}.${widget.order.createdAt.year}",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white54,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
