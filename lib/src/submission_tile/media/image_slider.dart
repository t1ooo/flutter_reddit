import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({
    Key? key,
    required this.items,
    required this.height,
  }) : super(key: key);

  final List<Widget> items;
  final double height;

  @override
  State<StatefulWidget> createState() {
    return _ImageSliderState();
  }
}

class _ImageSliderState extends State<ImageSlider> {
  final _controller = CarouselController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  bool get _hasNext => _currentPage + 1 < widget.items.length;
  bool get _hasPrev => _currentPage > 0;

  void _next() {
    _controller.nextPage();
    setState(() {
      _currentPage += 1;
    });
  }

  void _prev() {
    _controller.previousPage();
    setState(() {
      _currentPage -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.length == 1) {
      return widget.items.first;
    }

    return Stack(
      children: [
        CarouselSlider(
          items: widget.items,
          options: CarouselOptions(
            height: widget.height,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
          ),
          carouselController: _controller,
        ),
        Positioned.fill(
          child: Align(
            child: Row(
              children: [
                if (_hasPrev)
                  IconButton(
                    onPressed: _prev,
                    icon: _icon(Icons.arrow_back_ios),
                  ),
                Spacer(),
                if (_hasNext)
                  IconButton(
                    onPressed: _next,
                    icon: _icon(Icons.arrow_forward_ios),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _icon(IconData icon) {
    return Container(
      decoration: ShapeDecoration(
        shadows: const [
          BoxShadow(
            color: Colors.white,
            blurRadius: 15,
            spreadRadius: 15,
          )
        ],
        shape: CircleBorder(),
      ),
      child: Icon(
        Icons.arrow_forward_ios,
        color: Colors.black87,
      ),
    );
  }
}
