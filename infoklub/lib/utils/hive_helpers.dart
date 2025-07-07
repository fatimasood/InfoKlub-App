import 'package:hive/hive.dart';
import 'package:infoklub/models/health/health_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveHelper {
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(HealthModelAdapter());
  }

  static Future<Box<HealthModel>> openHealthBox() async {
    return await Hive.openBox<HealthModel>('health_data');
  }
}
