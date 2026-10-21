import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taller_2_3/firebase_options.dart';
import 'package:taller_2_3/local/app_database.dart';
import 'package:taller_2_3/local/product_note_local_data_source.dart';
import 'package:taller_2_3/products_screen.dart';
import 'package:taller_2_3/remote/product_note_remote_data_source.dart';
import 'package:taller_2_3/repositories/product_note_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  final database = AppDatabase();
  final local = ProductNoteLocalDataSource(database);
  final remote = ProductNoteRemoteDataSource(FirebaseFirestore.instance);
  final noteRepository = ProductNoteRepository(local: local, remote: remote);

  runApp(MyApp(noteRepository: noteRepository));
}

class MyApp extends StatelessWidget {
  final ProductNoteRepository noteRepository;

  const MyApp({super.key, required this.noteRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: ProductScreen(noteRepository: noteRepository),
    );
  }
}
