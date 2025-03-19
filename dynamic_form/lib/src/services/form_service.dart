
// import 'package:flutter/material.dart';
// import '../models/form_field_model.dart';
// import '../models/group_model.dart';
// import '../widgets/textbox_field.dart';
// import '../widgets/group_field.dart';

// class FormService {
//   static Widget buildForm(
//     List<dynamic> template,
//     Function(String, String) onValueChange,
//     Map<String, TextEditingController> controllers,
//     Map<String, dynamic> config,
//     VoidCallback onValidationChange,
//     String parentPath,
// ) {
//   return Column(
//     children: template.map((field) {
//       String fieldPath = parentPath.isEmpty ? field['name'] : '$parentPath.${field['name']}';
//       if (field['type'] == 'group') {
//         // Ensure the group's config is initialized
//         if (config[field['name']] == null) {
//           config[field['name']] = <String, dynamic>{};
//         }
//         return _createGroup(
//           GroupModel.fromJson(field),
//           onValueChange,
//           controllers,
//           config[field['name']],
//           onValidationChange,
//           fieldPath,
//         );
//       } else {
//         return _createFormField(
//           FormFieldModel.fromJson(field),
//           onValueChange,
//           controllers,
//           config,
//           fieldPath,
//         );
//       }
//     }).toList(),
//   );
// }
//   static Widget _createGroup(
//     GroupModel group,
//     Function(String, String) onValueChange,
//     Map<String, TextEditingController> controllers,
//     Map<String, dynamic> config,
//     VoidCallback onValidationChange,
//     String parentPath,
//   ){
//     if (!group.display) return const SizedBox.shrink();

//     // Ensure the group's config is initialized
//     if (config == null) {
//       config = <String, dynamic>{};
//     }

//     return GroupField(
//       group: group,
//       child: buildForm(
//         group.children,
//         onValueChange,
//         controllers,
//         config,
//         onValidationChange,
//         parentPath,
//       ),
//       onValidationChange: onValidationChange,
//     );
//   }

//   static Widget _createFormField(
//     FormFieldModel field,
//     Function(String, String) onValueChange,
//     Map<String, TextEditingController> controllers,
//     Map<String, dynamic> config,
//     String parentPath, // Add parentPath parameter
//   ) {
//     if (!field.display) return const SizedBox.shrink();

//     TextEditingController controller = controllers[field.name]!;
//     return TextboxField(
//       field: field,
//       controller: controller,
//       onValueChange: (fieldName, value) {
//         String fullPath =
//             parentPath.isEmpty ? fieldName : '$parentPath.$fieldName';
//         onValueChange(fullPath, value); // Pass fullPath to onValueChange
//       },
//     );
//   }
// }





import 'package:flutter/material.dart';
import '../models/form_field_model.dart';
import '../widgets/textbox_field.dart';
import '../widgets/group_field.dart';
import '../models/group_model.dart'; // Import GroupModel

class FormService {
  static Widget buildForm(
    List<dynamic> template,
    Function(String, String) onValueChange,
    Map<String, TextEditingController> controllers,
    Map<String, dynamic> config,
    VoidCallback onValidationChange,
    String parentPath,
  ) {
    return Column(
      children: template.map((field) {
        String fieldPath =
            parentPath.isEmpty ? field['name'] : '$parentPath.${field['name']}';
        if (field['type'] == 'group') {
          // Ensure the group's config is initialized
          if (config[field['name']] == null) {
            config[field['name']] = <String, dynamic>{};
          }
          return _createGroup(
            GroupModel.fromJson(field),
            onValueChange,
            controllers,
            config[field['name']],
            onValidationChange,
            fieldPath,
          );
        } else {
          return _createFormField(
            FormFieldModel.fromJson(field),
            onValueChange,
            controllers,
            config,
            fieldPath,
          );
        }
      }).toList(),
    );
  }

  static Widget _createGroup(
    GroupModel group,
    Function(String, String) onValueChange,
    Map<String, TextEditingController> controllers,
    Map<String, dynamic> config,
    VoidCallback onValidationChange,
    String parentPath,
  ) {
    if (!group.display || group.name == null) return const SizedBox.shrink();

    return GroupField(
      group: group,
      child: buildForm(
        group.children,
        onValueChange,
        controllers,
        config,
        onValidationChange,
        parentPath, // Pass the parentPath to child fields
      ),
      onValidationChange: onValidationChange,
    );
  }

  static Widget _createFormField(
    FormFieldModel field,
    Function(String, String) onValueChange,
    Map<String, TextEditingController> controllers,
    Map<String, dynamic> config,
    String fieldPath, // Add fieldPath parameter
  ) {
    if (!field.display || field.name == null) return const SizedBox.shrink();

    TextEditingController controller = controllers[field.name]!;
    return TextboxField(
      field: field,
      controller: controller,
      onValueChange: (fieldName, value) {
        onValueChange(fieldPath, value); // Pass the full fieldPath to onValueChange
      },
    );
  }
}