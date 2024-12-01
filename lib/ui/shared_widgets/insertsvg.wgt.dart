import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InsertSvg extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  const InsertSvg(this.path, {super.key, this.width, this.height, this.color, this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      fit: fit,
    );
  }
}
