part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class ConnectLoadingState extends HomeState {}

class ConnectState extends HomeState {}

class ConnectErrorState extends HomeState {
  final String message;
  ConnectErrorState({
    required this.message,
  });
}
