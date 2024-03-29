import 'package:flutter/material.dart';

import '../../shared/app_config.dart';

class DocumentTypeCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final bool isQuestionPaper;
  final bool isSelected;
  final void Function()? onPressed;
  const DocumentTypeCard(
      {required this.icon,
      required this.title,
      this.isQuestionPaper = false,
      this.isSelected = false,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var subtitle1 = Theme.of(context).textTheme.subtitle1?.copyWith(
          fontSize: 16,
          color: (isSelected) ? Colors.white : Colors.black,
        );
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.background,
        ),
        width: App(context).appWidth(0.4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(
              width: 5,
            ),
            Flexible(
              child: Text(
                title,
                style: subtitle1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
