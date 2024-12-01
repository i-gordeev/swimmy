import 'package:flutter/material.dart';

import '../../theme/custom_theme.dart';

class OnboardingIndicator extends StatefulWidget {
  final int length;
  final PageController pageController;
  const OnboardingIndicator({super.key, required this.length, required this.pageController});

  @override
  State<OnboardingIndicator> createState() => _OnboardingIndicatorState();
}

class _OnboardingIndicatorState extends State<OnboardingIndicator> {
  late int _activeIndex;

  int get _currentIndex => (widget.pageController.page ?? 0).round();

  void _pageChangedHandler() {
    if (_currentIndex != _activeIndex) {
      setState(() => _activeIndex = _currentIndex);
    }
  }

  @override
  void initState() {
    super.initState();
    _activeIndex = _currentIndex;
    widget.pageController.addListener(_pageChangedHandler);
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_pageChangedHandler);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < widget.length; i++) ...[
          InkWell(
            onTap: () {
              widget.pageController
                  .animateToPage(i, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: i == _activeIndex ? 20 : 10,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(i == _activeIndex ? 1 : 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          if ((i + 1) < widget.length) const SizedBox(width: CustomTheme.padding)
        ],
      ],
    );
  }
}
