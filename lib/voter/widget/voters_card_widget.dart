import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/voter_cubit.dart';

class VotersCardWidget extends StatelessWidget {
  final int index;
  const VotersCardWidget({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoterCubit, VoterState>(builder: (context, state) {
      VoterCubit cubit = VoterCubit.get(context);
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
                      gradient: LinearGradient(
                        colors: cubit.isVoted
                            ? const [Color(0xff8A3277), Color(0xff3D30B8)]
                            : [
                                Colors.transparent,
                                Colors.transparent,
                              ],
                      ),
                    ),
                  ),
                ],
              ),
              MaterialButton(
                onPressed: cubit.isVoted
                    ? null
                    : () {
                        cubit.setResultVoters(context, index);
                      },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: !cubit.isVoted
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                          ],
                        )
                      : Row(
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
                                "${_getTootl(cubit, index)}%".toString(),
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
              if (cubit.indexVoted != null && index == cubit.indexVoted)
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
    });
  }

  double _getWidth(BoxConstraints s, VoterCubit cubit, int index) {
    return ((s.maxWidth - 2) * (double.parse(_getTootl(cubit, index)) / 100));
  }

  _getTootl(cubit, index) {
    return cubit.tootleVoter == 0
        ? "0"
        : ((int.parse(cubit.resultVoters[index][1].toString()) /
                    cubit.tootleVoter) *
                100)
            .toDouble()
            .toStringAsFixed(2);
  }
}
