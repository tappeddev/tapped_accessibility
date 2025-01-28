# tapped_accessibility ♿️

`tapped_accessibility` is a Flutter package that simplifies adding focus highlights and accessibility-friendly themes to your Flutter applications. It ensures a consistent and customizable way to display focused elements, improving the app's compliance with accessibility standards.

## Features

- **Customizable Focus Highlight**: Define padding, decoration, and other visual properties for focused elements.
- **Accessible and Inclusive Design**: Enhance the user experience for keyboard and assistive technology users.
- **Easy Integration**: Designed to seamlessly integrate into your Flutter apps with minimal setup.

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  tapped_accessibility:
    git:
      url: https://github.com/tappeddev/tapped_accessibility.git
      ref: v0.0.2
```

Simply wrap your MaterialApp into the 

```dart
MaterialApp(
    home: yourApp(),
    builder: (context, child) {
      return FocusHighlight(
        defaultTheme: AccessibilityThemeData(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green),
          ),
        ),
        child: child!,
      );
    },
)
```


⚠️ **Important:** The `FocusHighlight` **must** be part of the `builder` property of your `MaterialApp`. If placed elsewhere (e.g., in the `home` property), it will not receive the initial key events needed for the focus indicator, leading to inconsistent behavior.


