import 'package:flutter/material.dart';
import 'package:pocket_pdf/pages/home/home_page.dart';
import 'package:pocket_pdf/providers/dictionary_provider.dart';
import 'package:pocket_pdf/providers/pdf_provider.dart';
import 'package:provider/provider.dart';

void main() {
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
