import 'package:flutter/material.dart';

class TransactionResponseWidget extends StatelessWidget {
  final Map<dynamic, dynamic>? transactionResponse;
  const TransactionResponseWidget(
      {required this.transactionResponse, super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
}
