part of 'rubnews_bloc.dart';

@immutable
abstract class RubnewsState {}

class RubnewsInitial extends RubnewsState {}

class RubnewsStateLoading extends RubnewsState {}

class RubnewsStateLoaded extends RubnewsState {
  final List<RubnewsNewsEntity> news;
  RubnewsStateLoaded({required this.news});
}

class RubnewsStateError extends RubnewsState {
  final Failure failure;
  RubnewsStateError({required this.failure});
}
