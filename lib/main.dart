// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; 
// import 'package:dynamic_form/dynamic_form.dart'; // Import your library

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Dynamic Form Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: DynamicFormScreen(),
//     );
//   }
// }

// class DynamicFormScreen extends StatefulWidget {
//   @override
//   _DynamicFormScreenState createState() => _DynamicFormScreenState();
// }

// class _DynamicFormScreenState extends State<DynamicFormScreen> {
//   Map<String, dynamic>? _formJson;
//   Map<String, String> _formData = {};

//   // Create a GlobalKey for the FormRendererState
//   final GlobalKey<FormRendererState> formRendererKey = GlobalKey<FormRendererState>();

//   @override
//   void initState() {
//     super.initState();
//     _loadFormJson();
//   }

//   /// Load JSON from assets dynamically
//   Future<void> _loadFormJson() async {
//     try {
//       String jsonString = await rootBundle.loadString('assets/formdata.json');
//       setState(() {
//         _formJson = json.decode(jsonString);
//       });
//     } catch (e) {
//       print("Error loading form JSON: $e");
//     }
//   }

//   /// Handle form submission
//   void _handleFormSubmit(Map<String, String> submittedData) {
//     setState(() {
//       _formData = submittedData;
//     });

//     print("Form Submitted Data: $_formData");

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Form submitted successfully!")),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Dynamic Form Example")),
//       body: _formJson == null
//           ? Center(child: CircularProgressIndicator()) // Show loader until JSON is loaded
//           : Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: FormRenderer(
//                       key: formRendererKey,
//                       template: _formJson!['data']['template'],
//                       onSubmit: _handleFormSubmit,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Call the submit function in FormRenderer
//                       formRendererKey.currentState?.submitForm();
//                     },
//                     child: Text("Submit"),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }





import 'package:dynamic_form/dynamic_form.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dynamic Form Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DynamicFormScreen(),
    );
  }
}

class DynamicFormScreen extends StatefulWidget {
  @override
  _DynamicFormScreenState createState() => _DynamicFormScreenState();
}

class _DynamicFormScreenState extends State<DynamicFormScreen> {
  Map<String, dynamic>? _formJson;
  final GlobalKey<FormRendererState> formRendererKey = GlobalKey<FormRendererState>();

  @override
  void initState() {
    super.initState();
    _loadFormJson();
  }

  /// ✅ Load form JSON from assets
  Future<void> _loadFormJson() async {
    String jsonString = await rootBundle.loadString('assets/formdata.json');
    setState(() {
      _formJson = json.decode(jsonString);
    });
  }

  /// ✅ Handle form submission in `main.dart`
  void _handleFormSubmit() {
    final formState = formRendererKey.currentState;
    if (formState != null) {
      try {
        final submittedData = formState.submitForm();
        print("🚀 Submitted Data: $submittedData");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Form submitted successfully!")),
        );
      } catch (e) {
        print("❌ Validation Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dynamic Form Example")),
      body: _formJson == null
          ? Center(child: CircularProgressIndicator()) // Show loader until JSON is loaded
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: FormRenderer(
                      key: formRendererKey,
                      template: _formJson!['data']['template'],
                      onSubmit: (data) {}, // Submission handled manually
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _handleFormSubmit,
                    child: Text("Submit"),
                  ),
                ],
              ),
            ),
    );
  }
}





