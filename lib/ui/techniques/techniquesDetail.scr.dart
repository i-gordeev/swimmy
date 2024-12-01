import 'package:flutter/material.dart';

import '../../data/models/techniques.mdl.dart';
import '../../theme/custom_icons.dart';
import '../../theme/custom_theme.dart';
import '../shared_widgets/insertsvg.wgt.dart';

class TechniquesDetailScreen extends StatelessWidget {
  final TechniquesModel item;
  const TechniquesDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
                  image: DecorationImage(
                    image: AssetImage(item.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: CustomTheme.bgColor.withOpacity(.35),
                  padding: const EdgeInsets.all(CustomTheme.padding / 2),
                  child: SafeArea(
                    child: AppBar(
                      leading: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const InsertSvg(CustomIcons.back, width: 32, color: Colors.white),
                      ),
                      title: Text(item.title),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(CustomTheme.padding),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF9EAABA)) ??
                    const TextStyle(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: CustomTheme.padding),
                    Text(item.preview),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: CustomTheme.padding),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Divider(thickness: 1, color: Color(0xFF222C47)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: CustomTheme.padding),
                            color: CustomTheme.bgColor,
                            child: const Text(
                              'Exercise',
                              style: TextStyle(color: Color(0xFF222C47)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...item.desc.split("\n").map((segment) => Padding(
                          padding: segment.trim().isNotEmpty
                              ? const EdgeInsets.symmetric(vertical: CustomTheme.padding / 2)
                              : const EdgeInsets.all(0),
                          child: Text(segment.trim()),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
