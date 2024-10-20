import 'package:flutter/material.dart';

import 'hide_keyboard.dart';

class GestureDectectorHidingKeyboard extends GestureDetector {
  GestureDectectorHidingKeyboard({
    super.key,
    super.child,
    GestureTapCallback? onTap,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
    super.onTapDown,
    super.onTapUp,
    super.onTapCancel,
    super.onLongPressStart,
    super.onLongPressMoveUpdate,
    super.onLongPressUp,
    super.onLongPressEnd,
    super.onForcePressStart,
    super.onForcePressPeak,
    super.onForcePressUpdate,
    super.onForcePressEnd,
    super.onVerticalDragDown,
    super.onVerticalDragStart,
    super.onVerticalDragUpdate,
    super.onVerticalDragEnd,
    super.onVerticalDragCancel,
    super.onHorizontalDragDown,
    super.onHorizontalDragStart,
    super.onHorizontalDragUpdate,
    super.onHorizontalDragEnd,
    super.onHorizontalDragCancel,
    super.onScaleStart,
    super.onScaleUpdate,
    super.onScaleEnd,
    super.onSecondaryTapDown,
    super.onSecondaryTapUp,
    super.onSecondaryTapCancel,
    super.onSecondaryTap,
    super.onSecondaryLongPress,
    super.onSecondaryLongPressStart,
    super.onSecondaryLongPressMoveUpdate,
    super.onSecondaryLongPressUp,
    super.onSecondaryLongPressEnd,
  }) : super(
          onTap: () {
            hideKeyboard();
            if (onTap != null) onTap();
          },
          onDoubleTap: () {
            hideKeyboard();
            if (onDoubleTap != null) onDoubleTap();
          },
          onLongPress: () {
            hideKeyboard();
            if (onLongPress != null) onLongPress();
          },
        );
}
