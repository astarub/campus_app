import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/pages/.widgets/error_message.dart';
import 'package:campus_app/utils/pages/rubnews_utils.dart';
import 'package:campus_app/utils/widgets/campus_button.dart';
import 'package:campus_app/utils/widgets/campus_textfield.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';

class RubnewsPage extends StatefulWidget {
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const RubnewsPage({
    Key? key,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  }) : super(key: key);

  @override
  State<RubnewsPage> createState() => RubnewsPageState();
}

class RubnewsPageState extends State<RubnewsPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController textFieldController = TextEditingController();

    return Scaffold(
      backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.backgroundColor,
      body: Center(
        child: AnimatedExit(
          key: widget.pageExitAnimationKey,
          child: AnimatedEntry(
            key: widget.pageEntryAnimationKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Feed', style: TextStyle(fontFamily: 'CircularStd', fontSize: 24)),
                CampusButton(
                  text: 'Tap me',
                  onTap: () {},
                ),
                CampusTextField.icon(
                  textFieldController: textFieldController,
                  textFieldText: 'Email',
                  pathToIcon: 'assets/img/icons/mail.svg',
                ),
                CampusTextField(
                  textFieldController: textFieldController,
                  textFieldText: 'Put text here',
                  obscuredInput: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
