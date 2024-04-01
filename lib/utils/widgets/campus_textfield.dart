import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:campus_app/core/themes.dart';

enum CampusTextFieldType { normal, icon }

/// This widget adds a custom [TextField] that uses the CampusApp design language
class CampusTextField extends StatefulWidget {
  /// The controller that is used for the underlying [TextField] in order to
  /// access the input at any given time
  final TextEditingController textFieldController;

  /// The hint text that is displayed when the TextField is empty
  final String textFieldText;

  /// The path to the asset that should be used as the leading icon.
  /// Can be an .svg or .png file
  late final String pathToIcon;

  final bool obscuredInput;

  late final CampusTextFieldType type;

  late final void Function()? onTap;

  CampusTextField({
    Key? key,
    required this.textFieldController,
    this.textFieldText = 'Confirm Password',
    this.obscuredInput = false,
    this.onTap,
  }) : super(key: key) {
    type = CampusTextFieldType.normal;
  }

  CampusTextField.icon({
    Key? key,
    required this.textFieldController,
    this.textFieldText = 'Confirm Password',
    this.obscuredInput = false,
    required this.pathToIcon,
  }) : super(key: key) {
    type = CampusTextFieldType.icon;
  }

  @override
  State<CampusTextField> createState() => CampusTextFieldState();
}

class CampusTextFieldState extends State<CampusTextField> {
  final FocusNode _focusNode = FocusNode();
  late String hint = widget.textFieldText;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(
      () => setState(() {
        if (_focusNode.hasFocus) {
          hint = '';
          if (widget.onTap != null) {
            // ignore: prefer_null_aware_method_calls
            widget.onTap!();
          }
        } else {
          hint = widget.textFieldText;
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          TextField(
            focusNode: _focusNode,
            controller: widget.textFieldController,
            style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium!.copyWith(
                  color: Provider.of<ThemesNotifier>(context).currentTheme == AppThemes.light
                      ? Colors.black
                      : const Color.fromRGBO(184, 186, 191, 1),
                ),
            cursorColor: Provider.of<ThemesNotifier>(context).currentTheme == AppThemes.light
                ? Colors.black
                : const Color.fromRGBO(184, 186, 191, 1),
            decoration: InputDecoration(
              filled: true,
              fillColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                  ? const Color.fromRGBO(245, 246, 250, 1)
                  : const Color.fromRGBO(34, 40, 54, 1),
              hintText: hint,
              hintStyle: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.labelMedium!.copyWith(
                    color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                        ? Colors.black
                        : const Color.fromRGBO(184, 186, 191, 1),
                  ),
              contentPadding: widget.type == CampusTextFieldType.normal
                  ? const EdgeInsets.symmetric(horizontal: 12, vertical: 24)
                  : const EdgeInsets.only(left: 65, right: 12, top: 24, bottom: 24),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                      ? Colors.black
                      : const Color.fromARGB(255, 129, 129, 129),
                ),
              ),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            ),
            obscureText: widget.obscuredInput,
          ),
          if (widget.type == CampusTextFieldType.icon)
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: widget.pathToIcon.substring(widget.pathToIcon.length - 3) == 'svg'
                  ? SvgPicture.asset(
                      widget.pathToIcon,
                      colorFilter: const ColorFilter.mode(
                        Colors.black87,
                        BlendMode.srcIn,
                      ),
                      height: 30,
                    )
                  : Image.asset(
                      widget.pathToIcon,
                      color: Colors.black87,
                      height: 28,
                    ),
            ),
        ],
      ),
    );
  }
}
