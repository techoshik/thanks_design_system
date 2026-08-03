import 'package:flutter_test/flutter_test.dart';
import 'package:thanks_design_system/thanks_design_system.dart';

void main() {
  test('default theme uses the default brand', () {
    expect(ThanksTheme.light().colorScheme.primary,
        ThanksBrand.defaultBrand.primary);
  });
}
