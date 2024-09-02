import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pocket_pdf/pages/home/widgets/pdf_control_buttons.dart';
import 'package:pocket_pdf/pdfrx/pdfrx_lib/src/widgets/pdf_viewer.dart';
import 'package:pocket_pdf/pdfrx/pdfrx_lib/src/widgets/pdf_viewer_params.dart';
import 'package:pocket_pdf/providers/pdf_provider.dart';
import 'package:pocket_pdf/utils/constants.dart';
import 'package:pocket_pdf/widgets/global_loading_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final provider = context.read<PdfProvider>();
    await provider.init();
    Future.delayed(Duration.zero).whenComplete(() async {
      await provider.handleIntent();
    });
  }

  @override
  void dispose() {
    context.read<PdfProvider>().disposeIntentListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Constants.scaffoldKey,
      appBar: AppBar(
        title: const Text('Pocket PDF'),
        actions: [
          Consumer<PdfProvider>(builder: (context, provider, _) {
            return provider.currentPDF != null
                ? IconButton(
                    onPressed: () async {
                      await provider.pickFile();
                    },
                    icon: const Icon(
                      Icons.add,
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<PdfProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading || provider.pdfController == null) {
                  return const GlobalLoadingWidget();
                }

                if (provider.currentPDF == null) {
                  return ElevatedButton(
                    onPressed: () async {
                      await provider.pickFile();
                    },
                    child: const Text("Pick a PDF"),
                  );
                }

                return Expanded(
                  child: Column(
                    children: [
                      if (provider.currentPDF != null)
                        const PdfControlButtons(),
                      Expanded(
                        child: PdfViewer.file(
                          provider.currentPDF!.filePath,
                          controller: provider.pdfController!,
                          passwordProvider: _passwordDialog,
                          params: PdfViewerParams(
                            onInteractionStart: (details) {},
                            // single child scroll
                            //
                            margin: 20,
                            onTextSelectionChange: (selection) {
                              // if (selection != null) {
                              //   final text = selection.first.text;
                              //   final List<String> words = text.split(" ");

                              //   debugPrint("selection ${words.length}");
                              // }
                            },
                            onViewerReady: (document, controller) {
                              provider.handlePDF();
                              controller.setZoom(
                                  controller.centerPosition, 0.5);
                              final pdf = provider.currentPDF!.copyWith(
                                pageNumber: controller.pageNumber!,
                                lastSeen: DateTime.now(),
                              );
                              provider.setCurrentPDF(pdf);
                              provider.setZoomControl(controller);
                            },
                            boundaryMargin: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 5.0,
                            ),
                            activeMatchTextColor: Colors.red,
                            enableTextSelection: true,
                            panEnabled: true,
                            onPageChanged: (pageNumber) {
                              final pdf = provider.currentPDF!.copyWith(
                                pageNumber: pageNumber,
                              );
                              provider.setCurrentPDF(pdf);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _passwordDialog() async {
    final textController = TextEditingController();
    return await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PasswordDialogWidget(textController: textController);
      },
    );
  }
}

class PasswordDialogWidget extends StatelessWidget {
  const PasswordDialogWidget({
    super.key,
    required this.textController,
  });

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter password'),
      content: TextField(
        controller: textController,
        autofocus: true,
        keyboardType: TextInputType.visiblePassword,
        // obscureText: true,
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            log("message ${textController.text.trim()}");
            Navigator.of(context).pop(textController.text.trim());
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
