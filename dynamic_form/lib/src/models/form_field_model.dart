class FormFieldModel {
  final String name; // Ensure this is non-nullable
  final String type;
  final String displayName;
  final String description;
  final bool editable;
  final bool display;
  final bool mandatory;
  final String? placeholder; // Nullable placeholder is fine
  final int? min;
  final int? max;
  final String tooltipPlacement;

  FormFieldModel({
    required this.name, // Non-nullable
    required this.type,
    this.displayName = "",
    this.description = "",
    this.editable = true,
    this.display = true,
    this.mandatory = false,
    this.placeholder,
    this.min,
    this.max,
    this.tooltipPlacement = "top", // Default tooltip placement
  });

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    return FormFieldModel(
      name: json['name'] ?? "", // Provide a default value if 'name' is null
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