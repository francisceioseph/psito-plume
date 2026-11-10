import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';

/// Holds the closing of the window until [canClose] says it may go.
abstract class CloseGuard {
  Future<void> start(Future<bool> Function() canClose);
  void dispose();
}

/// The real one, through the window manager plugin.
class WindowCloseGuard with WindowListener implements CloseGuard {
  Future<bool> Function()? _canClose;

  @override
  Future<void> start(Future<bool> Function() canClose) async {
    _canClose = canClose;
    try {
      await windowManager.ensureInitialized();
      await windowManager.setPreventClose(true);
      windowManager.addListener(this);
    } on Object catch (error) {
      // Without the plugin (in the tests, say) the window just closes.
      debugPrint('the close guard is off: $error');
    }
  }

  @override
  void onWindowClose() async {
    final canClose = _canClose;
    if (canClose == null || await canClose()) await windowManager.destroy();
  }

  @override
  void dispose() => windowManager.removeListener(this);
}

/// For the tests: remembers the question, and closes nothing.
class FakeCloseGuard implements CloseGuard {
  Future<bool> Function()? canClose;

  @override
  Future<void> start(Future<bool> Function() canClose) async =>
      this.canClose = canClose;

  @override
  void dispose() {}
}
