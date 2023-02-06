import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingAnimationWidget extends StatelessWidget {
  final void Function()? onFinished;
  final String title;
  final String lable;
  const LoadingAnimationWidget(
      {required this.onFinished,
      required this.title,
      required this.lable,
      super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        width: size.width * .5,
        child: DefaultTextStyle(
          style: GoogleFonts.orbitron(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 70,
              letterSpacing: 2,
              height: 1.3,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: AnimatedTextKit(
            totalRepeatCount: 1,
            pause: const Duration(milliseconds: 500),
            onFinished: onFinished,
            animatedTexts: [
              TypewriterAnimatedText(title),
              TypewriterAnimatedText(lable),
            ],
          ),
        ),
      ),
    );
  }
}
