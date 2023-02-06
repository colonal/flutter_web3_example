import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web3/ethers.dart';
import 'package:web3_example/home/page/home_page.dart';
import 'package:web3_example/utils/connect_ethereum.dart';

part 'voter_state.dart';

class VoterCubit extends Cubit<VoterState> {
  VoterCubit() : super(VoterInitial());

  factory VoterCubit.get(context) => BlocProvider.of(context);

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

  void getProposals(context) {
    emit(GetProposalsLoadingState());
    ConnectEthereum.getProposals().then((value) {
      log("Start getProposals");
      resultVoters = [];
      tootleVoter = 0;

      resultVoters = value;
      isLodaung = false;
      emit(GetProposalsState());
      Future.delayed(const Duration(milliseconds: 100), () {
        for (var e in resultVoters) {
          tootleVoter += int.parse(e[1].toString());
        }

        emit(GetProposalsState());
      });
    }).catchError(
      ((onError) {
        emit(GetProposalsErrorState());
        log("message", error: "onError: $onError");
        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.route, (route) => false);
      }),
    );
  }

  void animateFinished() {
    isAnimateFinished = false;
    emit(AnimateFinishedState());
  }

  void setResultVoters(context, index) {
    message = "";
    isSetVoted = true;
    isAlreadyVoted = false;
    emit(ResultVotersLoadingState());
    ConnectEthereum.setVote(index).then((value) {
      message = "";
      isSetVoted = false;
      isMining = true;
      emit(ResultVotersLoadingState());
      ConnectEthereum.getData(value).then((value) {
        message = "";
        isMining = false;
        transactionResponse = value;
        isVoted = true;
        emit(ResultVotersState());
        getProposals(context);
      }).catchError((onError) {
        message = onError.toString();
        isSetVoted = false;
        isMining = false;
        emit(ResultVotersErrorState());
      });
    }).catchError((onError) {
      if (onError is EthersException) {
        log("message", error: onError.rawError.toString());
        message = onError.rawError["error"]["message"].toString();
        if (message.contains("Already voted")) {
          isVoted = true;

          ConnectEthereum.getVote().then((value) {
            log("value: $value");

            isSetVoted = false;
            isMining = false;
            isAlreadyVoted = true;
            indexVoted = value;
            emit(ResultVotersState());
          });
        }
      } else {
        message = onError.toString();
        isSetVoted = false;
        isMining = false;
        emit(ResultVotersErrorState());
      }
    });
  }
}
