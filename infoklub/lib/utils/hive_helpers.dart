import 'package:hive/hive.dart';
import 'package:infoklub/models/health/health_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveHelper {
  static const String _healthBoxName = 'user_health_box';

  static Future<void> initHive() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(HealthModelAdapter());
  }

  static Future<Box<HealthModel>> openHealthBox() async {
    return await Hive.openBox<HealthModel>(_healthBoxName);
  }
}
