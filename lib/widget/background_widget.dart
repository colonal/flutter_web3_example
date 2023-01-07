import 'dart:ui';

import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;
  const BackgroundWidget({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Container(
              color: const Color(0xff1B1331),
              width: size.width,
              height: size.height,
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Transform.translate(
                offset: const Offset(80, -160),
                child: Container(
                  alignment: Alignment.topRight,
                  width: size.width * .5,
                  height: size.height * .5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 150,
                        spreadRadius: 40,
                        color: const Color(0xff8A3277).withOpacity(.5),
                      ),
                      BoxShadow(
                        blurRadius: 150,
                        spreadRadius: 40,
                        offset: const Offset(20, 80),
                        color: const Color(0xff3D30B8).withOpacity(.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: size.height * .1,
              child: Transform.translate(
                offset: const Offset(0, -0),
                child: Container(
                  alignment: Alignment.topRight,
                  width: size.width * .3,
                  height: size.height * .3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 150,
                        spreadRadius: 80,
                        offset: const Offset(120, 0),
                        color: const Color(0xff81349F).withOpacity(.9),
                      ),
                      BoxShadow(
                        blurRadius: 150,
                        spreadRadius: 80,
                        offset: const Offset(-100, 100),
                        color: const Color(0xff2F2D6D).withOpacity(.9),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20,
                sigmaY: 20,
              ),
              child: Container(
                width: size.width,
                height: size.height,
                color: Colors.grey.shade200.withOpacity(0.1),
              ),
            ),
            SizedBox(width: size.width, height: size.height, child: child),
          ],
        ),
      ),
    );
  }
}
