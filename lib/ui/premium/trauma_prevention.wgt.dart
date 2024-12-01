import 'package:flutter/material.dart';

import '../../data/content/trauma.data.dart';
import '../../theme/custom_theme.dart';
import 'article_detail.wgt.dart';

class TraumaPrevention extends StatelessWidget {
  const TraumaPrevention({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: traumaData.length,
      itemBuilder: (context, index) {
        final item = traumaData[index];

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: CustomTheme.formColor,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ArticleDetail(sectionTitle: 'Trauma prevention', item: item),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.all(CustomTheme.padding),
                child: Row(
                  children: [
                    Container(
                      width: 68,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: AssetImage(item.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: CustomTheme.padding),
                    Expanded(
                      child: Text(
                        item.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
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
