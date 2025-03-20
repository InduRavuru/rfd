import 'package:flutter/material.dart';
import '../models/form_field_model.dart';

class SelectField extends StatefulWidget {
  final FormFieldModel field;
  final Function(String, Map<String, dynamic>?) onValueChange;

  const SelectField({
    Key? key,
    required this.field,
    required this.onValueChange,
  }) : super(key: key);

  @override
  _SelectFieldState createState() => _SelectFieldState();
}

class _SelectFieldState extends State<SelectField> {
  Map<String, dynamic>? _selectedItem;
  bool _hasBeenTouched = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.centerRight,
          children: [
            DropdownButtonFormField<Map<String, dynamic>>(
              isExpanded: true,
              decoration: InputDecoration(
                labelText: widget.field.displayName + (widget.field.mandatory ? " *" : ""),
                hintText: "Select an option",
                suffixIcon: _buildTooltip(context, widget.field.description, widget.field.tooltipPlacement),
              ),
              items: widget.field.values.map((option) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: option,
                  child: Text(option["label"]),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedItem = value;
                  _hasBeenTouched = true;
                  widget.onValueChange(widget.field.name, _selectedItem);
                });
              },
              value: _selectedItem,
              autovalidateMode: _hasBeenTouched
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              validator: (value) {
                if (widget.field.mandatory && _selectedItem == null) {
                  return "This field is required";
                }
                return null;
              },
            ),
            if (_selectedItem != null) // Show "X" button only when an item is selected
              Positioned(
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.clear, size: 20, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _selectedItem = null;
                      _hasBeenTouched = true;
                      widget.onValueChange(widget.field.name, null);
                    });
                  },
                ),
              ),
          ],
        ),
      ],
    );
  }

  /// Build tooltip for description
  Widget _buildTooltip(BuildContext context, String? description, String tooltipPlacement) {
    if (description == null || description.isEmpty) return const SizedBox.shrink();

    return Tooltip(
      message: description,
      preferBelow: tooltipPlacement == "top",
      verticalOffset: tooltipPlacement == "top" ? 20.0 : -20.0,
      child: Icon(Icons.info_outline, size: 20),
    );
  }
}
