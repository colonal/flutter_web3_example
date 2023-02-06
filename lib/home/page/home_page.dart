import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web3_example/home/cubit/home_cubit.dart';
import 'package:web3_example/widget/background_widget.dart';

class HomePage extends StatelessWidget {
  static String route = "/";
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BackgroundWidget(
      child: Row(
        children: [
          SizedBox(width: size.width * .05),
          _buidLeftSide(size),
          _buildRightSide(),
        ],
      ),
    );
  }

  _buidLeftSide(Size size) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.height * .05),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "WELCOME\nTO SMART\nVOTING",
              style: GoogleFonts.orbitron(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 70,
                  letterSpacing: 2,
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Flexible(
            child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * .03),
              Flexible(
                child: Text(
                  "You need to connect METAMASK",
                  style: GoogleFonts.chakraPetch(
                    textStyle: TextStyle(
                      color: Colors.white.withOpacity(.8),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * .03),
              _buildStart(size),
            ],
          ),
        )),
      ],
    ));
  }

  _buildStart(size) =>
      BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
        HomeCubit cubit = HomeCubit.get(context);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: MaterialButton(
                  onPressed: () {
                    cubit.connect(context);
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 20),
                      child: state is ConnectLoadingState
                          ? const CircularProgressIndicator(
                              color: Color(0xff6E36B6))
                          : Text(
                              "Start Now",
                              style: GoogleFonts.chakraPetch(
                                textStyle: const TextStyle(
                                  color: Color(0xff6E36B6),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  height: 1.3,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            if (state is ConnectErrorState) SizedBox(height: size.height * .01),
            if (state is ConnectErrorState)
              Flexible(
                child: Text(
                  "Error: ${state.message}",
                  style: GoogleFonts.chakraPetch(
                    textStyle: TextStyle(
                      color: Colors.redAccent.withOpacity(0.7),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
          ],
        );
      });

  _buildRightSide() {
    return Expanded(
      child: Align(
        alignment: Alignment.topCenter,
        child: Image.asset("assets/images/img.png"),
      ),
    );
  }
}
