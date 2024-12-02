import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'controllers/main.ctr.dart';
import 'data/services/notification_service.dart';
import 'data/services/shared_preferences_service.dart';
import 'theme/custom_icons.dart';
import 'theme/custom_theme.dart';
import 'ui/contests/contests.lt.dart';
import 'ui/layout/custom_bottom_navigation_bar.wgt.dart';
import 'ui/loading.scr.dart';
import 'ui/onboarding/onboarding.scr.dart';
import 'ui/planning/planning.lt.dart';
import 'ui/premium/premium.lt.dart';
import 'ui/premium/premium_futures.wgt.dart';
import 'ui/progress/progress.lt.dart';
import 'ui/schedule/schedule.lt.dart';
import 'ui/settings/settings.lt.dart';
import 'ui/shared_widgets/insertsvg.wgt.dart';
import 'ui/techniques/techniques.lt.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();
  runApp(const Application());
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  final _main = MainController();
  final _screenStreamController = StreamController<Screens>.broadcast();
  final _initialScreen = Screens.techniques;
  bool _isLoading = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));

    _showOnboarding = !(SharedPreferencesService.getBool('onboarding') ?? false);

    Future.wait([
      Future.delayed(const Duration(milliseconds: kDebugMode ? 3000 : 3000)),
      NotificationService.init(),
      _main.init(),
    ]).then((_) {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.main,
      darkTheme: CustomTheme.main,
      home: Builder(
        builder: (context) {
          if (_isLoading) {
            return const Scaffold(body: LoadingScreen());
          }

          if (_showOnboarding) {
            return Scaffold(
              body: OnboardingScreen(
                onCompleted: () {
                  setState(() => _showOnboarding = false);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) => const PremiumFutures(),
                  );
                },
              ),
            );
          }

          return FutureBuilder(
            future: Future.delayed(Duration.zero),
            builder: (context, snapshot) {
              return AnimatedOpacity(
                opacity: snapshot.connectionState == ConnectionState.done ? 1 : 0,
                duration: const Duration(milliseconds: 400),
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: const Size(double.infinity, kToolbarHeight),
                    child: StreamBuilder(
                      initialData: _initialScreen,
                      stream: _screenStreamController.stream,
                      builder: (context, snapshot) {
                        switch (snapshot.data) {
                          case Screens.techniques:
                            return AppBar(title: const Text('Techniques'));
                          case Screens.planning:
                            return AppBar(title: const Text('Training Planning'));
                          case Screens.schedule:
                            return AppBar(title: const Text('Schedule'));
                          case Screens.progress:
                            return AppBar(title: const Text('Progress'));
                          case Screens.contests:
                            return AppBar(title: const Text('Contests'));
                          case Screens.settings:
                            return AppBar(title: const Text('Settings'));
                          case Screens.premium:
                            return AppBar(title: const Text('Premium'));
                          default:
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  body: Stack(
                    fit: StackFit.expand,
                    children: [
                      LayoutBuilder(builder: (context, constraint) {
                        final bottomPadding = CustomBottomNavigationBar.height + CustomTheme.padding * 3;
                        final calcMinHeight = constraint.maxHeight - bottomPadding - CustomTheme.padding;
                        return SingleChildScrollView(
                          primary: true,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                            top: CustomTheme.padding,
                            left: CustomTheme.padding,
                            right: CustomTheme.padding,
                            bottom: bottomPadding,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: calcMinHeight),
                            child: StreamBuilder(
                              initialData: _initialScreen,
                              stream: _screenStreamController.stream,
                              builder: (context, snapshot) {
                                switch (snapshot.data) {
                                  case Screens.techniques:
                                    return const TechniquesLayout();
                                  case Screens.planning:
                                    return const PlanningLayout();
                                  case Screens.schedule:
                                    return const ScheduleLayout();
                                  case Screens.progress:
                                    return const ProgressLayout();
                                  case Screens.contests:
                                    return const ContestsLayout();
                                  case Screens.settings:
                                    return const SettingsLayout();
                                  case Screens.premium:
                                    return const PremiumLayout();
                                  default:
                                }
                                return const SizedBox();
                              },
                            ),
                          ),
                        );
                      }),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: CustomBottomNavigationBar(
                          initialScreen: _initialScreen,
                          activeScreenStream: _screenStreamController.stream,
                          activeScreenSink: _screenStreamController.sink,
                        ),
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width / 2 - CustomBottomNavigationBar.centerBtnSideWidth / 2,
                        bottom: CustomBottomNavigationBar.height - CustomBottomNavigationBar.centerBtnSideWidth / 2,
                        child: SizedBox.fromSize(
                          size: const Size.square(CustomBottomNavigationBar.centerBtnSideWidth),
                          child: DecoratedBox(
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: CustomTheme.primaryColor),
                            child: IconButton(
                              iconSize: 28,
                              onPressed: () {
                                if (_main.isPremiumUser) {
                                  _screenStreamController.sink.add(Screens.premium);
                                  return;
                                }
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  builder: (context) => const PremiumFutures(),
                                );
                              },
                              color: CustomTheme.bgColor,
                              icon: const InsertSvg(CustomIcons.premium, width: 32, height: 32, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
