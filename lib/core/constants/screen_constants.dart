/// Screen size constants for adaptive UI behavior
class ScreenConstants {
  ScreenConstants._();

  /// Height threshold for small screen detection.
  ///
  /// The task editor is rendered below an app bar and system insets, so a
  /// 600-640px emulator does not have enough vertical space for the fixed
  /// recording controls used by the swipe layout. Use the scrollable layout
  /// before that content reaches the bottom of the viewport.
  static const double smallScreenHeightThreshold = 700.0;

  /// Check if current screen is considered small
  static bool isSmallScreen(double screenHeight) {
    print('screenHeight: $screenHeight');
    return screenHeight < smallScreenHeightThreshold;
  }
}
