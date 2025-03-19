class GroupModel {
  final String name;
  final String displayName;
  final String description;
  final bool expanded;
  final bool mandatory;
  final bool editable;
  final bool display;
  final List<dynamic> children;

  GroupModel({
    required this.name,
    this.displayName = "",
    this.description = "",
    this.expanded = false,
    this.mandatory = false,
    this.editable = true,
    this.display = true,
    required this.children,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      name: json['name'],
      displayName: json['properties']?['displayName'] ?? json['name'],
      description: json['description'] ?? '',
      expanded: json['properties']?['expanded'] ?? false,
      mandatory: json['properties']?['mandatory'] ?? false,
      editable: json['properties']?['editable'] ?? true,
      display: json['properties']?['display'] ?? true,
      children: json['children'] ?? [],
    );
  }
}


// class GroupModel {
//   final String name;
//   final String displayName;
//   final String description;
//   final bool expanded;
//   final bool mandatory;
//   final bool editable;
//   final bool display;
//   final List<dynamic> children;

//   GroupModel({
//     required this.name,
//     this.displayName = "",
//     this.description = "",
//     this.expanded = false,
//     this.mandatory = false,
//     this.editable = true,
//     this.display = true,
//     required this.children,
//   });

//   factory GroupModel.fromJson(Map<String, dynamic> json) {
//     return GroupModel(
//       name: json['name'] ?? "", // Provide a default value if 'name' is null
//       displayName: json['properties']?['displayName'] ?? json['name'] ?? "",
//       description: json['description'] ?? "",
//       expanded: json['properties']?['expanded'] ?? false,
//       mandatory: json['properties']?['mandatory'] ?? false,
//       editable: json['properties']?['editable'] ?? true,
//       display: json['properties']?['display'] ?? true,
//       children: json['children']?.map((child) {
//         if (child is Map) {
//           return Map.from(child); // ✅ Explicitly convert to Map<String, dynamic>
//         }
//         return child;
//       }).toList() ?? [],
//     );
//   }
// }