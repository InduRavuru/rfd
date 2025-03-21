import 'package:flutter/material.dart';
import '../models/form_field_model.dart';

class RadioField extends StatefulWidget {
  final FormFieldModel field;
  final Function(String, dynamic) onValueChange;

  const RadioField({
    Key? key,
    required this.field,
    required this.onValueChange,
  }) : super(key: key);

  @override
  _RadioFieldState createState() => _RadioFieldState();
}

class _RadioFieldState extends State<RadioField> {
  String? _selectedValue;
  bool _hasBeenTouched = false; // Track if the field has been touched

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.field.value.isNotEmpty ? widget.field.value : null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      autovalidateMode: _hasBeenTouched
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      validator: (value) {
        if (widget.field.mandatory && (value == null || value.trim().isEmpty)) {
          return "This field is required";
        }
        return null;
      },
      builder: (FormFieldState<String> state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.field.displayName + (widget.field.mandatory ? " *" : ""),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 5),
                  _buildTooltip(context),
                ],
              ),
              const SizedBox(height: 5),
              Column(
                children: widget.field.values.map((value) {
                  return RadioListTile<String>(
                    title: Text(value),
                    value: value,
                    groupValue: _selectedValue,
                    onChanged: widget.field.editable
                        ? (newValue) {
                            setState(() {
                              _hasBeenTouched = true;
                              _selectedValue = newValue;
                              state.didChange(newValue); // ✅ Update FormField validation state
                            });
                            widget.onValueChange(widget.field.name, newValue);
                          }
                        : null, // Disable if `editable: false`
                    activeColor: Colors.blue,
                  );
                }).toList(),
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                  child: Text(
                    state.errorText!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// ✅ Tooltip for displaying description based on `tooltipPlacement`
  Widget _buildTooltip(BuildContext context) {
    if (widget.field.description.isEmpty) return const SizedBox.shrink();

    return Tooltip(
      message: widget.field.description,
      preferBelow: widget.field.tooltipPlacement == "top",
      verticalOffset: widget.field.tooltipPlacement == "top" ? 20.0 : -20.0,
      child: Icon(Icons.info_outline, size: 20, color: Colors.purple[800]),
    );
  }
}
