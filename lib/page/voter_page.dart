import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web3/ethers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web3_example/widget/background_widget.dart';
import 'package:web3_example/utils/connect_ethereum.dart';
import 'package:web3_example/page/home_page.dart';

class VoterPage extends StatefulWidget {
  static String route = "/voter";
  const VoterPage({super.key});

  @override
  State<VoterPage> createState() => _VoterPageState();
}

class _VoterPageState extends State<VoterPage> {
  bool isLodaung = true;
  bool isAnimateFinished = true;
  List resultVoters = [];
  int tootleVoter = 0;
  bool isVoted = false;
  bool isSetVoted = false;
  bool isMining = false;
  bool isAlreadyVoted = false;
  int? indexVoted;
  Map? transactionResponse;
  String message = "";
  @override
  void initState() {
    getProposals();
    super.initState();
  }

  void getProposals() {
    ConnectEthereum.getProposals().then((value) {
      log("Start getProposals");
      resultVoters = [];
      tootleVoter = 0;
      setState(() {
        resultVoters = value;
        isLodaung = false;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          for (var e in resultVoters) {
            tootleVoter += int.parse(e[1].toString());
          }
        });
      });
    }).catchError(((onError) {
      log("message", error: "onError: $onError");
      Navigator.pushNamedAndRemoveUntil(
          context, HomePage.route, (route) => false);
    }));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BackgroundWidget(
      child: isLodaung || isAnimateFinished
          ? _buildLoading(size)
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: size.height * .1),
                  _buildResultVoters(size),
                  if (transactionResponse != null)
                    SizedBox(height: size.height * .1),
                  if (transactionResponse != null)
                    _buildTransactionResponse(size)
                ],
              ),
            ),
    );
  }

  Center _buildLoading(Size size) {
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
            onFinished: () {
              setState(() {
                isAnimateFinished = false;
              });
            },
            animatedTexts: [
              TypewriterAnimatedText('welcome .'),
              TypewriterAnimatedText(
                  'Give your vote to someone who deserves it .'),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildResultVoters(Size size) {
    return Container(
      width: size.width * .4,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * .04,
          vertical: size.height * .05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                isVoted ? "Result Voters" : "Proposals",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  letterSpacing: 2,
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
            ListView.separated(
              itemCount: resultVoters.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return LayoutBuilder(builder: (context, s) {
                  return Container(
                    height: 50,
                    width: s.maxWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.1),
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              height: 50,
                              width: ((s.maxWidth - 2) *
                                  (double.parse(_getTootl(
                                          resultVoters[index][1].toString())) /
                                      100)),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  gradient: LinearGradient(
                                      colors: isVoted
                                          ? const [
                                              Color(0xff8A3277),
                                              Color(0xff3D30B8)
                                            ]
                                          : [
                                              Colors.transparent,
                                              Colors.transparent,
                                            ])),
                            ),
                          ],
                        ),
                        MaterialButton(
                          onPressed: isVoted
                              ? null
                              : () {
                                  setState(() {
                                    message = "";
                                    isSetVoted = true;
                                    isAlreadyVoted = false;
                                  });
                                  ConnectEthereum.setVote(index).then((value) {
                                    setState(() {
                                      message = "";
                                      isSetVoted = false;
                                      isMining = true;
                                    });

                                    ConnectEthereum.getData(value)
                                        .then((value) {
                                      setState(() {
                                        message = "";
                                        isMining = false;
                                        transactionResponse = value;
                                        isVoted = true;
                                      });
                                      getProposals();
                                    }).catchError((onError) {
                                      message = onError.toString();
                                      setState(() {
                                        isSetVoted = false;
                                        isMining = false;
                                      });
                                    });
                                  }).catchError((onError) {
                                    if (onError is EthersException) {
                                      log("message",
                                          error: onError.rawError.toString());
                                      message = onError.rawError["error"]
                                              ["message"]
                                          .toString();
                                      if (message.contains("Already voted")) {
                                        isVoted = true;

                                        ConnectEthereum.getVote().then((value) {
                                          log("value: $value");

                                          setState(() {
                                            isSetVoted = false;
                                            isMining = false;
                                            isAlreadyVoted = true;
                                            indexVoted = value;
                                          });
                                        });
                                      }
                                    } else {
                                      message = onError.toString();
                                      setState(() {
                                        isSetVoted = false;
                                        isMining = false;
                                      });
                                    }
                                  });
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            child: !isVoted
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          resultVoters[index][0].toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          resultVoters[index][0].toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "${_getTootl(resultVoters[index][1].toString())}%"
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        if (indexVoted != null && index == indexVoted)
                          const Positioned(
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.done,
                                    color: Color(0xff8A3277),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  );
                });
              },
            ),
            const SizedBox(height: 10),
            if (isSetVoted) const LinearProgressIndicator(),
            if (isMining)
              Text(
                "Mining ...",
                style: GoogleFonts.chakraPetch(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    height: 1.3,
                  ),
                ),
              ),
            if (message.isNotEmpty) const SizedBox(height: 10),
            if (message.isNotEmpty)
              isAlreadyVoted
                  ? Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Already voted",
                        style: GoogleFonts.chakraPetch(
                          textStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            height: 1.3,
                          ),
                        ),
                      ),
                    )
                  : SelectableText(
                      "$message ",
                      style: GoogleFonts.chakraPetch(
                        textStyle: TextStyle(
                          color: Colors.redAccent.withOpacity(0.7),
                          fontSize: 20,
                        ),
                      ),
                    ),
          ],
        ),
      ),
    );
  }

  _getTootl(String resultVoter) {
    return tootleVoter == 0
        ? "0"
        : ((int.parse(resultVoter) / tootleVoter) * 100)
            .toDouble()
            .toStringAsFixed(2);
  }

  _buildTransactionResponse(Size size) {
    return Container(
      width: size.width * .4,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * .04,
          vertical: size.height * .05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Transaction Response",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  letterSpacing: 2,
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
            ListView.separated(
              itemCount: transactionResponse!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                String key = transactionResponse!.keys.elementAt(index);

                return SelectableText(
                  "$key: ${transactionResponse![key]}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 20,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
