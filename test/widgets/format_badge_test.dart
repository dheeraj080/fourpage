import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aread/src/presentation/widgets/app_chrome.dart';

void main() {
  testWidgets('format badge is a bare text label, not a file glyph', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: Center(child: FormatBadge(format: 'epub'))),
    ));

    expect(find.text('EPUB'), findsOneWidget);
    expect(find.byType(FigmaIcon), findsNothing);
  });
}
