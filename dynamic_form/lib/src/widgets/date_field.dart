import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ✅ For date formatting
import '../models/form_field_model.dart';

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
  DateTime? _selectedDate;
  String? _errorText; // Validation message
  late DateFormat _dateFormat;
  DateTime? _minDate;
  DateTime? _maxDate;
  bool _hasBeenTouched = false; // ✅ Track if field was interacted with

  @override
  void initState() {
    super.initState();
    
    // ✅ Initialize date format
    _dateFormat = _parseDateFormat(widget.field.dateFormat);

    // ✅ Parse min & max date range
    _minDate = widget.field.min != null ? DateTime.tryParse(widget.field.min!) : null;
    _maxDate = widget.field.max != null ? DateTime.tryParse(widget.field.max!) : null;

    // ✅ Set default date if provided
    if (widget.field.value.isNotEmpty) {
      _selectedDate = DateTime.tryParse(widget.field.value);
    }
  }

  /// ✅ Handle date selection
  Future<void> _selectDate(BuildContext context) async {
    if (!widget.field.editable) return; // Prevent selection if `editable: false`

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(int.tryParse(widget.field.startRange) ?? 2000),
      lastDate: DateTime(int.tryParse(widget.field.endRange) ?? 2025),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      if (_isDateOutOfRange(pickedDate)) {
        setState(() {
          _errorText = "Date must be between ${widget.field.min} and ${widget.field.max}";
        });
      } else {
        setState(() {
          _selectedDate = pickedDate;
          _errorText = null;
          _hasBeenTouched = true;
        });

        // ✅ Pass formatted date value to parent
        widget.onValueChange(widget.field.name, _dateFormat.format(pickedDate));
      }
    }
  }

  /// ✅ Validate if selected date is within the allowed range
  bool _isDateOutOfRange(DateTime date) {
    return (_minDate != null && date.isBefore(_minDate!)) || (_maxDate != null && date.isAfter(_maxDate!));
  }

  /// ✅ Parse date format (Supports `yy-mm-dd`, `dd-mm-yyyy`, etc.)
  DateFormat _parseDateFormat(String format) {
    switch (format.toLowerCase()) {
      case "yy-mm-dd":
        return DateFormat("yy-MM-dd");
      case "dd-mm-yyyy":
        return DateFormat("dd-MM-yyyy");
      case "mm-dd-yyyy":
        return DateFormat("MM-dd-yyyy");
      default:
        return DateFormat("yyyy-MM-dd"); // Default format
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
          Text(
            widget.field.displayName + (widget.field.mandatory ? " *" : ""),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Select a date",
                  suffixIcon: _buildTooltip(context),
                  errorText: (_hasBeenTouched || _errorText != null) && widget.field.mandatory && _selectedDate == null
                      ? "This field is required"
                      : _errorText,
                ),
                controller: TextEditingController(
                  text: _selectedDate != null ? _dateFormat.format(_selectedDate!) : "",
                ),
                enabled: widget.field.editable,
                autovalidateMode: _hasBeenTouched ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTooltip(BuildContext context) {
    return Tooltip(
      message: widget.field.description,
      preferBelow: true,
      verticalOffset: 20.0,
      child: Icon(Icons.calendar_today, size: 20),
    );
  }
}
