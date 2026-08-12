part of '../tapped_accessibility.dart';

/// A widget that enables scrolling using arrow keys for improved accessibility.
///
/// This widget wraps a child widget and provides keyboard navigation
/// functionality, allowing users to scroll the content using the up and down
/// arrow keys.
class AccessibleArrowKeyScrollable extends StatelessWidget {
  /// The [ScrollController] used to control the scroll view.
  final ScrollController scrollController;

  final Widget child;

  const AccessibleArrowKeyScrollable({
    required this.scrollController,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) {
        final logicalKey = event.logicalKey;

        final isUp = logicalKey == LogicalKeyboardKey.arrowUp;
        final isDown = logicalKey == LogicalKeyboardKey.arrowDown;

        void scrollTo(double newScrollOffset) {
          final correctedOffset = newScrollOffset.clamp(
            0.0,
            scrollController.position.maxScrollExtent,
          );

          scrollController.animateTo(
            correctedOffset,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        }

        if (isUp) {
          final newScrollOffset = scrollController.offset - 80.0;

          scrollTo(newScrollOffset);

          return KeyEventResult.handled;
        } else if (isDown) {
          final newScrollOffset = scrollController.offset + 80.0;

          scrollTo(newScrollOffset);

          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
      child: child,
    );
  }
}
