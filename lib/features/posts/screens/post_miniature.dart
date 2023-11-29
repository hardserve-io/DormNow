import "package:dormnow/core/constants/constants.dart";
import "package:dormnow/models/post_model.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "post_full_screen.dart";
import "package:dormnow/router.dart";
import 'package:routemaster/routemaster.dart';

class OrderMiniature extends StatefulWidget {
  const OrderMiniature({super.key, required this.order});

  final Post order;

  @override
  State<OrderMiniature> createState() => _OrderMiniature();
}

class _OrderMiniature extends State<OrderMiniature> {
  void expandOrder() {
    Routemaster.of(context).push('/post/${widget.order.id}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: Color(0xFF16382B),
            width: 0.01, //<-- SEE HERE
          ),
        ),
        shadowColor: Colors.black,
        color: Color(0xFF16382B),
        elevation: 3.0,
        margin: EdgeInsets.only(bottom: 10),
        // child: GestureDetector(
        child: Container(
          height: 150.h,
          width: 340.w,
          child: Container(
            //color: const Color(0xff001535),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 125.h,
                  width: 125.w,
                  margin: EdgeInsets.all(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      (widget.order.pictures.isEmpty) ? Constants.postThumbnailDefault : widget.order.pictures[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      child: Container(
                        width: 180.w,
                        //height: 72.h,
                        child: Text(
                          widget.order.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        (widget.order.price != 0.0 && widget.order.price != null)
                            ? "${widget.order.price}₴"
                            : "Безкоштовно",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: (widget.order.price != 0.0 && widget.order.price != null)
                              ? Colors.white
                              : Color(0xffFEF6EA),
                        ),
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      width: 180.w,
                      padding: EdgeInsets.only(bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 140.w,
                            //height: 17.h,
                            //margin: EdgeInsets.only(top: 0),
                            child: Text(
                              (widget.order.address != null) ? "Адреса: ${widget.order.address}" : "Адреса відсутня",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          /*IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              alignment: Alignment.topLeft,
                              icon: widget.order.isFavourite!
                                  ? Icon(Icons.favorite)
                                  : Icon(Icons.favorite_outline),
                              color: Color(0xffEF3E36),
                              iconSize: 22,
                              onPressed: () {
                                setState(() {
                                  widget.order.favouriteChangeState();
                                  //print(widget.order.isFavourite);
                                });
                              },
                            ),*/
                          //Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        //   onTap: () => expandOrder(),
        // ),
      ),
      onTap: () => expandOrder(),
    );
  }
}
