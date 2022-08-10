import 'package:sqflite/sqflite.dart';
import 'package:timekeeperv2/business/working_slot.dart';
import 'package:timekeeperv2/sql/database_service.dart';

class WorkingSlotDB {
  static final TABLE_WORKING_SLOT = 'workingslot';

  static final COL_ID = 'id';
  static final COL_DATE = 'date';
  static final COL_STARTTIME = 'startTime';
  static final COL_ENDTIME = 'endTime';
  static final COL_DESCRIPTION = 'description';

  late Future<Database> _db;
  WorkingSlotDB() {
    _db = DatabaseService().database;
  }

  Future<int> insert(WorkingSlot workingSlot) async {
    String endTimeStr = "NULL";
    if (workingSlot.endTime != null) {
      endTimeStr =
          "${workingSlot.endTime?.hour ?? "0"}@${workingSlot.endTime?.minute ?? "0"}";
    }

    Database db = await _db;
    int id = await db.insert(TABLE_WORKING_SLOT, {
      COL_DATE: workingSlot.date.toIso8601String(),
      COL_STARTTIME:
          "${workingSlot.startTime.hour}@${workingSlot.startTime.minute}",
      COL_ENDTIME: endTimeStr,
      COL_DESCRIPTION: workingSlot.description
    });
    workingSlot.id = id;
    return id;
  }

  Future<int> update(WorkingSlot workingSlot) async {
    Database db = await _db;
    int id = await db.update(TABLE_WORKING_SLOT, workingSlot.toMap(),
        where: '$COL_ID = ?', whereArgs: [workingSlot.id]);
    return id;
  }

  Future<int> delete(int id) async {
    Database db = await _db;
    int ind = await db
        .delete(TABLE_WORKING_SLOT, where: '$COL_ID = ?', whereArgs: [id]);
    return ind;
  }

  Future<int> save(WorkingSlot workingSlot) {
    if (workingSlot.id > 0) {
      return update(workingSlot);
    }
    return insert(workingSlot);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await _db;
    return await db.query(TABLE_WORKING_SLOT);
  }
}
