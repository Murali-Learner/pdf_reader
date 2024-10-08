import 'package:pdf_reader/models/word_model.dart';
import 'package:pdf_reader/pages/dictionary/widgets/word_bottom_sheet.dart';
import 'package:pdf_reader/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class WordTile extends StatelessWidget {
  const WordTile({
    super.key,
    required this.word,
  });

  final Word word;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      child: ListTile(
        onTap: () {
          context.hideKeyBoard();
          showModalBottomSheet(
            showDragHandle: true,
            context: context,
            isScrollControlled: true,
            builder: (context) => WordBottomSheet(word: word),
          );
        },
        title: Text(word.word),
        subtitle: Text(word.word),
      ),
    );
  }
}
