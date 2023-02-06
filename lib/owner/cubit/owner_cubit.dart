import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_example/home/page/home_page.dart';
import 'package:web3_example/utils/connect_ethereum.dart';

part 'owner_state.dart';

class OwnerCubit extends Cubit<OwnerState> {
  OwnerCubit() : super(OwnerInitial());

  factory OwnerCubit.get(context) => BlocProvider.of(context);

  static List<TextEditingController> listFiled = [];
  List resultVoters = [];
  int tootleVoter = 0;
  //
  bool isLodaung = true;
  bool isAnimateFinished = true;
  bool isSetProposals = false;
  bool isMining = false;
  Map? transactionResponse;
  String message = '';

  init(context) {
    ConnectEthereum.isOwner().then((value) {
      log("isOwner: $value");
      if (!value) {
        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.route, (route) => false);
      }
      getProposals(context);
    }).catchError(
      ((onError) {
        log("message", error: "onError: $onError");
        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.route, (route) => false);
      }),
    );
  }

  void getProposals(context) async {
    emit(GetProposalsLoadingState());
    try {
      final value = await ConnectEthereum.getProposals();
      log("Start getProposals");
      listFiled = [];
      tootleVoter = 0;
      resultVoters = value;

      for (var e in resultVoters) {
        listFiled.add(TextEditingController(text: e[0].toString()));
      }
      listFiled.add(TextEditingController());
      isLodaung = false;
      emit(GetProposalsState());
      Future.delayed(const Duration(milliseconds: 100), () {
        for (var e in resultVoters) {
          tootleVoter += int.parse(e[1].toString());
        }
        emit(GetProposalsState());
      });
    } catch (error) {
      emit(GetProposalsErrorState());
      log("message", error: "onError: $onError");
      Navigator.pushNamedAndRemoveUntil(
          context, HomePage.route, (route) => false);
    }
  }

  void animateFinished() {
    isAnimateFinished = false;
    emit(AnimateFinishedState());
  }

  void addProposals(context) {
    List<String> names = [];
    for (var e in listFiled) {
      if (e.text.isNotEmpty) {
        names.add(e.text);
      }
    }
    if (names.isEmpty) {
      return;
    }

    isSetProposals = true;
    emit(AddProposalsLoadingState());
    ConnectEthereum.setProposals(names).then((value) {
      isSetProposals = false;

      isMining = true;
      emit(AddProposalsLoadingState());
      ConnectEthereum.getData(value).then((value) {
        isMining = false;
        transactionResponse = value;
        emit(AddProposalsState());

        getProposals(context);
      }).catchError((onError) {
        message = onError.toString();
        isSetProposals = false;
        isMining = false;
        emit(AddProposalsErrorState());
      });
    }).catchError((onError) {
      message = onError.toString();
      isSetProposals = false;
      isMining = false;
      emit(AddProposalsErrorState());
    });
    log("names: $names");
  }

  void addField(index) {
    if (index == OwnerCubit.listFiled.length - 1) {
      OwnerCubit.listFiled.add(TextEditingController());
    } else {
      OwnerCubit.listFiled.removeAt(index);
    }
    emit(AddFieldState());
  }
}
