import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'sized_network_image.dart';

class ImageLink extends StatelessWidget {
  ImageLink({
    Key? key,
    required this.size,
    required this.imageUrl,
    required this.url,
  }) : super(key: key);

  final String imageUrl;
  final String url;

  final Size size;

  @override
  Widget build(BuildContext context) {
    final host = Uri.tryParse(url)?.host ?? '';

    return Center(
      child: InkWell(
        onTap: () {
          launch(url);
        },
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              SizedNetworkImage(
                imageUrl: imageUrl,
                size: size,
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    color: Colors.black54,
                    height: 100,
                    width: size.width,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          host,
                          style: TextStyle(color: Colors.white),
                        ),
                        Spacer(),
                        Icon(
                          Icons.open_in_new,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
