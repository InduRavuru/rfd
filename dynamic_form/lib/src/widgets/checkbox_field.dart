import 'package:flutter/material.dart';
import '../models/form_field_model.dart';

class CheckboxField extends StatefulWidget {
  final FormFieldModel field;
  final Function(String, dynamic) onValueChange;

  const CheckboxField({
    Key? key,
    required this.field,
    required this.onValueChange,
  }) : super(key: key);

  @override
  _CheckboxFieldState createState() => _CheckboxFieldState();
}

class _CheckboxFieldState extends State<CheckboxField> {
  Map<String, bool> _checkboxValues = {}; // Store checkbox group values
  bool _singleCheckboxValue = false; // Store single checkbox value
  String? _errorText; // Validation message
  bool _hasBeenTouched = false; // ✅ Track if field was interacted with

  @override
  void initState() {
    super.initState();
    if (widget.field.isGroup) {
      for (String value in widget.field.values) {
        _checkboxValues[value] = false; // Default unchecked
      }
      _checkboxValues["checkGroup"] = false; // Group status
    }
  }

  void _updateGroupCheckboxes(String key, bool value) {
    if (!widget.field.editable) return; // ✅ Prevent changes if not editable

    setState(() {
      _checkboxValues[key] = value;
      _checkboxValues["checkGroup"] = _checkboxValues.entries
          .where((entry) => entry.key != "checkGroup")
          .every((entry) => entry.value == true);
      _hasBeenTouched = true; // ✅ Mark as touched
    });

    _validateField();
    widget.onValueChange(widget.field.name, Map<String, bool>.from(_checkboxValues));
  }

  void _updateSingleCheckbox(bool value) {
    if (!widget.field.editable) return; // ✅ Prevent changes if not editable

    setState(() {
      _singleCheckboxValue = value;
      _hasBeenTouched = true; // ✅ Mark as touched
    });

    _validateField();
    widget.onValueChange(widget.field.name, value);
  }

  /// ✅ Ensure validation runs on user interaction & form submission
  void _validateField() {
    if (widget.field.mandatory) {
      if (widget.field.isGroup) {
        bool hasChecked = _checkboxValues.entries
            .where((entry) => entry.key != "checkGroup")
            .any((entry) => entry.value == true);
        setState(() {
          _errorText = (_hasBeenTouched || _errorText != null) && !hasChecked ? "This field is required" : null;
        });
      } else {
        setState(() {
          _errorText = (_hasBeenTouched || _errorText != null) && !_singleCheckboxValue ? "This field is required" : null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.field.display) return const SizedBox.shrink(); // ✅ Hide if `display: false`

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.field.displayName.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.field.displayName + (widget.field.mandatory ? " *" : ""),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildTooltip(context),
              ],
            ),
          if (widget.field.isGroup)
            Column(
              children: widget.field.values.map((value) {
                return CheckboxListTile(
                  title: Text(value),
                  value: _checkboxValues[value],
                  onChanged: widget.field.editable
                      ? (bool? newValue) => _updateGroupCheckboxes(value, newValue ?? false)
                      : null, // ✅ Disable if `editable: false`
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }).toList(),
            )
          else
            CheckboxListTile(
              title: Text(widget.field.displayName),
              value: _singleCheckboxValue,
              onChanged: widget.field.editable
                  ? (bool? newValue) => _updateSingleCheckbox(newValue ?? false)
                  : null, // ✅ Disable if `editable: false`
              controlAffinity: ListTileControlAffinity.leading,
            ),
          if (_errorText != null) // ✅ Show validation error
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 4.0),
              child: Text(
                _errorText!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTooltip(BuildContext context) {
    return Tooltip(
      message: widget.field.description,
      preferBelow: widget.field.tooltipPlacement == "top",
      verticalOffset: widget.field.tooltipPlacement == "top" ? 20.0 : -20.0,
      child: Icon(Icons.info_outline, size: 20),
    );
  }
}
