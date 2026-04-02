import 'package:flutter/material.dart';

/// Hover feedback that updates on the **next** frame after pointer events.
///
/// Synchronous [setState] inside [MouseRegion.onEnter]/[MouseRegion.onExit] runs
/// during the mouse tracker’s device update on web/desktop and triggers
/// `!_debugDuringDeviceUpdate` and related hit-test assertions when combined
/// with resize/layout churn. Deferring breaks that re-entrancy.
class DeferredHoverMouseRegion extends StatefulWidget {
  const DeferredHoverMouseRegion({
    super.key,
    required this.builder,
    this.cursor = MouseCursor.defer,
    this.opaque = true,
  });

  final Widget Function(BuildContext context, bool isHovered) builder;
  final MouseCursor cursor;
  final bool opaque;

  @override
  State<DeferredHoverMouseRegion> createState() => _DeferredHoverMouseRegionState();
}

class _DeferredHoverMouseRegionState extends State<DeferredHoverMouseRegion> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_hovered == value) return;
      setState(() => _hovered = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      opaque: widget.opaque,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: widget.builder(context, _hovered),
    );
  }
}
