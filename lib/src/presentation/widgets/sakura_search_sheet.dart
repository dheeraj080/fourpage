import 'package:flutter/material.dart';
import '../../../l10n/l10n.dart';
import '../../domain/entities/reader_preferences.dart';
import '../theme/reader_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakura_epub/sakura_epub.dart';

/// Full-text search for the sakura_epub-backed reader, using the package's
/// own epub.js-powered search (returns real CFI + excerpt per match, no
/// separate parsing pipeline needed).
class SakuraSearchSheet extends StatefulWidget {
  final EpubController controller;
  final ReaderTheme theme;
  final ValueChanged<String> onNavigateToCfi;
  final String? initialQuery;

  const SakuraSearchSheet({
    super.key,
    required this.controller,
    required this.theme,
    required this.onNavigateToCfi,
    this.initialQuery,
  });

  @override
  State<SakuraSearchSheet> createState() => _SakuraSearchSheetState();
}

class _SakuraSearchSheetState extends State<SakuraSearchSheet> {
  late final _searchController = TextEditingController(text: widget.initialQuery);
  bool _isSearching = false;
  List<EpubSearchResult> _results = [];

  @override
  void initState() {
    super.initState();
    final initial = widget.initialQuery;
    if (initial != null && initial.trim().isNotEmpty) {
      _runSearch(initial);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _runSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() => _isSearching = true);
    try {
      final results = await widget.controller.search(query: query);
      if (mounted) setState(() => _results = results);
    } catch (_) {
      if (mounted) setState(() => _results = []);
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = ReaderColors(widget.theme);
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: colors.sheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(top: 10, bottom: 12),
                decoration: BoxDecoration(
                  color: colors.grip,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: GoogleFonts.sora(fontSize: 16, color: colors.ink),
                      onSubmitted: _runSearch,
                      decoration: InputDecoration(
                        hintText: l10n.searchInBook,
                        hintStyle: GoogleFonts.sora(fontSize: 16, color: colors.faintText),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.close, color: colors.muted, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _results = []);
                      },
                    ),
                ],
              ),
            ),
            Divider(color: colors.divider, height: 1, thickness: 1),
            if (_searchController.text.isNotEmpty && !_isSearching)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  l10n.searchResultsCount(_results.length),
                  style: GoogleFonts.sora(fontSize: 13, color: colors.faintText),
                ),
              ),
            if (_isSearching)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator(color: colors.accent)),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final r = _results[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      r.excerpt,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.sora(fontSize: 14, color: colors.ink),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onNavigateToCfi(r.cfi);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
