import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:zoo_home/views/fullscreen_carousel_view.dart';

typedef OnRemoveImageCallback = Function(String key, String url);

class ProfileCarousel extends StatelessWidget {
  final List<String> imageUrls;
  final List<String> imageKeys;
  final OnRemoveImageCallback onRemoveImage;
  final bool isRemovable;
  const ProfileCarousel(
      {Key key,
      @required this.imageUrls,
      @required this.imageKeys,
      @required this.onRemoveImage,
      @required this.isRemovable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          autoPlay: false,
          enlargeCenterPage: true,
          enableInfiniteScroll: imageUrls.length > 1),
      items: imageUrls
          .asMap()
          .map((index, url) {
            return MapEntry(
              index,
              Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (routedContext) =>
                                    FullScreenCarouselView(
                                  imageUrls: imageUrls,
                                  initialImageIndex: index,
                                ),
                              ),
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                            errorWidget: (context, url, error) =>
                                Center(child: Icon(Icons.error)),
                          ),
                        ),
                        if (isRemovable)
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                if (index >= imageKeys.length) return;
                                onRemoveImage(
                                    imageKeys[index], imageUrls[index]);
                              },
                              child: Icon(
                                Icons.delete,
                                size: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          })
          .values
          .toList(),
    );
  }
}
