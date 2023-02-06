part of 'owner_cubit.dart';

abstract class OwnerState {}

class OwnerInitial extends OwnerState {}

class GetProposalsLoadingState extends OwnerState {}

class GetProposalsState extends OwnerState {}

class GetProposalsErrorState extends OwnerState {}

class AnimateFinishedState extends OwnerState {}

class AddFieldState extends OwnerState {}

class AddProposalsLoadingState extends OwnerState {}

class AddProposalsState extends OwnerState {}

class AddProposalsErrorState extends OwnerState {}
