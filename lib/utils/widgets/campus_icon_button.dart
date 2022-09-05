import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class CampusIconButton extends StatelessWidget {
  final String iconPath;

  final VoidCallback onTap;

  const CampusIconButton({
    Key? key,
    required this.iconPath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color.fromRGBO(245, 246, 250, 1), width: 2),
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          splashColor: const Color.fromRGBO(0, 0, 0, 0.04),
          highlightColor: const Color.fromRGBO(0, 0, 0, 0.02),
          borderRadius: BorderRadius.circular(15),
          child: Center(
            child: iconPath.substring(iconPath.length - 3) == 'svg'
                ? SvgPicture.asset(
                    iconPath,
                    color: Colors.black,
                  )
                : Image.asset(
                    iconPath,
                    color: Colors.black,
                    width: 20,
                  ),
          ),
        ),
      ),
    );
  }
}
