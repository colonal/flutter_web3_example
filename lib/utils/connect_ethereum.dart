import 'dart:developer';
import 'dart:html' as html;

import 'package:flutter_web3/ethereum.dart';
import 'package:flutter_web3/ethers.dart';
import 'package:web3_example/keys/env.dart';

import '../keys/api.dart';

class ConnectEthereum {
  static Web3Provider? provider;
  static Contract? busd;
  static String? userAddress;

  static Future<void> init() async {
    html.window.console.debug("connectWallet");

    if (ethereum != null) {
      var accs = await ethereum!.requestAccount();
      log("accs: ${accs[0]}");
      userAddress = accs[0];

      provider = Web3Provider(ethereum!);

      busd = Contract(
        Env.addressKey,
        Interface(abi),
        provider!.getSigner(),
      );
      log("busd");
    } else {
      log("message", error: "Can Not Connect ethereum");
      throw "Can Not Connect ethereum";
    }
  }

  static Future<List> getProposals() async {
    final proposals = await busd!.call('getProposals');
    html.window.console.debug("proposals: $proposals");
    return proposals;
  }

  static Future<bool> isOwner() async {
    return await busd!.call('isOwner');
  }

  static Future<TransactionResponse> setProposals(List names) async {
    final proposals = await busd!.send('setProposalNames', [names]);
    html.window.console.debug("proposals: $proposals");
    return proposals;
  }

  static Future<TransactionResponse> setVote(int index) async {
    html.window.console.debug("index: $index");
    final vote = await busd!.send('vote', [index]);
    html.window.console.debug("vote: $vote");
    return vote;
  }

  static Future<int> getVote() async {
    final getVote = await busd!.call('showVote');
    return int.parse(getVote.toString());
  }

  static Future<Map> getData(TransactionResponse transactionResponse) async {
    final receipt = await transactionResponse.wait();

    final status = receipt.status;
    final from = receipt.from;
    final to = receipt.to;
    final blockHash = receipt.blockHash;
    final blockNumber = receipt.blockNumber;
    final contractAddress = receipt.contractAddress;
    final used = receipt.gasUsed;
    final gasUsed = receipt.cumulativeGasUsed;
    final gasLimit = transactionResponse.gasLimit;
    final gasPrice = transactionResponse.gasPrice;

    return {
      "status": status.toString(),
      "from": from.toString(),
      "to": to.toString(),
      "blockHash": blockHash.toString(),
      "blockNumber": blockNumber.toString(),
      "contractAddress": contractAddress.toString(),
      "used": used.toString(),
      "Gas Used": gasUsed.toString(),
      "Gas Limit": gasLimit.toString(),
      "Gas Price": gasPrice.toString(),
    };
  }
}
