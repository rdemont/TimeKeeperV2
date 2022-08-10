import 'package:flutter_test/flutter_test.dart';
import 'package:timekeeperv2/business/working_slot.dart';

void main() {
  testWidgets('working slot ...', (tester) async {
    WorkingSlotsList wsl = WorkingSlotsList();

    expect(wsl.length, 20);
    expect(wsl.perYear(2022).length, 20);
    expect(wsl.perYear(2000).length, 0);
    expect(wsl.perYear(2022).length, 20);
    expect(wsl.perYearMonth(2022, 7).length, 10);
    expect(wsl.perDate(2022, 7, 1).length, 2);
    expect(wsl.perDate(2022, 7, 1).sumMinutes(), 240);
  });
}
