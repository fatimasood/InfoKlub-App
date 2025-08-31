import 'package:infoklub/views/CV/template_selection_screen.dart';

class TemplateService {
  static final List<CVTemplate> templates = [
    Template1(),
    Template2(),
    Template3(),
    Template4(),
    Template5(),
  ];

  static CVTemplate getDefaultTemplate() => templates[0];

  static CVTemplate getTemplateByName(String name) {
    return templates.firstWhere(
      (template) => template.name == name,
      orElse: () => getDefaultTemplate(),
    );
  }
}
