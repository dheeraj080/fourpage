import 'package:flutter/material.dart';

import '../../application/mappers/sakura_epub_mapper.dart';
import '../../domain/entities/reader_preferences.dart';

/// Colours for reader-owned chrome. Unlike [AppColors], these follow the book
/// page the reader is showing, so sheets, popups and controls stay in the
/// sepia/night/paper world instead of flipping with the app theme.
class ReaderColors {
  const ReaderColors(this.theme);

  final ReaderTheme theme;

  bool get isLightPage => switch (theme) {
    ReaderTheme.light || ReaderTheme.sepia => true,
    _ => false,
  };

  Color get page => SakuraEpubMapper.pageColorFor(theme);
  Color get ink => SakuraEpubMapper.textColorFor(theme);

  Color _tint(double lightAlpha, double darkAlpha) => Color.alphaBlend(ink.withValues(alpha: isLightPage ? lightAlpha : darkAlpha), page);

  /// Bottom sheets and full-height panels: a tonal step from the page, never
  /// an app-theme white slab.
  Color get sheet => _tint(0.12, 0.16);

  /// Floating controls (menus, popovers, selection card): one step above
  /// [sheet] so elevation reads without a hard border.
  Color get control => _tint(0.18, 0.24);

  Color get divider => ink.withValues(alpha: isLightPage ? 0.24 : 0.28);
  Color get track => ink.withValues(alpha: 0.28);

  /// Non-informational grips and slider remainder only.
  Color get grip => ink.withValues(alpha: 0.32);

  /// Informational foregrounds; all stay above 4.5:1 on every book page.
  Color get muted => ink.withValues(alpha: isLightPage ? 0.86 : 0.82);
  Color get secondaryText => ink.withValues(alpha: isLightPage ? 0.82 : 0.78);
  Color get faintText => ink.withValues(alpha: isLightPage ? 0.78 : 0.72);

  /// Deep green on paper/sepia, lime on dark pages; both clear 3:1 as a UI
  /// accent and 4.5:1 as small text.
  Color get accent => isLightPage ? const Color(0xFF254A08) : const Color(0xFFC6EF6F);
  Color get onAccent => isLightPage ? Colors.white : Colors.black;
}
