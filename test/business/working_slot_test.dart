import 'package:flutter_test/flutter_test.dart';
import 'package:timekeeperv2/business/time_slot.dart';

void main() {
  testWidgets('working slot ...', (tester) async {
    TimeSlotList wsl = TimeSlotList();

    expect(wsl.length, 20);

    //expect(wsl.perYear(2022).length, 20);
    //expect(wsl.perYear(2000).length, 0);
    //expect(wsl.perYear(2022).length, 20);
    wsl.perYearMonth(2022, 7).then((value) => expect(value.length, 10));
    //expect(await wsl.perYearMonth(2022, 7).length, 10);
    //expect(wsl.perDate(2022, 7, 1).length, 2);
    //expect(wsl.perDate(2022, 7, 1).minutes, 240);
  });
}
