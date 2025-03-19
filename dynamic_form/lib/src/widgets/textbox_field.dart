
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
            _hasBeenTouched = true;
          });
        },
        onChanged: (value) {
          widget.onValueChange(widget.field.name, value); // Pass the correct field name
        },
      ),
    );
  }
}