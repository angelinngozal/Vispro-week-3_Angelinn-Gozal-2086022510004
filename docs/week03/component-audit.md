# H3 - Component audit

| Custom implementation | Material replacement |
| --- | --- |
| Room filters used a `GestureDetector` and decorated `Container` as buttons. | Replaced with `ChoiceChip` so the filters use Material selection, focus, and tap behavior. |
| The notification toast built its own row, icon, shape, and colors inside a `SnackBar`. | Replaced with a standard `SnackBar` and moved its visual treatment into `snackBarTheme`. |
| The notification count used a manually positioned circle and text. | Replaced with the Material `Badge.count` component. |
| Metric cards used a decorated `Container` and `GestureDetector`, and also returned an `Expanded` that duplicated the parent's flex layout. | Replaced with themed `Card` and `InkWell`; flex sizing now belongs to the screen layout. |
| Device tiles used a decorated `Container` to draw card surfaces and borders. | Replaced with a themed `Card`; active/inactive colors use the app `ColorScheme`. |

Commit note: Replaced custom room-filter buttons, notification count, and toast with Material `ChoiceChip`, `Badge`, and `SnackBar`; migrated metric and device surfaces to themed `Card` components.
