part of 'home_page_cubit.dart';

@immutable
class HomePageState {
  const HomePageState({
    this.results = const [],
    this.status = Status.initial,
    this.errorMessage,
  });

  final List results;
  final Status status;
  final String? errorMessage;
}
