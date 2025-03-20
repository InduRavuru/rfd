
import '../models/form_field_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateField extends StatefulWidget {
  final FormFieldModel field;
  final Function(String, String) onValueChange;

  const DateField({
    Key? key,
    required this.field,
    required this.onValueChange,
  }) : super(key: key);

  @override
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  late TextEditingController _controller;
  bool _hasBeenTouched = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.field.value);
  }

  /// ✅ Parses Date Format from JSON
  DateFormat _parseDateFormat(String format) {
    switch (format) {
      case "yy-MM-dd":
        return DateFormat("yy-MM-dd");
      case "dd-MM-yyyy":
        return DateFormat("dd-MM-yyyy");
      case "MM-dd-yyyy":
        return DateFormat("MM-dd-yyyy");
      default:
        return DateFormat("yyyy-MM-dd");
    }
  }

  /// ✅ Ensures `initialDate` is valid
  DateTime _getValidInitialDate() {
    DateTime now = DateTime.now();
    DateTime minDate = DateTime.tryParse(widget.field.min ?? now.toString()) ?? now;
    DateTime maxDate = DateTime.tryParse(widget.field.max ?? now.toString()) ?? now;
    DateTime initialDate = DateTime.tryParse(widget.field.value) ?? minDate;

    if (initialDate.isBefore(minDate)) return minDate;
    if (initialDate.isAfter(maxDate)) return maxDate;
    return initialDate;
  }

  void _selectDate() async {
    DateTime now = DateTime.now();
    DateTime minDate = DateTime.tryParse(widget.field.min ?? now.toString()) ?? now;
    DateTime maxDate = DateTime.tryParse(widget.field.max ?? now.toString()) ?? now;
    DateTime initialDate = _getValidInitialDate();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minDate,
      lastDate: maxDate,
    );

    if (picked != null) {
      String formattedDate = _parseDateFormat(widget.field.dateFormat).format(picked);
      setState(() {
        _controller.text = formattedDate;
        _hasBeenTouched = true;
      });
      widget.onValueChange(widget.field.name, formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: widget.field.displayName + (widget.field.mandatory ? " *" : ""),
          hintText: "Select a date",
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTooltip(widget.field.description, widget.field.tooltipPlacement),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: widget.field.editable ? _selectDate : null,
              ),
            ],
          ),
        ),
        enabled: widget.field.editable,
        autovalidateMode: _hasBeenTouched
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        validator: (value) {
          if (widget.field.mandatory && (value == null || value.trim().isEmpty)) {
            return "This field is required";
          }
          DateTime? date = DateTime.tryParse(value ?? "");
          DateTime? minDate = DateTime.tryParse(widget.field.min ?? "");
          DateTime? maxDate = DateTime.tryParse(widget.field.max ?? "");

          if (minDate != null && date != null && date.isBefore(minDate)) {
            return "Date should not be before ${widget.field.min}";
          }
          if (maxDate != null && date != null && date.isAfter(maxDate)) {
            return "Date should not be after ${widget.field.max}";
          }
          return null;
        },
        onTap: widget.field.editable ? _selectDate : null,
      ),
    );
  }

  /// ✅ Tooltip for description
  Widget _buildTooltip(String description, String tooltipPlacement) {
    if (description.isEmpty) return const SizedBox.shrink();

    return Tooltip(
      message: description,
      preferBelow: tooltipPlacement == "top",
      verticalOffset: tooltipPlacement == "top" ? 20.0 : -20.0,
      child: Icon(Icons.info_outline, size: 20, color: Colors.purple[800]),
    );
  }
}
