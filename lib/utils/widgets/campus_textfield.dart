import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:campus_app/core/themes.dart';

/// This widget adds a custom [TextField] that uses the CampusApp design language
class CampusTextField extends StatefulWidget {
  /// The controller that is used for the underlying [TextField] in order to
  /// access the input at any given time
  final TextEditingController textFieldController;

  /// The hint text that is displayed when the TextField is empty
  final String textFieldText;

  const CampusTextField({
    Key? key,
    required this.textFieldController,
    this.textFieldText = 'Confirm Password',
  }) : super(key: key);

  @override
  State<CampusTextField> createState() => _CampusTextFieldState();
}

class _CampusTextFieldState extends State<CampusTextField> {
  final FocusNode _focusNode = FocusNode();
  late String hint = widget.textFieldText;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() => setState(() {
          if (_focusNode.hasFocus) {
            hint = '';
          } else {
            hint = widget.textFieldText;
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      child: TextField(
        focusNode: _focusNode,
        controller: widget.textFieldController,
        style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium!.copyWith(
              color: const Color.fromARGB(255, 129, 129, 129),
            ),
        cursorColor: Colors.black,
        decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromRGBO(245, 246, 250, 1),
            hintText: hint,
            hintStyle: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium!.copyWith(
                  color: const Color.fromARGB(255, 146, 146, 146),
                ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)),
      ),
    );
  }
}
