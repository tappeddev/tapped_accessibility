import 'package:flutter/material.dart';
import 'package:tapped_accessibility/tapped_accessibility.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) {
        return FocusHighlight(
          defaultTheme: AccessibilityThemeData(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 2),
            ),
            padding: EdgeInsets.all(8),
          ),
          child: widget!,
        );
      },
      home: RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Press tab to move the focus around."),
            MaterialButton(
              onPressed: _openListPage,
              child: Text("Basic style"),
            ),
            const SizedBox(height: 48),
            Text("The following widget is customizing the focus highlight:"),
            AccessibleTheme(
              accessibilityTheme: AccessibilityThemeData(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 4),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: MaterialButton(
                onPressed: _openListPage,
                child: Text("Custom style"),
              ),
            ),
            const SizedBox(height: 48),
            DropdownButton<String>(
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: List.generate(20, (index) => "Item: $index").map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _openListPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListPage()));
  }
}

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Item $index"),
            trailing: IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailPage(),
                ),
              ),
              icon: Icon(Icons.arrow_right),
            ),
          );
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Go Back"),
        ),
      ),
    );
  }
}
