import 'package:flutter/material.dart';
import 'package:pdf_reader/models/pdf_model.dart';
import 'package:pdf_reader/pages/home/widgets/pdf_card.dart';

class OpenedPdfListView extends StatelessWidget {
  final List<PdfModel> pdfLists;
  const OpenedPdfListView({super.key, required this.pdfLists});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: pdfLists.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
      itemBuilder: (BuildContext context, int index) {
        return PdfCard(pdf: pdfLists[index]);
      },
    );
  }
}
