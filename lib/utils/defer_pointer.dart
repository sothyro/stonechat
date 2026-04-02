import 'package:flutter/widgets.dart';

/// Runs [action] after the current frame so pointer hover handlers do not call
/// [State.setState] during the mouse tracker's device update (fixes web/desktop
/// `!_debugDuringDeviceUpdate` and related hit-test assertions).
void deferAfterPointerFrame(VoidCallback action) {
  WidgetsBinding.instance.addPostFrameCallback((_) => action());
}
