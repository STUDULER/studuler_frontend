import 'package:flutter/material.dart';

class YellowBackground extends StatelessWidget {
  const YellowBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            color: Colors.yellow.shade200,
          ),
        ),
        child
      ],
    );
  }
}
