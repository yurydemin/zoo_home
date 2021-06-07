import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FullScreenCarouselView extends StatelessWidget {
  final List<String> imageUrls;
  final int initialImageIndex;
  const FullScreenCarouselView(
      {Key key, @required this.imageUrls, @required this.initialImageIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          final double height = MediaQuery.of(context).size.height;
          return CarouselSlider(
            options: CarouselOptions(
              initialPage: initialImageIndex,
              height: height,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
            ),
            items: imageUrls.map((url) {
              return Container(
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    height: height,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress),
                    ),
                    errorWidget: (context, url, error) =>
                        Center(child: Icon(Icons.error)),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
