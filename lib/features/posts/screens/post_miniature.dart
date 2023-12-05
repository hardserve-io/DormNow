import 'package:cached_network_image/cached_network_image.dart';
import "package:dormnow/core/constants/constants.dart";
import "package:dormnow/models/post_model.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
// import 'package:dormnow/core/common/error_text.dart';
import 'package:dormnow/core/common/loader.dart';
// import 'package:dormnow/core/constants/constants.dart';
import 'package:dormnow/features/auth/controller/auth_controller.dart';
import 'package:dormnow/features/posts/controller/post_controller.dart';
import 'package:dormnow/features/user_profile/controller/user_profile_controller.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import "post_full_screen.dart";
// import "package:dormnow/router.dart";
import 'package:routemaster/routemaster.dart';

class OrderMiniature extends ConsumerStatefulWidget {
  final VoidCallback refreshParent;
  const OrderMiniature(
      {super.key, required this.order, required this.refreshParent});

  final Post order;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderMiniature();
}

class _OrderMiniature extends ConsumerState<OrderMiniature> {
  void expandOrder() async {
    if (await ref
        .read(postContollerProvider.notifier)
        .doesPostExist(widget.order.id)) {
      if (context.mounted) {
        Routemaster.of(context).push('/post/${widget.order.id}');
      }
    } else {
      widget.refreshParent();
      if (context.mounted) {
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              backgroundColor: const Color(0xff16382B),
              title: const Text(
                'Увага',
                style: TextStyle(color: Color(0xFFFFCE0C)),
              ),
              content: const Text(
                'Це оголошення більше не доступне',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xffFFCE0C),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child:
                        const Text('ОК', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void toggleFavorites() {
    ref
        .read(userProfileControllerProvider.notifier)
        .addOrRemoveFromFavorites(context, widget.order.id);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    bool liked = user!.likedMarketAdverts.contains(widget.order.id);
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Color(0xFF16382B),
            width: 0.01, //<-- SEE HERE
          ),
        ),
        shadowColor: Colors.black,
        color: const Color(0xFF16382B),
        elevation: 3.0,
        margin: const EdgeInsets.only(bottom: 10),
        // child: GestureDetector(
        child: Container(
          height: 150.h,
          width: 340.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 125.h,
                width: 125.w,
                margin: const EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: (widget.order.pictures.isEmpty)
                        ? Constants.postThumbnailDefault
                        : widget.order.pictures[0],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Loader(),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      width: 180.w,
                      //height: 72.h,
                      child: Text(
                        widget.order.title,
                        style: const TextStyle(
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
                        color: (widget.order.price != 0.0 &&
                                widget.order.price != null)
                            ? Colors.white
                            : const Color(0xffFEF6EA),
                      ),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    width: 180.w,
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 140.w,
                          //height: 17.h,
                          //margin: EdgeInsets.only(top: 0),
                          child: Text(
                            (widget.order.address != null)
                                ? "Адреса: ${widget.order.address}"
                                : "Адреса відсутня",
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(minWidth: 10, minHeight: 10),
                          alignment: Alignment.topLeft,
                          icon: liked
                              ? const Icon(Icons.favorite)
                              : const Icon(Icons.favorite_outline),
                          color: const Color(0xffFFCE0C),
                          iconSize: 22,
                          onPressed: () {
                            toggleFavorites();
                            setState(() {});
                          },
                        ),
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
      onTap: () => expandOrder(),
    );
  }
}
