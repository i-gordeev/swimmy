import 'package:flutter/material.dart';

import '../../data/content/nutritions.data.dart';
import '../../theme/custom_theme.dart';
import 'article_detail.wgt.dart';

class PremiumNutrition extends StatelessWidget {
  const PremiumNutrition({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: nutritionsData.length,
      itemBuilder: (context, index) {
        final item = nutritionsData[index];
        return Container(
          clipBehavior: Clip.antiAlias,
          constraints: const BoxConstraints(minHeight: 114),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage(item.imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ArticleDetail(sectionTitle: 'Nutrition', item: item),
                ));
              },
              borderRadius: BorderRadius.circular(20),
              child: ColoredBox(
                color: CustomTheme.opacityColor.withOpacity(.6),
                child: Padding(
                  padding: const EdgeInsets.all(CustomTheme.padding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 100),
                        child: Text(item.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: CustomTheme.padding / 2),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.5, color: Colors.white),
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white10,
                          ),
                          padding: const EdgeInsets.all(CustomTheme.padding / 1.75),
                          child: const Text(
                            'Learn more',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: CustomTheme.padding),
    );
  }
}
