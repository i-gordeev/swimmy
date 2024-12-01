import 'package:flutter/material.dart';

import '../../data/content/techniques.data.dart';
import '../../data/models/techniques.mdl.dart';
import '../../theme/custom_icons.dart';
import '../../theme/custom_theme.dart';
import '../shared_widgets/insertsvg.wgt.dart';
import 'techniquesDetail.scr.dart';

class TechniquesLayout extends StatelessWidget {
  const TechniquesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateToDetail(TechniquesModel item) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TechniquesDetailScreen(item: item),
      ));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Swimming Techniques Overview',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: CustomTheme.padding),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: techniquesData.length,
          itemBuilder: (context, index) {
            final item = techniquesData[index];
            return Container(
              clipBehavior: Clip.antiAlias,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(item.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => navigateToDetail(item),
                child: ColoredBox(
                  color: CustomTheme.bgColor.withOpacity(.5),
                  child: Padding(
                    padding: const EdgeInsets.all(CustomTheme.padding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: CustomTheme.padding,
                                vertical: CustomTheme.padding / 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Text(item.label),
                            ),
                            Text(
                              item.title,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => navigateToDetail(item),
                          icon: Container(
                            width: 42,
                            height: 42,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                            child: const InsertSvg(CustomIcons.arrRight, width: 32, color: CustomTheme.bgColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: CustomTheme.padding * 1.5),
        )
      ],
    );
  }
}
