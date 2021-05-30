import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ProfileCarousel extends StatelessWidget {
  final List<String> images;
  const ProfileCarousel({Key key, @required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          height: 250.0,
          autoPlay: false,
          enableInfiniteScroll: images.length > 1),
      items: images.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              //decoration: BoxDecoration(color: Colors.amber),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  width: 500,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
