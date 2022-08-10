import 'package:flutter/material.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/pages/.widgets/error_message.dart';
import 'package:campus_app/utils/pages/rubnews_utils.dart';

class RubnewsPage extends StatelessWidget {
  const RubnewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final utils = RubnewsUtils();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
          //children: utils.getNewsWidgetList(rubnewsState.news),
          ),
    );
  }
}
