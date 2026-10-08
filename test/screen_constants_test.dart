import 'package:flutter_test/flutter_test.dart';
import 'package:mahder_mobile/core/constants/screen_constants.dart';

void main() {
  test('compact task screens use the scrollable layout', () {
    expect(ScreenConstants.isSmallScreen(640), isTrue);
    expect(ScreenConstants.isSmallScreen(699), isTrue);
    expect(ScreenConstants.isSmallScreen(700), isFalse);
  });
}
