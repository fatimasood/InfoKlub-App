import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/services/template_services/template_service.dart';
import 'package:infoklub/views/CV/cv_templates/template_selection_screen.dart';

class AllTemplaresScreen extends StatefulWidget {
  const AllTemplaresScreen({super.key});

  @override
  State<AllTemplaresScreen> createState() => _AllTemplaresScreenState();
}

class _AllTemplaresScreenState extends State<AllTemplaresScreen> {
  CVTemplate _selectedTemplate = TemplateService.getDefaultTemplate();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Select Template',
            style: TextStyle(color: AppTheme.primaryColor, fontSize: 20.0)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemCount: TemplateService.templates.length,
            itemBuilder: (context, index) {
              final template = TemplateService.templates[index];
              return _buildTemplateCard(template);
            },
          ),
        ),
      ),
    );
  }

//grid card
  Widget _buildTemplateCard(CVTemplate template) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTemplate = template;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected template: ${template.name}'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.secondaryColor,
          border: Border.all(
            color: _selectedTemplate.name == template.name
                ? AppTheme.primaryColor
                : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                template.imageAsset,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                template.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _selectedTemplate.name == template.name
                      ? AppTheme.whiteColor
                      : Colors.white60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
