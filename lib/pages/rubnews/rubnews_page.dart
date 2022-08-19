import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/pages/.widgets/error_message.dart';
import 'package:campus_app/utils/pages/rubnews_utils.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';
import 'package:campus_app/utils/widgets/campus_textfield.dart';

class RubnewsPage extends StatelessWidget {
  const RubnewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final utils = RubnewsUtils();
    final TextEditingController textFieldController = TextEditingController();

    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('News Page', style: TextStyle(fontFamily: 'CircularStd', fontSize: 24)),
              CampusButton(
                text: 'Tap me',
                onTap: () {},
              ),
              CampusTextField(
                textFieldController: textFieldController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
