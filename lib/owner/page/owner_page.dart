import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_example/owner/cubit/owner_cubit.dart';
import 'package:web3_example/owner/widget/add_proposals_widget.dart';
import 'package:web3_example/owner/widget/result_voters_widget.dart';
import 'package:web3_example/widget/background_widget.dart';
import 'package:web3_example/widget/loading_animation_widget.dart';
import 'package:web3_example/widget/transaction_response_widget.dart';

class OwnerPage extends StatelessWidget {
  static String route = "/admin";
  const OwnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BackgroundWidget(
      child: BlocProvider(
        create: (context) => OwnerCubit()..init(context),
        child: BlocBuilder<OwnerCubit, OwnerState>(
          builder: (context, state) {
            OwnerCubit cubit = OwnerCubit.get(context);
            return (cubit.isLodaung || cubit.isAnimateFinished)
                ? LoadingAnimationWidget(
                    onFinished: () {
                      cubit.animateFinished();
                    },
                    title: 'welcome back .',
                    lable: 'You have the powers of the owner .',
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * .04,
                        vertical: size.height * .05,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AddProposalsWidget(),
                          SizedBox(width: size.width * .1),
                          Column(
                            children: [
                              const ResultVotersOwnerWidget(),
                              if (cubit.transactionResponse != null)
                                SizedBox(height: size.height * .1),
                              if (cubit.transactionResponse != null)
                                TransactionResponseWidget(
                                    transactionResponse:
                                        cubit.transactionResponse)
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
