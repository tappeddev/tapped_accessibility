part of '../tapped_accessibility.dart';

/// Takes care to move the focus to the next correct item if the provided [child] is a [Scrollable].
/// Make sure to use [ScrollableListFocusMovement.requiredCacheExtent] to get the correct cache extent if
/// the hardware keyboard is used.
class ScrollableListFocusMovement extends StatefulWidget {
  static ScrollCacheExtent? requiredCacheExtent(BuildContext context) {
    if (HardwareKeyboardUsage.isEnabled(context)) {
      return const ScrollCacheExtent.pixels(double.maxFinite);
    }
    return null;
  }

  final double topScrollPadding;
  final Future<void> Function(FocusNode node)? beforeFocus;
  final Future<void> Function()? beforeScroll;
  final Widget child;

  const ScrollableListFocusMovement({
    super.key,
    this.topScrollPadding = 0,
    this.beforeScroll,
    this.beforeFocus,
    required this.child,
  });

  @override
  State<ScrollableListFocusMovement> createState() =>
      _ScrollableListFocusMovementState();
}

class _ScrollableListFocusMovementState
    extends State<ScrollableListFocusMovement> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _requestFocusCallback(
    FocusNode node, {
    ScrollPositionAlignmentPolicy? alignmentPolicy,
    double? alignment,
    Duration? duration,
    Curve? curve,
  }) async {
    await widget.beforeFocus?.call(node);
    if (!mounted) return;

    node.requestFocus();

    // Nothing required if we are not using the hardware keyboard.
    if (!HardwareKeyboardUsage.isEnabled(context)) return;

    final scrollData = _nextScrollable(node.context!);
    if (scrollData == null) return;
    final (scrollableState, viewportRenderObject) = scrollData;

    assert(
      scrollableState.resolvedPhysics == null ||
          scrollableState.resolvedPhysics is! NeverScrollableScrollPhysics,
      "Can not scroll the scrollable of the provided item, consider using [ScrollableListFocusMovement.scrollableKey] to have a fixed scrollable when focused.",
    );

    await widget.beforeScroll?.call();
    if (!mounted) return;

    final focusedItemRenderObject = node.context!.findRenderObject();
    final viewport = RenderAbstractViewport.maybeOf(viewportRenderObject);

    if (viewport is RenderViewport) {
      final cacheExtent = viewport.scrollCacheExtent;
      final requiredExtent =
          ScrollableListFocusMovement.requiredCacheExtent(context);

      assert(
        requiredExtent == null || (cacheExtent == requiredExtent),
        "The required list has an invalid scroll extent. Make sure to set the scroll extent to [ScrollableListFocusMovement.requiredCacheExtent].",
      );
    }

    if (focusedItemRenderObject == null || viewport == null) {
      return;
    }

    ScrollPosition position() => scrollableState.position;

    final heightScroll =
        (scrollableState.context.findRenderObject() as RenderBox?)?.size.height;
    final itemHeight = (focusedItemRenderObject as RenderBox).size.height;

    // If the height of the item is bigger or the same height as the scroll list then we want to
    // align it at the top to make sure that the top part of that view is readable.
    // Otherwise we just want the item to be revealed starting at the bottom of the screen.
    final revealOffsetAlignment =
        heightScroll != null && itemHeight >= heightScroll
            ? Alignment.topCenter.y
            : Alignment.bottomCenter.y;

    final rawOffset = viewport
        .getOffsetToReveal(focusedItemRenderObject, revealOffsetAlignment)
        .offset;
    var target =
        rawOffset.clamp(position().minScrollExtent, position().maxScrollExtent);

    final pixel = position().pixels;

    if (target < pixel) {
      final offsetToReveal = viewport.getOffsetToReveal(
        focusedItemRenderObject,
        Alignment.center.y,
      );
      target = (offsetToReveal.offset - widget.topScrollPadding)
          .clamp(position().minScrollExtent, position().maxScrollExtent);

      if (target > pixel) {
        return;
      }
    }

    position().jumpTo(target);
  }

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(
        requestFocusCallback: _requestFocusCallback,
      ),
      child: Focus(
        canRequestFocus: false,
        focusNode: _focusNode,
        onFocusChange: (hasFocus) {
          if (!hasFocus) return;

          final currentPrimaryFocus = FocusManager.instance.primaryFocus!;
          _requestFocusCallback(currentPrimaryFocus);
        },
        child: widget.child,
      ),
    );
  }

  (ScrollableState, RenderObject)? _nextScrollable(BuildContext context) {
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable == null) {
      return null;
    }

    if (scrollable.resolvedPhysics is NeverScrollableScrollPhysics) {
      // Use the context to get the parent scrollable.
      // This will recursively walk to the next scrollable that we might be able to scroll.
      // This might happen when have nested listviews that shrink wrap and that are not scrollable.
      return _nextScrollable(scrollable.context);
    }

    return (scrollable, context.findRenderObject()!);
  }
}
