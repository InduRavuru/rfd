import 'package:flutter/material.dart';
import '../models/form_field_model.dart';

class SwitchField extends StatefulWidget {
  final FormFieldModel field;
  final Function(String, dynamic) onValueChange;

  const SwitchField({
    Key? key,
    required this.field,
    required this.onValueChange,
  }) : super(key: key);

  @override
  _SwitchFieldState createState() => _SwitchFieldState();
}

class _SwitchFieldState extends State<SwitchField> {
  late bool _value;
  bool _hasBeenTouched = false;

  @override
  void initState() {
    super.initState();
    _value = widget.field.value.toString().toLowerCase() == "true";
  }

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: _value,
      autovalidateMode: _hasBeenTouched
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      validator: (val) {
        if (widget.field.mandatory && val == null) {
          return "This field is required";
        }
        return null;
      },
      builder: (state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(widget.field.displayName + (widget.field.mandatory ? " *" : ""),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 6),
                  _buildTooltip(widget.field.description, widget.field.tooltipPlacement),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    _value ? widget.field.labels[0] : widget.field.labels[1],
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  Switch(
                    value: _value,
                    onChanged: widget.field.editable
                        ? (bool newValue) {
                            setState(() {
                              _value = newValue;
                              _hasBeenTouched = true;
                              state.didChange(newValue);
                            });
                            widget.onValueChange(widget.field.name, newValue);
                          }
                        : null,
                  ),
                ],
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 4),
                  child: Text(state.errorText!, style: TextStyle(color: Colors.red, fontSize: 12)),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTooltip(String? description, String placement) {
    if (description == null || description.isEmpty) return const SizedBox.shrink();

    return Tooltip(
      message: description,
      preferBelow: placement == "top",
      verticalOffset: placement == "top" ? 20.0 : -20.0,
      child: Icon(Icons.info_outline, size: 20, color: Colors.purple[800]),
    );
  }
}
