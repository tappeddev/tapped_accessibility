import 'package:flutter/cupertino.dart';

class FocusNodeData {
  final BuildContext context;
  final RenderBox renderBox;
  final RenderBox? parentScrollableRenderBox;

  FocusNodeData({
    required this.context,
    required this.renderBox,
    required this.parentScrollableRenderBox,
  });

  HighlightPosition getPosition() {
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final childRect = offset & size;
    final parentRect = parentScrollableRenderBox?.toRect();

    final isInsideParent = parentRect?.containsRect(childRect) ?? true;

    return HighlightPosition(
      focusNodeContext: context,
      offset: offset,
      size: size,
      isInsideParent: isInsideParent,
      parentRect: parentRect,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FocusNodeData &&
          runtimeType == other.runtimeType &&
          context == other.context &&
          renderBox == other.renderBox &&
          parentScrollableRenderBox == other.parentScrollableRenderBox;

  @override
  int get hashCode =>
      context.hashCode ^
      renderBox.hashCode ^
      parentScrollableRenderBox.hashCode;
}

class HighlightPosition {
  final Size size;
  final Offset offset;
  final BuildContext focusNodeContext;
  final bool isInsideParent;
  final Rect? parentRect;

  HighlightPosition({
    required this.size,
    required this.offset,
    required this.focusNodeContext,
    required this.isInsideParent,
    required this.parentRect,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HighlightPosition &&
          runtimeType == other.runtimeType &&
          size == other.size &&
          offset == other.offset &&
          focusNodeContext == other.focusNodeContext &&
          isInsideParent == other.isInsideParent &&
          parentRect == other.parentRect;

  @override
  int get hashCode =>
      size.hashCode ^
      offset.hashCode ^
      focusNodeContext.hashCode ^
      isInsideParent.hashCode ^
      parentRect.hashCode;
}

extension RectExtensions on Rect {
  bool containsRect(Rect other) {
    return contains(other.topLeft) || contains(other.bottomRight);
  }
}

extension on RenderBox {
  Rect toRect() {
    return localToGlobal(Offset.zero) & size;
  }
}
