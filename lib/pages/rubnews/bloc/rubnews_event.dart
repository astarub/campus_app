part of 'rubnews_bloc.dart';

@immutable
abstract class RubnewsEvent {}

/// event when news update is requested
class NewsRequestedEvent extends RubnewsEvent {}
