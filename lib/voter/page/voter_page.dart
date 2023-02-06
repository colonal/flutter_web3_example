import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_example/voter/cubit/voter_cubit.dart';
import 'package:web3_example/voter/widget/result_voters_widgte.dart';
import 'package:web3_example/widget/background_widget.dart';
import 'package:web3_example/widget/loading_animation_widget.dart';
import 'package:web3_example/widget/transaction_response_widget.dart';

class VoterPage extends StatelessWidget {
  static String route = "/voter";
  const VoterPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BackgroundWidget(
      child: BlocProvider<VoterCubit>(
        create: (context) => VoterCubit()..getProposals(context),
        child: BlocBuilder<VoterCubit, VoterState>(
          builder: (context, state) {
            VoterCubit cubit = VoterCubit.get(context);
            return cubit.isLodaung || cubit.isAnimateFinished
                ? LoadingAnimationWidget(
                    onFinished: () {
                      cubit.animateFinished();
                    },
                    title: 'welcome .',
                    lable: 'Give your vote to someone who deserves it .',
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: size.height * .1),
                        const ResultVotersWidget(),
                        if (cubit.transactionResponse != null)
                          SizedBox(height: size.height * .1),
                        if (cubit.transactionResponse != null)
                          TransactionResponseWidget(
                              transactionResponse: cubit.transactionResponse)
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
