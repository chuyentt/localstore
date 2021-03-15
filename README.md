# Localstore
[![pub package](https://img.shields.io/pub/v/localstore.svg)](https://pub.dartlang.org/packages/localstore)

A JSON file-based storage package provides a persistent repository for simple NoSQL documents.

## Getting Started

1. Calling `WidgetsFlutterBinding.ensureInitialized();` in main() before calling `runApp()`:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
```

2. Import `import 'package:localstore/localstore.dart';`

```dart
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
```

3. Creates an instance using the default `Localstore`

```dart
final db = Localstore.instance;
```
or using anywhere in your project.

4. Creates new item

```dart
// gets new id
final id = db.collection('todos').doc();

// save the item
db.collection('todos').doc(id).set({
  'title': 'Todo title',
  'done': false
});
```

5. Gets item by id

```dart
final data = await db.collection('todos').doc(id).get();
```

6. Delete item by id

```dart
db.collection('todos').doc(id).delete();
```

7. Using stream
```dart
final stream = db.collection('todos').stream;
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/chuyentt/localstore/issues