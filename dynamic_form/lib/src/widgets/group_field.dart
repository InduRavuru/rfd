import 'package:flutter/material.dart';
import '../models/group_model.dart';

class GroupField extends StatefulWidget {
  final GroupModel group;
  final Widget child;
  final VoidCallback onValidationChange;

  const GroupField({
    Key? key,
    required this.group,
    required this.child,
    required this.onValidationChange,
  }) : super(key: key);

  @override
  _GroupFieldState createState() => _GroupFieldState();
}

class _GroupFieldState extends State<GroupField> {
  late bool isExpanded;
  bool hasErrors = false;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.group.expanded;
  }

  /// Check if any child fields are invalid
  void _validateGroup() {
    setState(() {
      hasErrors = widget.group.children.any((child) =>
          child is Map && child['properties']?['mandatory'] == true &&
          (child['value'] == null || child['value'].toString().trim().isEmpty));
    });

    widget.onValidationChange();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                Text(
                  widget.group.displayName + (widget.group.mandatory && hasErrors ? " *" : ""),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5),
                _buildTooltip(widget.group.description),
              ],
            ),
            trailing: IconButton(
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          if (isExpanded)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: widget.child,
            ),
        ],
      ),
    );
  }

  /// Tooltip for displaying description when clicking `"i"` icon
  Widget _buildTooltip(String description) {
    return Tooltip(
      message: description,
      child: Icon(Icons.info_outline, size: 20),
    );
  }
}


