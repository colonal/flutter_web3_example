import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web3_example/voter/cubit/voter_cubit.dart';
import 'package:web3_example/voter/widget/voters_card_widget.dart';

class ResultVotersWidget extends StatelessWidget {
  const ResultVotersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<VoterCubit, VoterState>(builder: (context, state) {
      VoterCubit cubit = VoterCubit.get(context);
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
                  cubit.isVoted ? "Result Voters" : "Proposals",
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
                itemCount: cubit.resultVoters.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return VotersCardWidget(index: index);
                },
              ),
              const SizedBox(height: 10),
              if (cubit.isSetVoted) const LinearProgressIndicator(),
              if (cubit.isMining)
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
              if (cubit.message.isNotEmpty) const SizedBox(height: 10),
              if (cubit.message.isNotEmpty)
                cubit.isAlreadyVoted
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
                        "${cubit.message} ",
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
    });
  }
}
