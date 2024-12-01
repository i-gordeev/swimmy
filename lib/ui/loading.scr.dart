import 'package:flutter/material.dart';

import '../theme/custom_pictures.dart';
import 'shared_widgets/insertsvg.wgt.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final element in [CustomPictures.onboardingBg, CustomPictures.premiumBg]) {
      precacheImage(Image.asset(element).image, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.delayed(Duration.zero),
        builder: (context, snapshot) {
          return AnimatedOpacity(
            opacity: snapshot.connectionState == ConnectionState.done ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            child: const _AnimatedLogo(),
          );
        },
      ),
    );
  }
}

class _AnimatedLogo extends StatefulWidget {
  const _AnimatedLogo();

  @override
  State<_AnimatedLogo> createState() => __AnimatedLogoState();
}

class __AnimatedLogoState extends State<_AnimatedLogo> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _animation = Tween(begin: -30.0, end: 30.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * .65;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned.fill(
              top: _animation.value,
              child: Align(
                alignment: Alignment.center,
                child: InsertSvg(CustomPictures.logo, width: width),
              ),
            )
          ],
        );
      },
    );
  }
}
