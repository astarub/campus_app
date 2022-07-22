import 'package:auto_route/auto_route.dart';
import 'package:campus_app/core/authentication/bloc/authentication_bloc.dart';
import 'package:campus_app/core/routes/router.gr.dart';
import 'package:campus_app/core/themes/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final router = AutoRouter.of(context);
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      backgroundColor: themeData.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            authBloc.add(SignOutEvent());
          },
          icon: const Icon(Icons.exit_to_app),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                TextButton(
                  onPressed: () => router.push(
                    const MoodlePageRoute(),
                  ),
                  child: const Text('Moodle'),
                ),
                /*TextButton(
                  onPressed: () => router.push(
                    const EcampusPageRoute(),
                  ),
                  child: const Text('Ecampus'),
                ),*/
                /*TextButton(
                  onPressed: () => router.push(
                    const FlexnowPageRoute(),
                  ),
                  child: const Text('Flexnow'),
                ),*/
                TextButton(
                  onPressed: () => router.push(
                    const RubnewsPageRoute(),
                  ),
                  child: const Text('RUB News'),
                ),
                TextButton(
                  onPressed: () => router.push(
                    const CalendarPageRoute(),
                  ),
                  child: const Text('Calendar'),
                ),
                TextButton(
                  onPressed: () => router.replace(
                    const HomePageRoute(),
                  ),
                  child: const Text('Home'),
                ),
                TextButton(
                  onPressed: () => authBloc.add(AuthCheckRequestedEvent()),
                  child: const Text('Login'),
                ),
                Switch(
                  value: Provider.of<ThemeService>(context).isCampusNowThemeOn,
                  onChanged: (value) {
                    Provider.of<ThemeService>(context, listen: false)
                        .toogleCampusNowTheme();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
