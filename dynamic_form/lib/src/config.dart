import 'dart:convert';

class Config {
  final List<dynamic> template; // Store the template for dynamic updates
  Map<String, dynamic> formData = {};

  Config({required this.template}); // Accept template as a parameter

  /// Initialize formData based on the provided template
  void initializeFormData(List<dynamic> template) {
    _processFields(template); // Process the provided template
  }

  /// Recursively process fields and groups
  void _processFields(List<dynamic>? fields) {
    if (fields == null) return;

    for (var field in fields) {
      if (field['type'] == 'group') {
        formData[field['name'] ?? ""] = {}; // Use default empty string if 'name' is null
        _processFields(field['children']); // Process children of the group
      } else if (field['type'] == 'textbox') {
        formData[field['name'] ?? ""] = field['value'] ?? ""; // Initialize textbox value
      }
    }
  }

  /// Update the value of a specific field
  void updateFieldValue(String fieldName, String newValue) {
    _updateField(template, fieldName, newValue);
  }

  /// Recursively find and update the field's value
  void _updateField(List<dynamic>? fields, String fieldName, String newValue) {
    if (fields == null) return;

    for (var field in fields) {
      if (field['type'] == 'group') {
        _updateField(field['children'], fieldName, newValue); // Search in group children
      } else if (field['type'] == 'textbox' && field['name'] == fieldName) {
        formData[fieldName] = newValue; // Update the field's value
      }
    }
  }

  /// Return the current form data
  Map<String, dynamic> getFormData() {
    return formData;
  }
}