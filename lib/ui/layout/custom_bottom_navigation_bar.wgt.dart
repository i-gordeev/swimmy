import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../theme/custom_icons.dart';
import '../../theme/custom_theme.dart';
import '../shared_widgets/insertsvg.wgt.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  static double height = 90 + CustomTheme.defaultIOSbottomPadding;
  static const double centerBtnSideWidth = 54;

  final Screens initialScreen;
  final Stream<Screens> activeScreenStream;
  final StreamSink<Screens> activeScreenSink;
  const CustomBottomNavigationBar({
    super.key,
    required this.activeScreenStream,
    required this.activeScreenSink,
    required this.initialScreen,
  });

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _MyCustomClipper(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          width: double.infinity,
          height: CustomBottomNavigationBar.height,
          color: const Color(0xFF222C47).withOpacity(.8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: CustomTheme.padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: CustomBottomNavigationBar.centerBtnSideWidth / 2 + CustomTheme.padding / 3,
                ),
                StreamBuilder<Screens>(
                    initialData: widget.initialScreen,
                    stream: widget.activeScreenStream,
                    builder: (context, snapshot) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _MenuItem(
                            title: 'Techniques',
                            iconPath: CustomIcons.techniques,
                            isActive: snapshot.data == Screens.techniques,
                            onTap: () => widget.activeScreenSink.add(Screens.techniques),
                          ),
                          _MenuItem(
                            title: 'Training Planning',
                            iconPath: CustomIcons.planning,
                            isActive: snapshot.data == Screens.planning,
                            onTap: () => widget.activeScreenSink.add(Screens.planning),
                          ),
                          _MenuItem(
                            title: 'Schedule',
                            iconPath: CustomIcons.schedule,
                            isActive: snapshot.data == Screens.schedule,
                            onTap: () => widget.activeScreenSink.add(Screens.schedule),
                          ),
                          _MenuItem(
                            title: 'Progress',
                            iconPath: CustomIcons.progress,
                            isActive: snapshot.data == Screens.progress,
                            onTap: () => widget.activeScreenSink.add(Screens.progress),
                          ),
                          _MenuItem(
                            title: 'Contests',
                            iconPath: CustomIcons.contests,
                            isActive: snapshot.data == Screens.contests,
                            onTap: () => widget.activeScreenSink.add(Screens.contests),
                          ),
                          _MenuItem(
                            title: 'Settings',
                            iconPath: CustomIcons.settings,
                            isActive: snapshot.data == Screens.settings,
                            onTap: () => widget.activeScreenSink.add(Screens.settings),
                          ),
                        ],
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double offsetTop = 0;
    double radius = 35;
    double btnWidth = CustomBottomNavigationBar.centerBtnSideWidth + 8;
    double padding = CustomTheme.padding;

    Path path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, offsetTop + radius)
      ..arcToPoint(Offset(radius, offsetTop), radius: Radius.circular(radius))

      // center
      ..lineTo(size.width / 2 - btnWidth / 2 - padding / 2, offsetTop)
      ..arcToPoint(Offset(size.width / 2 + btnWidth / 2 + padding / 2, offsetTop),
          radius: Radius.circular(btnWidth / 2 + padding / 2), clockwise: false)

      // right
      ..lineTo(size.width - radius, offsetTop)
      ..arcToPoint(Offset(size.width, offsetTop + radius), radius: Radius.circular(radius))
      ..lineTo(size.width, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _MenuItem extends StatelessWidget {
  final String title;
  final String iconPath;
  final bool isActive;
  final void Function() onTap;

  const _MenuItem({required this.title, required this.iconPath, required this.onTap, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16 + CustomTheme.padding / 2),
      child: Tooltip(
        message: title,
        child: Padding(
          padding: const EdgeInsets.all(CustomTheme.padding / 2),
          child: InsertSvg(iconPath, width: 32, color: isActive ? CustomTheme.primaryColor : Colors.white70),
        ),
      ),
    );
  }
}
