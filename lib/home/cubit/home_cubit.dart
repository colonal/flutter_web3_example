import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_example/owner/page/owner_page.dart';

import '../../voter/page/voter_page.dart';
import '../../utils/connect_ethereum.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  factory HomeCubit.get(context) => BlocProvider.of<HomeCubit>(context);

  connect(context) async {
    emit(ConnectLoadingState());
    try {
      await ConnectEthereum.init();
    } catch (error) {
      emit(ConnectErrorState(message: error.toString()));
      return;
    }

    try {
      final isOwner = await ConnectEthereum.isOwner();
      emit(ConnectState());
      if (isOwner) {
        Navigator.of(context).pushNamed(OwnerPage.route);
      } else {
        Navigator.of(context).pushNamed(VoterPage.route);
      }
    } catch (error) {
      emit(ConnectErrorState(message: error.toString()));
    }
  }
}
