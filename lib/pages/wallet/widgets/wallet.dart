import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:screen_brightness/screen_brightness.dart';

import 'package:campus_app/core/injection.dart';
import 'package:campus_app/core/settings.dart';
import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/wallet/ticket/ticket_repository.dart';
import 'package:campus_app/pages/wallet/ticket/ticket_usecases.dart';
import 'package:campus_app/pages/wallet/ticket_login_screen.dart';
import 'package:campus_app/pages/wallet/ticket_fullscreen.dart';
import 'package:campus_app/pages/wallet/widgets/stacked_card_carousel.dart';
import 'package:campus_app/utils/widgets/custom_button.dart';

class CampusWallet extends StatelessWidget {
  const CampusWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double initialWalletOffset =
        (MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width - 70)) / 2;
    final double initialWalletOffsetTablet = (MediaQuery.of(context).size.width - 500) / 2;

    return StackedCardCarousel(
      cardAlignment: CardAlignment.center,
      scrollDirection: Axis.horizontal,
      initialOffset:
          MediaQuery.of(context).size.shortestSide < 600 ? initialWalletOffset : initialWalletOffsetTablet + 30,
      spaceBetweenItems: MediaQuery.of(context).size.shortestSide < 600 ? 400 : 500,
      items: [
        SizedBox(
          width: MediaQuery.of(context).size.shortestSide < 600 ? MediaQuery.of(context).size.width - 70 : 330,
          height: 217,
          child: const BogestraTicket(),
        ),
      ],
    );
  }
}

class BogestraTicket extends StatefulWidget {
  const BogestraTicket({Key? key}) : super(key: key);

  @override
  State<BogestraTicket> createState() => _BogestraTicketState();
}

class _BogestraTicketState extends State<BogestraTicket> with AutomaticKeepAliveClientMixin<BogestraTicket> {
  bool scanned = false;
  String scannedValue = '';

  late Image aztecCodeImage;
  late Map<String, dynamic> ticketDetails;

  bool showAztecCode = false;

  TicketRepository ticketRepository = sl<TicketRepository>();
  TicketUsecases ticketUsecases = sl<TicketUsecases>();

  /// Loads the previously saved image of the semester ticket and the corresponding ticket details
  Future<void> renderTicket() async {
    final Image? aztecCodeImage = await ticketUsecases.renderAztecCode();
    final Map<String, dynamic>? ticketDetails = await ticketUsecases.getTicketDetails();

    if (aztecCodeImage != null && ticketDetails != null) {
      setState(() {
        scanned = true;
        this.aztecCodeImage = aztecCodeImage;
        this.ticketDetails = ticketDetails;
      });
    }
  }

  Future<void> addTicket() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketLoginScreen(
          onTicketLoaded: () async {
            await renderTicket();
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    ticketRepository.loadTicket().catchError((error) {
      debugPrint('Wallet widget: $error');
    });
    renderTicket();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      decoration: BoxDecoration(
        color: scanned ? Colors.white : Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: scanned
          ? GestureDetector(
              onTap: () {
                if (Provider.of<SettingsHandler>(context, listen: false).currentSettings.displayFullscreenTicket) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BogestraTicketFullScreen(),
                    ),
                  );
                } else {
                  setState(() => showAztecCode = !showAztecCode);
                  if (showAztecCode) {
                    setBrightness(1);
                  } else {
                    resetBrightness();
                  }
                }
              },
              onLongPress: addTicket,
              child: showAztecCode
                  ? aztecCodeImage
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: SvgPicture.asset(
                            'assets/img/bogestra-logo.svg',
                            height: 60,
                            width: 30,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: SizedBox(
                                width: 130,
                                height: 130,
                                child: aztecCodeImage,
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            Padding(
                              padding: const EdgeInsets.only(right: 10, left: 5),
                              child: SizedBox(
                                width: 180,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Deutschlandsemesterticket',
                                      style: Provider.of<ThemesNotifier>(context)
                                          .currentThemeData
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(color: Colors.black, fontSize: 12.5),
                                    ),
                                    Text(
                                      ticketDetails['owner'],
                                      style: Provider.of<ThemesNotifier>(context)
                                          .currentThemeData
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(color: Colors.black, fontSize: 12.5),
                                    ),
                                    Text(
                                      'Geburtstag: ${ticketDetails['birthdate']}',
                                      style: Provider.of<ThemesNotifier>(context)
                                          .currentThemeData
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.black, fontSize: 12),
                                    ),
                                    Text(
                                      'Von: ${ticketDetails['valid_from']}',
                                      style: Provider.of<ThemesNotifier>(context)
                                          .currentThemeData
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.black, fontSize: 12),
                                    ),
                                    Text(
                                      'Bis: ${ticketDetails['valid_till']}',
                                      style: Provider.of<ThemesNotifier>(context)
                                          .currentThemeData
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.black, fontSize: 12),
                                    ),
                                    if (ticketDetails['validity_region'].toString().isNotEmpty)
                                      Text(
                                        'Geltungsbereich: ${ticketDetails['validity_region']}',
                                        style: Provider.of<ThemesNotifier>(context)
                                            .currentThemeData
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: Colors.black, fontSize: 12),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            )
          : CustomButton(
              tapHandler: addTicket,
              splashColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                  ? const Color.fromRGBO(0, 0, 0, 0.04)
                  : const Color.fromRGBO(255, 255, 255, 0.06),
              highlightColor: Provider.of<ThemesNotifier>(context, listen: false).currentTheme == AppThemes.light
                  ? const Color.fromRGBO(0, 0, 0, 0.02)
                  : const Color.fromRGBO(255, 255, 255, 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/img/icons/file-plus.svg',
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(
                      Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium!.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Füge dein Semesterticket hinzu',
                      style: Provider.of<ThemesNotifier>(context).currentThemeData.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

Future<void> setBrightness(double brightness) async {
  try {
    await ScreenBrightness().setScreenBrightness(brightness);
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> resetBrightness() async {
  try {
    await ScreenBrightness().resetScreenBrightness();
  } catch (e) {
    debugPrint(e.toString());
  }
}
