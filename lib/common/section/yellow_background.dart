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
        Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          color: const Color(0xFFFFEC9E),
        ),
        child
      ],
    );
  }
}
