import 'package:flutter/material.dart';
import '../models/form_field_model.dart';

class MultiSelectField extends StatefulWidget {
  final FormFieldModel field;
  final Function(String, List<Map<String, dynamic>>) onValueChange;

  const MultiSelectField({
    Key? key,
    required this.field,
    required this.onValueChange,
  }) : super(key: key);

  @override
  _MultiSelectFieldState createState() => _MultiSelectFieldState();
}

class _MultiSelectFieldState extends State<MultiSelectField> {
  List<Map<String, dynamic>> _selectedItems = [];
  bool _hasBeenTouched = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormField<List<Map<String, dynamic>>>(
          autovalidateMode: _hasBeenTouched
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          validator: (value) {
            if (widget.field.mandatory && _selectedItems.isEmpty) {
              return "This field is required";
            }
            if (widget.field.min != null && _selectedItems.length < widget.field.min!) {
              return "Minimum ${widget.field.min} selections required";
            }
            if (widget.field.max != null && _selectedItems.length > widget.field.max!) {
              return "Maximum ${widget.field.max} selections allowed";
            }
            return null;
          },
          builder: (FormFieldState<List<Map<String, dynamic>>> state) {
            return InputDecorator(
              decoration: InputDecoration(
                labelText: widget.field.displayName + (widget.field.mandatory ? " *" : ""),
                hintText: widget.field.placeholder,
                suffixIcon: _buildTooltip(context, widget.field.description, widget.field.tooltipPlacement),
                errorText: state.errorText, // Display validation error
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<List<Map<String, dynamic>>>(
                  isExpanded: true,
                  hint: Text(_selectedItems.isEmpty ? widget.field.placeholder ?? "Select options"
                      : _selectedItems.map((e) => e["status"]).join(", ")),
                  items: widget.field.values.map((option) {
                    return DropdownMenuItem<List<Map<String, dynamic>>>(
                      value: [option], // Store selected item as a list
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          bool isSelected = _selectedItems.any((item) => item["id"] == option["id"]);
                          return CheckboxListTile(
                            title: Text(option["status"]),
                            value: isSelected,
                            onChanged: (selected) {
                              setState(() {
                                if (selected == true) {
                                  if (!_selectedItems.any((item) => item["id"] == option["id"])) {
                                    _selectedItems.add(option); // ✅ Prevent duplicate entries
                                  }
                                } else {
                                  _selectedItems.removeWhere((item) => item["id"] == option["id"]);
                                }
                                _hasBeenTouched = true;
                                widget.onValueChange(widget.field.name, _selectedItems);
                                state.didChange(_selectedItems); // Notify FormField of changes
                              });
                            },
                          );
                        },
                      ),
                    );
                  }).toList(),
                  onChanged: (_) {}, // No need for direct selection
                ),
              ),
            );
          },
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