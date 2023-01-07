import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web3_example/widget/background_widget.dart';
import 'package:web3_example/utils/connect_ethereum.dart';
import 'package:web3_example/page/owner_page.dart';
import 'package:web3_example/page/voter_page.dart';

class HomePage extends StatefulWidget {
  static String route = "/";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  String message = "";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BackgroundWidget(
      child: Row(
        children: [
          SizedBox(width: size.width * .05),
          buidLeftSide(size),
          buildRightSide(),
        ],
      ),
    );
  }

  Expanded buidLeftSide(Size size) {
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
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      ConnectEthereum.init().then((value) {
                        ConnectEthereum.isOwner().then((value) {
                          setState(() {
                            isLoading = false;
                          });
                          if (value) {
                            Navigator.of(context).pushNamed(OwnerPage.route);
                          } else {
                            Navigator.of(context).pushNamed(VoterPage.route);
                          }
                        }).catchError((error) {
                          setState(() {
                            message = error.toString();
                            isLoading = false;
                          });
                        });
                      }).catchError((error) {
                        setState(() {
                          message = error.toString();
                          isLoading = false;
                        });
                      });
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20),
                        child: isLoading
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
              if (message.isNotEmpty) SizedBox(height: size.height * .01),
              if (message.isNotEmpty)
                Flexible(
                  child: Text(
                    "Error: $message",
                    style: GoogleFonts.chakraPetch(
                      textStyle: TextStyle(
                        color: Colors.redAccent.withOpacity(0.7),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        )),
      ],
    ));
  }

  Expanded buildRightSide() {
    return Expanded(
        child: Align(
            alignment: Alignment.topCenter,
            child: Image.asset("assets/images/img.png")));
  }
}
