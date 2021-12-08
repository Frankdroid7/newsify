import 'package:flutter_test/flutter_test.dart';
import 'package:newsify/utils.dart';

void main() {
  test('Return today\'s date', () {
    expect(Utils.todays_Date, 'Wednesday, December 8, 2021');
  });
}
