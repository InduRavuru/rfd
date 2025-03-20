
// import 'package:flutter/material.dart';
// import '../services/form_service.dart';
// import 'dart:collection';

// class FormRenderer extends StatefulWidget {
//   final List<dynamic> template;
//   final Function(Map<String, dynamic>) onSubmit;

//   const FormRenderer({Key? key, required this.template, required this.onSubmit})
//       : super(key: key);

//   @override
//   FormRendererState createState() => FormRendererState();
// }

// class FormRendererState extends State<FormRenderer> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final Map<String, TextEditingController> _controllers = {};
//   Map<String, dynamic> _config = {};
//   bool _hasErrors = false;

//   @override
//   void initState() {
//     super.initState();
//     _config = {};
//     _initializeControllers(widget.template, _config);
//   }

//   void _initializeControllers(
//       List<dynamic> template, Map<String, dynamic> parentConfig) {
//     print(
//         "Initializing Controllers for: ${parentConfig.toString()}"); // Debug log
//     for (var field in template) {
//       if (field['type'] == 'textbox') {
//         _controllers[field['name']] =
//             TextEditingController(text: field['value'] ?? "");
//         parentConfig[field['name']] = field['value'] ?? "";
//         print("Added Textbox: ${field['name']}"); // Debug log
//       } else if (field['type'] == 'group') {
//         if (parentConfig[field['name']] == null) {
//           parentConfig[field['name']] = <String, dynamic>{};
//         }
//         print("Initializing Group: ${field['name']}"); // Debug log
//         _initializeControllers(field['children'], parentConfig[field['name']]);
//       }
//     }
//   }

//   void _updateConfig(String fieldPath, String newValue) {
//   print("Updating Config: $fieldPath = $newValue"); // Debug log
//   List<String> keys = fieldPath.split('.');
//   Map<String, dynamic> ref = _config;

//   for (int i = 0; i < keys.length - 1; i++) {
//     if (ref[keys[i]] is! Map<String, dynamic>) {
//       ref[keys[i]] = <String, dynamic>{}; // Initialize if not a map
//     }
//     ref = ref[keys[i]];
//   }

//   ref[keys.last] = newValue; // Set the value directly
//   print("Updated Config: ${_config.toString()}"); // Debug log
// }

//   Map<String, dynamic> submitForm() {
//     if (_formKey.currentState!.validate()) {
//       return Map<String, dynamic>.from(_config);
//     } else {
//       setState(() {
//         _hasErrors = true;
//       });
//       throw Exception("Form validation failed");
//     }
//   }

//   void _onValidationChange() {
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: FormService.buildForm(
//         widget.template,
//         _updateConfig,
//         _controllers,
//         _config,
//         _onValidationChange,
//         "", // Initialize with empty parentPath
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import '../services/form_service.dart';
import 'dart:collection';

class FormRenderer extends StatefulWidget {
  final List<dynamic> template;
  final Function(Map<String, dynamic>) onSubmit;

  const FormRenderer({Key? key, required this.template, required this.onSubmit})
      : super(key: key);

  @override
  FormRendererState createState() => FormRendererState();
}

class FormRendererState extends State<FormRenderer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  Map<String, dynamic> _config = {}; // Store structured form data dynamically
  bool _hasErrors = false;

  @override
  void initState() {
    super.initState();
    _config = {};
    _initializeControllers(widget.template, _config);
  }

  /// Initialize controllers & ensure `_config` maintains correct structure
  void _initializeControllers(
      List<dynamic> template, Map<String, dynamic> parentConfig) {
    print("Initializing Controllers for: ${parentConfig.toString()}"); // Debug log
    for (var field in template) {
      if (field['type'] == 'textbox') {
        _controllers[field['name']] = TextEditingController(text: field['value'] ?? "");
        parentConfig[field['name']] = field['value'] ?? "";
        print("Added Textbox: ${field['name']}"); // Debug log
      } else if (field['type'] == 'group') {
        if (parentConfig[field['name']] == null) {
          parentConfig[field['name']] = <String, dynamic>{};
        }
        print("Initializing Group: ${field['name']}"); // Debug log
        _initializeControllers(field['children'], parentConfig[field['name']]);
      }
    }
  }

  /// Update `_config` dynamically when user types
  // void _updateConfig(String fieldPath, String newValue) {
  //   print("Updating Config: $fieldPath = $newValue"); // Debug log

  //   List<String> keys = fieldPath.split('.');
  //   Map<String, dynamic> ref = _config;

  //   // Navigate through the nested structure
  //   for (int i = 0; i < keys.length - 1; i++) {
  //     if (!ref.containsKey(keys[i])) {
  //       ref[keys[i]] = {}; // Create nested structure if missing
  //     }
  //     ref = ref[keys[i]];
  //   }

  //   // Update the final key with the new value directly
  //   ref[keys.last] = newValue;

  //   print("Updated Config: ${_config.toString()}"); // Debug log
  // }




  void _updateConfig(String fieldPath, dynamic newValue) { // ✅ Accepts `dynamic` type
    print("Updating Config: $fieldPath = $newValue"); // Debug log

    List<String> keys = fieldPath.split('.');
    Map<String, dynamic> ref = _config;

    // Navigate through the nested structure
    for (int i = 0; i < keys.length - 1; i++) {
        if (!ref.containsKey(keys[i]) || ref[keys[i]] is! Map<String, dynamic>) {
            ref[keys[i]] = <String, dynamic>{}; // ✅ Ensure nested structure exists
        }
        ref = ref[keys[i]];
    }

    // Update the final key with the new value
    ref[keys.last] = newValue;

    print("Updated Config: ${_config.toString()}"); // Debug log
}


  /// Submit form & return structured data
  Map<String, dynamic> submitForm() {
    if (_formKey.currentState!.validate()) {
      return Map<String, dynamic>.from(_config); // Return a copy of _config
    } else {
      setState(() {
        _hasErrors = true;
      });
      throw Exception("Form validation failed");
    }
  }

  /// Ensure only touched fields validate
  void _onValidationChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: FormService.buildForm(
        widget.template,
        _updateConfig,
        _controllers,
        _config,
        _onValidationChange,
        "", // Initialize with empty parentPath
      ),
    );
  }
}