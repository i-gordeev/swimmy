import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controllers/main.ctr.dart';
import '../../theme/custom_icons.dart';
import '../../theme/custom_pictures.dart';
import '../../theme/custom_theme.dart';
import '../shared_widgets/insertsvg.wgt.dart';

class PremiumFutures extends StatefulWidget {
  const PremiumFutures({super.key});

  @override
  State<PremiumFutures> createState() => _PremiumFuturesState();
}

class _PremiumFuturesState extends State<PremiumFutures> {
  bool _processing = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(CustomPictures.premiumBg),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(color: CustomTheme.bgColor.withOpacity(.8)),
        Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: CustomTheme.padding / 2, vertical: CustomTheme.padding / 2),
              child: AppBar(
                title: const Text('Premium'),
                automaticallyImplyLeading: false,
                primary: true,
                actions: [
                  IconButton(
                    onPressed: Navigator.of(context).pop,
                    icon: const Icon(Icons.close, size: 32),
                  )
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(CustomTheme.padding),
              child: Column(
                children: [
                  Text(
                    'Unlock Features with',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 32),
                  ),
                  Text(
                    'Premium',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(fontSize: 32, color: CustomTheme.accentColor),
                  ),
                  const SizedBox(height: CustomTheme.padding * 2),
                  ...[
                    'Log and review pools with\ndetailed notes.',
                    '',
                    'Access exclusive nutrition tips\nfor swimmers.',
                    '',
                    'Learn injury prevention\nexercises.'
                  ].map(
                    (item) => item.isEmpty
                        ? const SizedBox(height: CustomTheme.padding * 1.5)
                        : Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              vertical: CustomTheme.padding / 2,
                              horizontal: CustomTheme.padding,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white10,
                            ),
                            child: Text(
                              item,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.25),
                            ),
                          ),
                  ),
                  const SizedBox(height: CustomTheme.padding * 2),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return ElevatedButton(
                          onPressed: _processing
                              ? null
                              : () async {
                                  setState(() => _processing = true);
                                  final result = await MainController().buyPremium();
                                  if (context.mounted == false) {
                                    return;
                                  }

                                  if (result == true) {
                                    Navigator.of(context).pop();
                                  } else {
                                    setState(() => _processing = false);
                                  }

                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        content: result
                                            ? const Text('The purchase was successful. Thank you.')
                                            : const Text('Something went wrong. Try again later.'),
                                        actions: [
                                          CupertinoDialogAction(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Okay'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black, backgroundColor: CustomTheme.accentColor),
                          child: _processing
                              ? const SizedBox.square(
                                  dimension: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Buy for \$0,99'.toUpperCase(),
                                    ),
                                    const SizedBox(width: CustomTheme.padding / 2),
                                    const InsertSvg(CustomIcons.premium, width: 28, color: Colors.black),
                                  ],
                                ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: CustomTheme.padding),
                  StatefulBuilder(builder: (context, setState) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _processing
                            ? null
                            : () async {
                                setState(() => _processing = true);

                                final result = await MainController().restorePremium();
                                if (context.mounted == false) {
                                  return;
                                }

                                if (result) {
                                  Navigator.of(context).pop();
                                } else {
                                  setState(() => _processing = false);
                                }

                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      content: result
                                          ? const Text('Purchases have been restored.')
                                          : const Text('Something went wrong. Try again later.'),
                                      actions: [
                                        CupertinoDialogAction(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Okay'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                        borderRadius: BorderRadius.circular(25),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: CustomTheme.padding / 3, horizontal: CustomTheme.padding),
                          child: Text(
                            'Restore purchases',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: CustomTheme.padding),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
