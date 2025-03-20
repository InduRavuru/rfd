class FormFieldModel {
  final String name; // Non-nullable field
  final String type;
  final String displayName;
  final String description;
  final bool editable;
  final bool display;
  final bool mandatory;
  final String? placeholder; // Nullable
  final dynamic min; // ✅ Keep `min` as generic (no specific type)
  final dynamic max; // ✅ Keep `max` as generic (no specific type)
  final String tooltipPlacement;
  final bool isGroup; // ✅ New field for checkbox group
  final List<String> values; // ✅ Stores checkbox options when `isGroup: true`
  
  // ✅ Date-related properties
  final String? startRange;
  final String? endRange;
  final String value; // ✅ Default date selection
  final String dateFormat; // ✅ Custom date format

  FormFieldModel({
    required this.name,
    required this.type,
    this.displayName = "",
    this.description = "",
    this.editable = true,
    this.display = true,
    this.mandatory = false,
    this.placeholder,
    this.min, // ✅ Keep `min` generic
    this.max, // ✅ Keep `max` generic
    this.tooltipPlacement = "top",
    this.isGroup = false, // Default to `false` (for single checkboxes)
    this.values = const [], // Default to empty list
    this.startRange,
    this.endRange,
    this.value = "",
    this.dateFormat = "yyyy-MM-dd", // Default format
  });

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    return FormFieldModel(
      name: json['name'] ?? "",
      type: json['type'] ?? "",
      displayName: json['properties']?['displayName'] ?? json['name'] ?? "",
      description: json['description'] ?? "",
      editable: json['properties']?['editable'] ?? true,
      display: json['properties']?['display'] ?? true,
      mandatory: json['properties']?['mandatory'] ?? false,
      placeholder: json['placeholder'],
      min: json['properties']?['min'], // ✅ No specific type restriction
      max: json['properties']?['max'], // ✅ No specific type restriction
      tooltipPlacement: json['tooltipPlacement'] ?? "top",
      isGroup: json['isGroup'] ?? false, // ✅ Parse `isGroup`
      values: (json['values'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [], // ✅ Parse `values`
      startRange: json['startRange']?.toString(),
      endRange: json['endRange']?.toString(),
      value: json['value']?.toString() ?? "",
      dateFormat: json['dateFormat']?.toString() ?? "yyyy-MM-dd",
    );
  }
}




// class FormFieldModel {
//   final String name; // Ensure this is non-nullable
//   final String type;
//   final String displayName;
//   final String description;
//   final bool editable;
//   final bool display;
//   final bool mandatory;
//   final String? placeholder; // Nullable placeholder is fine
//   final int? min;
//   final int? max;
//   final String tooltipPlacement;
//   final String? parentGroup; // Add this property to track group hierarchy

//   FormFieldModel({
//     required this.name,
//     required this.type,
//     this.displayName = "",
//     this.description = "",
//     this.editable = true,
//     this.display = true,
//     this.mandatory = false,
//     this.placeholder,
//     this.min,
//     this.max,
//     this.tooltipPlacement = "top", // Default tooltip placement
//     this.parentGroup, // Parent group name (optional)
//   });

//   factory FormFieldModel.fromJson(Map<String, dynamic> json, {String? parentGroup}) {
//     return FormFieldModel(
//       name: json['name'] ?? "", // Provide a default value if 'name' is null
//       type: json['type'] ?? "",
//       displayName: json['properties']?['displayName'] ?? json['name'] ?? "",
//       description: json['description'] ?? "",
//       editable: json['properties']?['editable'] ?? true,
//       display: json['properties']?['display'] ?? true,
//       mandatory: json['properties']?['mandatory'] ?? false,
//       placeholder: json['placeholder'],
//       min: json['properties']?['min'],
//       max: json['properties']?['max'],
//       tooltipPlacement: json['tooltipPlacement'] ?? "top",
//       parentGroup: parentGroup, // Pass parent group name
//     );
//   }
// }