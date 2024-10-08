import 'package:pdf_reader/pages/dictionary/widgets/no_results_found.dart';
import 'package:pdf_reader/pages/dictionary/widgets/word_tile_widget.dart';
import 'package:pdf_reader/providers/dictionary_provider.dart';
import 'package:pdf_reader/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchListBuilder extends StatelessWidget {
  const SearchListBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<DictionaryProvider>(builder: (context, provider, _) {
        if (provider.isLoading) {
          return const ShimmerLoading();
        }

        if (provider.results.isEmpty) {
          return const NoResultsFound();
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: provider.results.length,
          itemBuilder: (context, index) {
            final item = provider.results.values.toList()[index];
            return WordTile(word: item);
          },
        );
      }),
    );
  }
}
