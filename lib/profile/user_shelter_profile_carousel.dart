import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class UserShelterProfileCarousel extends StatelessWidget {
  final List<String> images;
  const UserShelterProfileCarousel({Key key, @required this.images})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(height: 300.0, autoPlay: false),
      items: images.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(color: Colors.amber),
              child: Center(
                child: Image.network(image, fit: BoxFit.cover, width: 500),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
