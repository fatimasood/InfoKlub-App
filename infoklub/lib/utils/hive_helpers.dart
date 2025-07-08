import 'package:hive/hive.dart';
import 'package:infoklub/models/health/health_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveHelper {
  static Future<void> initHive() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(HealthModelAdapter());
  }

  static String getHealthBoxName(String email) {
    return "health_${email.replaceAll('@', '_').replaceAll('.', '_')}";
  }

  static Future<Box<HealthModel>> openHealthBox(String email) async {
    final boxName = getHealthBoxName(email);
    return await Hive.openBox<HealthModel>(boxName);
  }
}
