import 'package:campus_app/core/injection.dart';
import 'package:campus_app/pages/rubsignin/bloc/rubsignin_bloc.dart';
import 'package:campus_app/pages/rubsignin/widgets/input_decide_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RUBSignInPage extends StatelessWidget {
  const RUBSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => sl<RUBSignInBloc>(),
        child: const InputDecideWidget(),
      ),
    );
  }
}
