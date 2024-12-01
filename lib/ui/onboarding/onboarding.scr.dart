import 'dart:async';
import 'package:flutter/material.dart';

import '../../data/services/shared_preferences_service.dart';
import '../../theme/custom_pictures.dart';
import '../../theme/custom_theme.dart';
import 'onboarding_indicator.wgt.dart';
import 'onboarding_page.wgt.dart';

class OnboardingScreen extends StatefulWidget {
  final void Function() onCompleted;
  const OnboardingScreen({super.key, required this.onCompleted});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController(keepPage: false);
  final _streamController = StreamController<double>();

  void _pageChangedHandler() {
    final v = _pageController.page ?? 0;
    _streamController.sink.add(v);
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_pageChangedHandler);
    SharedPreferencesService.setBool('onboarding', true);
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageChangedHandler);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sideWidth = MediaQuery.of(context).size.height;

    const pages = [
      OnboardingPage(
        title: 'Learn Swimming\nStrokes',
        subtitle: 'Master techniques to improve your performance.',
      ),
      OnboardingPage(
        title: 'Personalized\nTraining',
        subtitle: 'Create a plan based on your goals and level.',
      ),
      OnboardingPage(
        title: 'Track and See\nProgress',
        subtitle: 'Monitor your training and upcoming competitions.',
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<double>(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              final page = snapshot.data ?? 0;
              final segmentWidth = (sideWidth - MediaQuery.of(context).size.width) / (pages.length - 1);
              return Positioned(
                left: segmentWidth * page * -1,
                width: sideWidth,
                height: sideWidth,
                child: Image.asset(CustomPictures.onboardingBg),
              );
            },
          ),
          Container(color: CustomTheme.bgColor.withOpacity(.8)),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: PageView(
                  physics: const BouncingScrollPhysics(),
                  controller: _pageController,
                  children: pages,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: CustomTheme.padding, horizontal: CustomTheme.padding * 3),
                child: Row(
                  children: [
                    OnboardingIndicator(
                      length: pages.length,
                      pageController: _pageController,
                    ),
                    const Spacer(),
                    Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                      child: IconButton(
                        iconSize: 28,
                        onPressed: () {
                          final index = (_pageController.page ?? 0).ceil();
                          if (pages.length > (index + 1)) {
                            _pageController.animateToPage(
                              (index + 1),
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            widget.onCompleted();
                          }
                        },
                        color: CustomTheme.bgColor,
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: CustomTheme.padding * 2),
            ],
          ),
        ],
      ),
    );
  }
}
