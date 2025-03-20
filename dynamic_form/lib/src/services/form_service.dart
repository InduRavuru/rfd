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
import '../widgets/checkbox_field.dart';
import '../widgets/group_field.dart';
import '../widgets/date_field.dart';
import '../widgets/multiselect_field.dart';
import '../widgets/select_field.dart'; // ✅ Import SelectField
import '../models/group_model.dart';

class FormService {
  static Widget buildForm(
    List<dynamic> template,
    Function(String, dynamic) onValueChange,
    Map<String, TextEditingController> controllers,
    Map<String, dynamic> config,
    VoidCallback onValidationChange,
    String parentPath,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: template.map((field) {
          String fieldPath = parentPath.isEmpty
              ? field['name']
              : '$parentPath.${field['name']}';

          if (field['type'] == 'group') {
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
          } else if (field['type'] == 'checkbox') {
            return _createCheckboxField(
              FormFieldModel.fromJson(field),
              onValueChange,
              config,
              fieldPath,
            );
          } else if (field['type'] == 'date') {
            return _createDateField(
              FormFieldModel.fromJson(field),
              onValueChange,
              config,
              fieldPath,
            );
          } else if (field['type'] == 'multiselect') {
            return _createMultiSelectField(
              FormFieldModel.fromJson(field),
              onValueChange,
              config,
              fieldPath,
            );
          } else if (field['type'] == 'select') { // ✅ Add support for select field
            return _createSelectField(
              FormFieldModel.fromJson(field),
              onValueChange,
              config,
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
      ),
    );
  }

  static Widget _createGroup(
    GroupModel group,
    Function(String, dynamic) onValueChange,
    Map<String, TextEditingController> controllers,
    Map<String, dynamic> config,
    VoidCallback onValidationChange,
    String parentPath,
  ) {
    if (!group.display) return const SizedBox.shrink();

    return GroupField(
      group: group,
      child: buildForm(
        group.children,
        onValueChange,
        controllers,
        config,
        onValidationChange,
        parentPath,
      ),
      onValidationChange: onValidationChange,
    );
  }

  static Widget _createCheckboxField(
    FormFieldModel field,
    Function(String, dynamic) onValueChange,
    Map<String, dynamic> config,
    String fieldPath,
  ) {
    if (!field.display) return const SizedBox.shrink();

    return CheckboxField(
      field: field,
      onValueChange: (fieldName, value) {
        onValueChange(fieldPath, value);
      },
    );
  }

  static Widget _createDateField(
    FormFieldModel field,
    Function(String, dynamic) onValueChange,
    Map<String, dynamic> config,
    String fieldPath,
  ) {
    if (!field.display) return const SizedBox.shrink();

    return DateField(
      field: field,
      onValueChange: (fieldName, value) {
        onValueChange(fieldPath, value);
      },
    );
  }

  static Widget _createMultiSelectField(
    FormFieldModel field,
    Function(String, dynamic) onValueChange,
    Map<String, dynamic> config,
    String fieldPath,
  ) {
    if (!field.display) return const SizedBox.shrink();

    return MultiSelectField(
      field: field,
      onValueChange: (fieldName, value) {
        onValueChange(fieldPath, value);
      },
    );
  }

  static Widget _createSelectField( // ✅ New method for SelectField
    FormFieldModel field,
    Function(String, dynamic) onValueChange,
    Map<String, dynamic> config,
    String fieldPath,
  ) {
    if (!field.display) return const SizedBox.shrink();

    return SelectField(
      field: field,
      onValueChange: (fieldName, value) {
        onValueChange(fieldPath, value);
      },
    );
  }

  static Widget _createFormField(
    FormFieldModel field,
    Function(String, dynamic) onValueChange,
    Map<String, TextEditingController> controllers,
    Map<String, dynamic> config,
    String fieldPath,
  ) {
    if (!field.display) return const SizedBox.shrink();

    TextEditingController controller = controllers[field.name]!;

    return TextboxField(
      field: field,
      controller: controller,
      onValueChange: (fieldName, value) {
        onValueChange(fieldPath, value);
      },
    );
  }
}
