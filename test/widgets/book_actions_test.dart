import 'package:aread/src/data/importers/document_converter.dart';
import 'package:aread/src/domain/entities/publication_metadata.dart';
import 'package:aread/src/presentation/widgets/book_actions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatFileSize', () {
    expect(formatFileSize(512), '512 B');
    expect(formatFileSize(1536), '1.5 KB');
    expect(formatFileSize(12 * 1024 * 1024), '12 MB');
    expect(formatFileSize(3 * 1024 * 1024 * 1024), '3.0 GB');
  });

  test('safeFileName strips characters file systems reject', () {
    expect(safeFileName('War: and/Peace?'), 'War and Peace');
    expect(safeFileName('  '), 'book');
    expect(safeFileName('a' * 100).length, 80);
  });

  test('cleanTitle normalizes a user-entered title', () {
    expect(DocumentConverter.cleanTitle('  The  Long\nTitle '), 'The Long Title');
    expect(DocumentConverter.cleanTitle('   '), isEmpty);
  });

  test('publication metadata copyWith changes only the title', () {
    const meta = PublicationMetadata(title: 'Old', identifier: 'id', authors: ['A']);
    final renamed = meta.copyWith(title: 'New');
    expect(renamed.title, 'New');
    expect(renamed.identifier, 'id');
    expect(renamed.authors, ['A']);
    expect(meta.title, 'Old');
  });
}
