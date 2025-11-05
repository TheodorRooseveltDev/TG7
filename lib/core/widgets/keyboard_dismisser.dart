import 'package:flutter/material.dart';

/// Widget that dismisses the keyboard when tapping outside text fields
class KeyboardDismisser extends StatelessWidget {
  final Widget child;

  const KeyboardDismisser({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus any active text field to dismiss keyboard
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}
