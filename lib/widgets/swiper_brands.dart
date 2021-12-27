import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SwiperBrands extends StatefulWidget {
  const SwiperBrands({Key? key}) : super(key: key);

  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<SwiperBrands> {
  final List<String> imgList = [
    'assets/images/addidas.jpg',
    'assets/images/apple.jpg',
    'assets/images/Dell.jpg',
    'assets/images/h&m.jpg',
    'assets/images/Huawei.jpg',
    'assets/images/nike.jpg',
    'assets/images/samsung.jpg',
  ];

  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList
        .map((item) => InkWell(
      onTap: (){

      },
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Image.asset(item)
          )
      ),
    )).toList();
    return CarouselSlider(
      items: imageSliders,
      carouselController: _controller,
      options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 2.0,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          }),
    );
  }
}
