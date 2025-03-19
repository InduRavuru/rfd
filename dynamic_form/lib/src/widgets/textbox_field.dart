import 'package:flutter/material.dart';
import '../models/form_field_model.dart';

class TextboxField extends StatefulWidget {
  final FormFieldModel field;
  final TextEditingController controller;
  final Function(String, String) onValueChange;

  const TextboxField({
    Key? key,
    required this.field,
    required this.controller,
    required this.onValueChange,
  }) : super(key: key);

  @override
  _TextboxFieldState createState() => _TextboxFieldState();
}

class _TextboxFieldState extends State<TextboxField> {
  bool _hasBeenTouched = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.field.displayName + (widget.field.mandatory ? " *" : ""),
          hintText: widget.field.placeholder,
          suffixIcon: _buildTooltip(context, widget.field.description, widget.field.tooltipPlacement), // Add tooltip
        ),
        enabled: widget.field.editable,
        autovalidateMode: _hasBeenTouched
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        validator: (value) {
          if (widget.field.mandatory && (value == null || value.trim().isEmpty)) {
            return "This field is required";
          }
          if (widget.field.min != null && value != null && value.trim().length < widget.field.min!) {
            return "Minimum ${widget.field.min} characters required";
          }
          if (widget.field.max != null && value != null && value.trim().length > widget.field.max!) {
            return "Maximum ${widget.field.max} characters allowed";
          }
          return null;
        },
        onTap: () {
          setState(() {
            _hasBeenTouched = true; // Mark as touched when interacted with
          });
        },
        onChanged: (value) {
          widget.onValueChange(widget.field.name, value); // Pass the correct field name
        },
      ),
    );
  }

  /// Build the tooltip icon for the field's description
  Widget _buildTooltip(BuildContext context, String? description, String tooltipPlacement) {
    if (description == null || description.isEmpty) {
      return const SizedBox.shrink(); // Return empty widget if no description
    }

    return Tooltip(
      message: description, // Display the field's description as the tooltip message
      preferBelow: tooltipPlacement == "top", // Show tooltip above or below based on placement
      verticalOffset: tooltipPlacement == "top" ? 20.0 : -20.0, // Adjust vertical offset
      child: Icon(Icons.info_outline, size: 20, color: Colors.purple[800]), // Use info_outline icon
    );
  }
}