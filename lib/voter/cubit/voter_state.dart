part of 'voter_cubit.dart';

abstract class VoterState {}

class VoterInitial extends VoterState {}

class GetProposalsLoadingState extends VoterState {}

class GetProposalsState extends VoterState {}

class GetProposalsErrorState extends VoterState {}

class AnimateFinishedState extends VoterState {}

class ResultVotersLoadingState extends VoterState {}

class ResultVotersState extends VoterState {}

class ResultVotersErrorState extends VoterState {}
