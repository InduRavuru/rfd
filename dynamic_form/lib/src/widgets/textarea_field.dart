import 'package:flutter/material.dart';
import '../models/form_field_model.dart';

class TextareaField extends StatefulWidget {
  final FormFieldModel field;
  final TextEditingController controller;
  final Function(String, String) onValueChange;

  const TextareaField({
    Key? key,
    required this.field,
    required this.controller,
    required this.onValueChange,
  }) : super(key: key);

  @override
  _TextareaFieldState createState() => _TextareaFieldState();
}

class _TextareaFieldState extends State<TextareaField> {
  bool _hasBeenTouched = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.field.display) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: widget.controller,
        enabled: widget.field.editable,
        maxLines: null,
        minLines: 4,
        autovalidateMode: _hasBeenTouched
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        validator: (value) {
          if (widget.field.mandatory && (value == null || value.trim().isEmpty)) {
            return "This field is required";
          }
          if (widget.field.min != null &&
              value != null &&
              value.trim().length < widget.field.min) {
            return "Minimum ${widget.field.min} characters required";
          }
          if (widget.field.max != null &&
              value != null &&
              value.trim().length > widget.field.max) {
            return "Maximum ${widget.field.max} characters allowed";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: widget.field.displayName + (widget.field.mandatory ? " *" : ""),
          hintText: widget.field.placeholder,
          suffixIcon: _buildTooltip(
            widget.field.description,
            widget.field.tooltipPlacement,
          ),
        ),
        onTap: () {
          setState(() {
            _hasBeenTouched = true;
          });
        },
        onChanged: (value) {
          widget.onValueChange(widget.field.name, value);
        },
      ),
    );
  }

  Widget _buildTooltip(String? description, String? tooltipPlacement) {
    if (description == null || description.isEmpty) return const SizedBox.shrink();

    return Tooltip(
      message: description,
      preferBelow: tooltipPlacement == "top",
      verticalOffset: tooltipPlacement == "top" ? 20.0 : -20.0,
      child: Icon(Icons.info_outline, size: 20, color: Colors.purple),
    );
  }
}
