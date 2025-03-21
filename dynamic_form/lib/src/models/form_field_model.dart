class FormFieldModel {
  final String name;
  final String type;
  final String displayName;
  final String description;
  final bool editable;
  final bool display;
  final bool mandatory;
  final String? placeholder;
  final dynamic min;
  final dynamic max;
  final String tooltipPlacement;

  final bool isGroup;
  final List<dynamic> values;
  final List<String> labels; // ✅ For Switch field labels like ["Yes", "No"]

  // ✅ Date-related fields
  final String startRange;
  final String endRange;
  final String value;
  final String dateFormat;

  FormFieldModel({
    required this.name,
    required this.type,
    this.displayName = "",
    this.description = "",
    this.editable = true,
    this.display = true,
    this.mandatory = false,
    this.placeholder,
    this.min,
    this.max,
    this.tooltipPlacement = "top",
    this.isGroup = false,
    this.values = const [],
    this.labels = const [],
    this.startRange = "2000",
    this.endRange = "2025",
    this.value = "",
    this.dateFormat = "yyyy-MM-dd",
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
      min: json['properties']?['min'],
      max: json['properties']?['max'],
      tooltipPlacement: json['tooltipPlacement'] ?? "top",
      isGroup: json['isGroup'] ?? false,
      values: json['values'] ?? [],
      labels: (json['labels'] as List?)?.map((e) => e.toString()).toList() ?? [],
      startRange: json['startRange']?.toString() ?? "2000",
      endRange: json['endRange']?.toString() ?? "2025",
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