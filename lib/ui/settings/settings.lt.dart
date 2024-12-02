import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../controllers/main.ctr.dart';
import '../../theme/custom_icons.dart';
import '../../theme/custom_theme.dart';
import '../premium/premium_futures.wgt.dart';
import '../shared_widgets/insertsvg.wgt.dart';
import 'setting_detail.scr.dart';

class SettingsLayout extends StatelessWidget {
  const SettingsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Item(
          iconPath: CustomIcons.privacy,
          title: 'Privacy Policy',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SettingsDetail(
                  title: 'Privacy Policy',
                  link: linkPrivacyPolicy,
                ),
              ),
            );
          },
        ),
        _Item(
          iconPath: CustomIcons.terms,
          title: 'Terms of Use',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SettingsDetail(
                  title: 'Terms of Use',
                  link: linkTermsOfUse,
                ),
              ),
            );
          },
        ),
        _Item(
          iconPath: CustomIcons.support,
          title: 'Support',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SettingsDetail(
                  title: 'Support',
                  link: linkSupportForm,
                ),
              ),
            );
          },
        ),
        _Item(
          iconPath: CustomIcons.cleardata,
          title: 'Clear Data',
          onTap: () async {
            final process = await showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  content: const Text('Are you sure you want to clear all saving data?'),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('Cancel'),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                );
              },
            );
            if (process == true) {
              await MainController().clearAllData();
              if (context.mounted) {
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      content: const Text('The data has been cleared.'),
                      actions: [
                        CupertinoDialogAction(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Okay'),
                        )
                      ],
                    );
                  },
                );
              }
            }
          },
        ),
        const SizedBox(height: CustomTheme.padding * 3),
        if (MainController().isPremiumUser == false) const _PremiumButton(),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  final String iconPath;
  final String title;
  final void Function() onTap;
  const _Item({required this.iconPath, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: CustomTheme.padding / 2, vertical: CustomTheme.padding),
        child: Row(
          children: [
            InsertSvg(iconPath, width: 32, color: CustomTheme.formColor),
            const SizedBox(width: CustomTheme.padding),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: CustomTheme.padding),
            const Spacer(),
            const Icon(Icons.chevron_right, weight: 32, color: CustomTheme.formColor),
          ],
        ),
      ),
    );
  }
}

class _PremiumButton extends StatelessWidget {
  const _PremiumButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (context) => const PremiumFutures(),
          );
        },
        style: ElevatedButton.styleFrom(foregroundColor: Colors.black, backgroundColor: CustomTheme.accentColor),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Get Premium',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: CustomTheme.padding / 2),
            InsertSvg(CustomIcons.premium, width: 28, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
