import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_example/voter/page/voter_page.dart';

import '../cubit/owner_cubit.dart';

class ResultVotersOwnerWidget extends StatelessWidget {
  const ResultVotersOwnerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<OwnerCubit, OwnerState>(builder: (context, state) {
      OwnerCubit cubit = OwnerCubit.get(context);
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
                itemCount: cubit.resultVoters.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
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
                                width: _getWidth(s, cubit, index),
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
                                    cubit.resultVoters[index][0].toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    "${_getTootl(cubit, cubit.resultVoters[index][1].toString())}%"
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
              if (cubit.resultVoters.isNotEmpty) const SizedBox(height: 20),
              if (cubit.resultVoters.isNotEmpty)
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
    });
  }

  double _getWidth(BoxConstraints s, OwnerCubit cubit, int index) {
    return ((s.maxWidth - 2) *
        (double.parse(
                _getTootl(cubit, cubit.resultVoters[index][1].toString())) /
            100));
  }

  _getTootl(OwnerCubit cubit, String resultVoter) {
    return cubit.tootleVoter == 0
        ? "0"
        : ((int.parse(resultVoter) / cubit.tootleVoter) * 100)
            .toDouble()
            .toStringAsFixed(2);
  }
}
