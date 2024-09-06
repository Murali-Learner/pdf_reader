import 'package:flutter/material.dart';
import 'package:pdf_reader/pages/download/download_page.dart';
import 'package:pdf_reader/pages/home/widgets/opened_pdf_list.dart';
import 'package:pdf_reader/providers/pdf_provider.dart';
import 'package:pdf_reader/utils/extensions/context_extension.dart';
import 'package:pdf_reader/widgets/shimmer_loading.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PdfProvider provider;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    provider = context.read<PdfProvider>();
    await Future.delayed(Duration.zero).whenComplete(() async {
      await provider.handleIntent();
      provider.internetSubscription();
      await provider.askPermissions();
    });
  }

  @override
  void dispose() {
    super.dispose();
    provider.internetDispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pocket PDF'),
        actions: [
          Consumer<PdfProvider>(
            builder: (context, provider, _) {
              return provider.totalPdfs.isEmpty
                  ? const SizedBox.shrink()
                  : IconButton(
                      tooltip: "Pick a PDF",
                      onPressed: () async {
                        await provider.pickFile();
                      },
                      icon: const Icon(Icons.add),
                    );
            },
          ),
          IconButton(
            tooltip: "Downloads",
            onPressed: () {
              context.push(navigateTo: const DownloadPage());
              provider.resetValues();
            },
            icon: const Icon(Icons.download_rounded),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer(builder: (context, provider, _) {
          return Consumer<PdfProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const ShimmerLoading();
              } else if (provider.totalPdfs.isEmpty) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await provider.pickFile();
                    },
                    child: const Text("Pick a PDF"),
                  ),
                );
              } else {
                return OpenedPdfListView(
                  pdfLists: provider.totalPdfs.values.toList(),
                );
              }
            },
          );
        }),
      ),
    );
  }
}
