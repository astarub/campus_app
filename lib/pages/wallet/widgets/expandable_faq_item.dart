import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';
import 'package:campus_app/utils/widgets/animated_expandable.dart';
import 'package:campus_app/utils/widgets/styled_html.dart';

/// This widget displays one faq entry with its title and content
/// in the guide page.
class ExpandableFaqItem extends StatefulWidget {
  /// The title of the faq entry
  final String title;

  /// The content of the faq entry
  final String content;

  const ExpandableFaqItem({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  State<ExpandableFaqItem> createState() => _ExpandableFaqItemState();
}

class _ExpandableFaqItemState extends State<ExpandableFaqItem> {
  /// Key to acess the state of the AnimatedExpandable() for showing & hiding the content
  final GlobalKey<AnimatedExpandableState> faqItemExpandableKey = GlobalKey();

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))],
      ),
      child: Column(
        children: [
          // FaqItem header
          Material(
            color: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              splashColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                  ? const Color.fromRGBO(0, 0, 0, 0.04)
                  : const Color.fromRGBO(255, 255, 255, 0.04),
              highlightColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                  ? const Color.fromRGBO(0, 0, 0, 0.03)
                  : const Color.fromRGBO(255, 255, 255, 0.03),
              onTap: () {
                setState(() => _isExpanded = !_isExpanded);
                faqItemExpandableKey.currentState!.toggleExpand();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelLarge,
                    ),
                    Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),
          ),
          // Content
          AnimatedExpandable(
            key: faqItemExpandableKey,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 14),
                child: StyledHTML(
                  context: context,
                  text: widget.content,
                  textStyle: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
