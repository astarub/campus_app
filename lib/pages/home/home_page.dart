import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:campus_app/core/routes/router.gr.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context);

    return Scaffold();
  }
}
