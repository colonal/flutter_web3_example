import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web3_example/widget/background_widget.dart';
import 'package:web3_example/utils/connect_ethereum.dart';
import 'package:web3_example/page/home_page.dart';
import 'package:web3_example/page/voter_page.dart';

class OwnerPage extends StatefulWidget {
  static String route = "/admin";
  const OwnerPage({super.key});

  @override
  State<OwnerPage> createState() => _OwnerPageState();
}

class _OwnerPageState extends State<OwnerPage> {
  bool isLodaung = true;
  bool isAnimateFinished = true;
  bool isSetProposals = false;
  bool isMining = false;
  static List<TextEditingController> listFiled = [];
  List resultVoters = [];
  int tootleVoter = 0;
  String message = "";

  Map? transactionResponse;

  @override
  void initState() {
    ConnectEthereum.isOwner().then((value) {
      log("isOwner: $value");
      if (!value) {
        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.route, (route) => false);
      }
      getProposals();
    }).catchError(((onError) {
      log("message", error: "onError: $onError");
      Navigator.pushNamedAndRemoveUntil(
          context, HomePage.route, (route) => false);
    }));

    super.initState();
  }

  void getProposals() {
    ConnectEthereum.getProposals().then((value) {
      log("Start getProposals");
      resultVoters = [];
      listFiled = [];
      tootleVoter = 0;
      resultVoters = value;
      setState(() {
        for (var e in resultVoters) {
          listFiled.add(TextEditingController(text: e[0].toString()));
        }
        listFiled.add(TextEditingController());
        isLodaung = false;
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            for (var e in resultVoters) {
              tootleVoter += int.parse(e[1].toString());
            }
          });
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
      child: (isLodaung || isAnimateFinished)
          ? _buildLoading(size)
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * .04,
                  vertical: size.height * .05,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAddProposals(size),
                    SizedBox(width: size.width * .1),
                    Column(
                      children: [
                        _buildResultVoters(size),
                        if (transactionResponse != null)
                          SizedBox(height: size.height * .1),
                        if (transactionResponse != null)
                          _buildTransactionResponse(size)
                      ],
                    ),
                  ],
                ),
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
              TypewriterAnimatedText('welcome back .'),
              TypewriterAnimatedText('You have the powers of the owner .'),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildTransactionResponse(Size size) {
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
            const Text(
              "Transaction Response",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                letterSpacing: 2,
                height: 1.3,
                fontWeight: FontWeight.bold,
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

                return Text(
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
            const Text(
              "Result Voters",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                letterSpacing: 2,
                height: 1.3,
                fontWeight: FontWeight.bold,
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
                                  gradient: const LinearGradient(colors: [
                                    Color(0xff8A3277),
                                    Color(0xff3D30B8)
                                  ])),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      ],
                    ),
                  );
                });
              },
            ),
            if (resultVoters.isNotEmpty) const SizedBox(height: 20),
            if (resultVoters.isNotEmpty)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(VoterPage.route);
                },
                child: const Text(
                  "Go to vote ?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Container _buildAddProposals(Size size) {
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
            const Text(
              "Add Proposals",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                letterSpacing: 2,
                height: 1.3,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ListView.separated(
              itemCount: listFiled.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return _buildTextField(
                    listFiled[index], index == listFiled.length - 1, index);
              },
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                      onPressed: isMining || isSetProposals
                          ? null
                          : () {
                              List<String> names = [];
                              for (var e in listFiled) {
                                if (e.text.isNotEmpty) {
                                  names.add(e.text);
                                }
                              }
                              if (names.isEmpty) {
                                return;
                              }
                              setState(() {
                                isSetProposals = true;
                              });
                              ConnectEthereum.setProposals(names).then((value) {
                                setState(() {
                                  isSetProposals = false;

                                  isMining = true;
                                });
                                ConnectEthereum.getData(value).then((value) {
                                  setState(() {
                                    isMining = false;
                                    transactionResponse = value;
                                  });
                                  getProposals();
                                }).catchError((onError) {
                                  message = onError.toString();
                                  setState(() {
                                    isSetProposals = false;
                                    isMining = false;
                                  });
                                });
                              }).catchError((onError) {
                                message = onError.toString();
                                setState(() {
                                  isSetProposals = false;
                                  isMining = false;
                                });
                              });
                              log("names: $names");
                            },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20),
                          child: isSetProposals
                              ? const CircularProgressIndicator(
                                  color: Color(0xff6E36B6),
                                )
                              : Text(
                                  isMining ? "Mining ..." : "Save",
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
              ],
            ),
            if (message.isNotEmpty) const SizedBox(height: 10),
            if (message.isNotEmpty)
              Text(
                "Error: $message",
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

  Widget _buildTextField(TextEditingController controller, bool show, index) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: "Name",
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: const Color(0xff808080).withOpacity(0.7),
                    width: 1.5),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: const Color(0xff808080).withOpacity(0.4),
                    width: 1.5),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffe61f34), width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            onPressed: () {
              if (show) {
                listFiled.add(TextEditingController());
              } else {
                listFiled.removeAt(index);
              }
              setState(() {});
            },
            icon: (show)
                ? const Icon(
                    Icons.add,
                    color: Color(0xff2F2D6D),
                  )
                : const Icon(
                    Icons.remove,
                    color: Color(0xff8A3277),
                  ),
          ),
        )
      ],
    );
  }

  _getTootl(String resultVoter) {
    return tootleVoter == 0
        ? "0"
        : ((int.parse(resultVoter) / tootleVoter) * 100)
            .toDouble()
            .toStringAsFixed(2);
  }
}
