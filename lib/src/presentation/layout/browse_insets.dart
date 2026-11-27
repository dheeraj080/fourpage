import 'package:flutter/widgets.dart';

import 'window_class.dart';

/// Geometry shared by the compact nav pill and the browse screens behind it.
/// Keeping it here stops list padding and the pill from drifting apart.
const double compactNavPillHeight = 68;
const double compactNavLabelHeight = 25;
const double compactNavLabelGap = 6;
const double compactNavBottomInset = 36;

/// Total space a browse list needs below its last row on a phone: the pill,
/// its label, the bottom inset, and a little breathing room below the fade.
const double compactNavClearance = compactNavBottomInset +
    compactNavPillHeight +
    compactNavLabelGap +
    compactNavLabelHeight +
    15;

/// Bottom padding for browse lists: on phones the floating nav pill needs
/// [compactNavClearance] points of clearance; with the side rail a normal
/// margin is enough.
double browseBottomPadding(BuildContext context) =>
    context.windowClass.isCompact ? compactNavClearance : 24;
