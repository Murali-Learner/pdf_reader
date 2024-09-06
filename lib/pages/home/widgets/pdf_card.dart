import 'package:flutter/material.dart';
import 'package:pdf_reader/models/pdf_model.dart';
import 'package:pdf_reader/pages/home/widgets/pdf_viewer_widget.dart';
import 'package:pdf_reader/providers/pdf_provider.dart';
import 'package:pdf_reader/utils/extensions/context_extension.dart';
import 'package:provider/provider.dart';

class PdfCard extends StatelessWidget {
  final PdfModel pdf;
  const PdfCard({super.key, required this.pdf});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<PdfProvider>();
    return ListTile(
      onTap: () {
        provider.setCurrentPDF(pdf);
        context.push(navigateTo: const PdfViewerWidget());
      },
      dense: true,
      tileColor: Colors.amber.shade100,
      title: Text(pdf.fileName),
      subtitle: Text(pdf.filePath),
      trailing: Text(pdf.id.toString()),
    );
  }
}
