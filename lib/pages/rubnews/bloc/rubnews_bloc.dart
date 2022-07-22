import 'package:bloc/bloc.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/rubnews/rubnews_news_entity.dart';
import 'package:campus_app/pages/rubnews/rubnews_usecases.dart';
import 'package:meta/meta.dart';

part 'rubnews_event.dart';
part 'rubnews_state.dart';

class RubnewsBloc extends Bloc<RubnewsEvent, RubnewsState> {
  final RubnewsUsecases usecases;

  RubnewsBloc({required this.usecases}) : super(RubnewsInitial()) {
    on<RubnewsEvent>((event, emit) {});

    on<NewsRequestedEvent>((event, emit) async {
      emit(RubnewsStateLoading());

      final newsOrFailure = await usecases.getNewsList();

      newsOrFailure.fold(
        (failure) => emit(RubnewsStateError(failure: failure)),
        (news) => emit(RubnewsStateLoaded(news: news)),
      );
    });
  }
}
