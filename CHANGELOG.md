## 0.0.3

* **BREAKING**: `ScrollableListFocusMovement.requiredCacheExtent` now returns
  a `ScrollCacheExtent?` instead of a `double?` to match Flutter's new
  `ScrollView.scrollCacheExtent` API. Pass the result directly to
  `scrollCacheExtent`. Requires Flutter >= 3.42.

## 0.0.2 -> 27.01.2025

* Clip the [FocusHighlight] painter outside of the current render box.

## 0.0.1 -> 24.01.2025

* Initial release.
