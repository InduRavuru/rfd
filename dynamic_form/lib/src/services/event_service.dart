import 'package:flutter/material.dart';

class EventService {
  /// Recursively update dependent fields when a field with "execute" is changed.
  static void onChangeTextbox(
      List<dynamic> template, String changedFieldName, String newValue, Map<String, TextEditingController> controllers) {
    for (var field in template) {
      if (field is Map) {
        if (field['name'] == changedFieldName) {
          /// Check if the field has "execute"
          if (field.containsKey('execute')) {
            List<dynamic> executeList = field['execute'];

            for (String targetField in executeList) {
              /// Extract field name (e.g., "textbox6.value" → "textbox6")
              String targetFieldName = targetField.split('.').first;

              /// Find the field recursively and update its value
              _updateFieldValue(template, targetFieldName, newValue, controllers);
            }
          }
        }

        /// Recursively search inside nested groups
        if (field.containsKey('children')) {
          onChangeTextbox(field['children'], changedFieldName, newValue, controllers);
        }
      }
    }
  }

  /// Find a field by name and update its value
  static void _updateFieldValue(
      List<dynamic> template, String fieldName, String newValue, Map<String, TextEditingController> controllers) {
    for (var field in template) {
      if (field is Map) {
        if (field['name'] == fieldName) {
          /// Update the value in controllers if it exists
          if (controllers.containsKey(fieldName)) {
            controllers[fieldName]!.text = newValue;
            print("🔄 Updated $fieldName to: $newValue");
          }
        }

        /// Recursively search inside nested groups
        if (field.containsKey('children')) {
          _updateFieldValue(field['children'], fieldName, newValue, controllers);
        }
      }
    }
  }
}
