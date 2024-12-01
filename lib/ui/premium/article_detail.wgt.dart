import 'package:flutter/material.dart';

import '../../data/models/article.mdl.dart';
import '../../theme/custom_icons.dart';
import '../../theme/custom_theme.dart';
import '../shared_widgets/insertsvg.wgt.dart';

class ArticleDetail extends StatelessWidget {
  final String sectionTitle;
  final ArticleModel item;
  const ArticleDetail({super.key, required this.item, required this.sectionTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            primary: true,
            backgroundColor: CustomTheme.bgColor,
            title: Text(sectionTitle),
            pinned: true,
            expandedHeight: 320.0,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const InsertSvg(CustomIcons.back, width: 32, color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
                  image: DecorationImage(
                    image: AssetImage(item.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  color: CustomTheme.opacityColor.withOpacity(.6),
                  padding: const EdgeInsets.all(CustomTheme.padding / 2),
                  child: Padding(
                    padding: const EdgeInsets.all(CustomTheme.padding),
                    child: Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
                  ),
                ),
              ),
            ),
          ),
          DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyMedium?.copyWith() ?? const TextStyle(),
            child: SliverList.list(
              children: [
                const SizedBox(height: CustomTheme.padding),
                ...item.desc.split("\n").map((segment) => Padding(
                      padding: segment.trim().isNotEmpty
                          ? const EdgeInsets.symmetric(
                              horizontal: CustomTheme.padding, vertical: CustomTheme.padding / 2)
                          : const EdgeInsets.all(0),
                      child: Text(
                        segment.trim(),
                        style: const TextStyle(color: Color(0xFF9EAABA)),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(CustomTheme.padding),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        side: const BorderSide(width: 1, color: Colors.white54)),
                    onPressed: Navigator.of(context).pop,
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(height: CustomTheme.padding),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
