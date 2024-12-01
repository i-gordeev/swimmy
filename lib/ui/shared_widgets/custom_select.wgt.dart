import 'package:flutter/material.dart';

import '../../theme/custom_theme.dart';

class CustomSelect extends StatefulWidget {
  final TextEditingController controller;
  final List<String> values;
  final void Function(String value) onSelect;
  const CustomSelect({
    super.key,
    required this.controller,
    required this.values,
    required this.onSelect,
  });

  @override
  State<CustomSelect> createState() => _CustomSelectState();
}

class _CustomSelectState extends State<CustomSelect> {
  bool _isExpanded = false;
  bool _offstage = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                readOnly: true,
                controller: widget.controller,
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                    if (_isExpanded) {
                      _offstage = false;
                    }
                  });
                },
                decoration: InputDecoration(suffixIcon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more)),
              ),
            ),
          ],
        ),
        AnimatedOpacity(
          opacity: _isExpanded ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          onEnd: () {
            if (!_isExpanded) {
              setState(() => _offstage = true);
            }
          },
          child: Offstage(
            offstage: _offstage,
            child: Padding(
              padding: const EdgeInsets.only(top: CustomTheme.padding),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: widget.values
                      .map((item) => Material(
                            color: CustomTheme.formColor,
                            child: InkWell(
                              onTap: () {
                                widget.onSelect(item);
                                setState(() => _isExpanded = false);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: CustomTheme.padding,
                                  vertical: CustomTheme.padding / 1.5,
                                ),
                                child: Opacity(opacity: widget.controller.text == item ? 1 : .5, child: Text(item)),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
