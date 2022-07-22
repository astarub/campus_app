import 'package:campus_app/core/injection.dart';
import 'package:campus_app/pages/.widgets/error_message.dart';
import 'package:campus_app/pages/rubnews/bloc/rubnews_bloc.dart';
import 'package:campus_app/utils/pages/rubnews_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RubnewsPage extends StatelessWidget {
  const RubnewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RubnewsBloc>(),
      child: const _RubnewsPage(),
    );
  }
}

class _RubnewsPage extends StatelessWidget {
  const _RubnewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final utils = RubnewsUtils();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: BlocBuilder<RubnewsBloc, RubnewsState>(
        bloc: BlocProvider.of(context),
        builder: (context, rubnewsState) {
          if (rubnewsState is RubnewsInitial) {
            BlocProvider.of<RubnewsBloc>(context).add(NewsRequestedEvent());
          } else if (rubnewsState is RubnewsStateLoading) {
            return const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            );
          } else if (rubnewsState is RubnewsStateLoaded) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: utils.getNewsWidgetList(rubnewsState.news),
              ),
            );
          } else if (rubnewsState is RubnewsStateError) {
            return ErrorMessage(
              message: utils.mapFailureToMessage(rubnewsState.failure, context),
            );
          }

          return const Placeholder(); // TODO: throw an exception instead
        },
      ),
    );
  }
}
