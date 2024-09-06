import 'package:flutter/material.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:pdf_reader/pages/home/home_page.dart';
import 'package:pdf_reader/providers/dictionary_provider.dart';
import 'package:pdf_reader/providers/pdf_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MediaStore.ensureInitialized();
  MediaStore.appFolder = "PdfReader";

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PdfProvider()),
        ChangeNotifierProvider(create: (context) => DictionaryProvider())
      ],
      child: MaterialApp(
        title: 'PDF Reader',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
