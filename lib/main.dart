import 'package:flutter/material.dart';
import 'app_widget.dart';
import 'core/database/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase().database;
  runApp(const MyApp());
}
