# Localstore

[![pub package](https://img.shields.io/pub/v/localstore.svg)](https://pub.dartlang.org/packages/localstore)

Between SQL or NoSQL, there's no one best database, there's the right database for your specific project. Localstore is a JSON file-based storage package (localstorage) provides a persistent repository for simple NoSQL database.

| | Localstore (NoSQL) | SQLite (SQL) |
|-| -------------------| ------------ |
| Data format | File path (collection) | Table |
| Data item | JSON Document (doc) | Record / Row |
| Scalability | Horizontal | Limited vertical |
| Organization | Schema-less | Fixed schema |

## Demo Screenshot

<img src="https://user-images.githubusercontent.com/6267856/112655041-94e72100-8e82-11eb-8d9f-673f0f2e1b80.gif" width="320" />

## GeoJSON UML Model

![Localstore UML diagram](https://raw.githubusercontent.com/chuyentt/localstore/master/doc/localstore_uml_diagram.svg)

## Getting Started

1. Calling `WidgetsFlutterBinding.ensureInitialized();` in main() before calling `runApp()`:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
```

02. Import `import 'package:localstore/localstore.dart';`

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
final id = db.collection('todos').doc().id;

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

7. Fetch the documents for the collection

```dart
final items = await db.collection('todos').get();
```

8. Using stream

```dart
final stream = db.collection('todos').stream;
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/chuyentt/localstore/issues
