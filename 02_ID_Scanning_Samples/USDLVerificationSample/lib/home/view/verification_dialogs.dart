/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:material_ui/material_ui.dart';

// Every dialog here is shown with `useRootNavigator: false` and dismissed through its own
// route's BuildContext. Both matter: the sample runs standalone AND hosted inside the
// DebugApp, which pushes this sample's MaterialApp as a route on its own Navigator. With the
// defaults (`useRootNavigator: true` + popping via the screen's context) a dialog is pushed on
// the host's Navigator but dismissed against the sample's nested one, so it is never removed
// and its modal barrier swallows every tap.

/// Shows the "running verification checks" progress dialog.
///
/// Returns the callback that dismisses it. Calling it more than once is a no-op.
///
/// This one is pushed as an explicit [DialogRoute] rather than via `showDialog`, so that the
/// returned callback holds the route itself. The verification checks are synchronous, so the
/// dismissal can happen in the very same frame the dialog was shown — before the dialog's builder
/// has ever run. Anything that identifies the dialog by its `BuildContext` does not exist yet at
/// that point, so the dismissal would be silently dropped and this dialog, which cannot be closed
/// by tapping outside it, would stay up forever. The route exists as soon as it is pushed.
VoidCallback showVerificationProgressDialog(BuildContext context) {
  final navigator = Navigator.of(context);

  final route = DialogRoute<void>(
      context: context,
      // Carry the sample's theme across to the navigator that hosts the route.
      themes: InheritedTheme.capture(from: context, to: navigator.context),
      // The user CANNOT close this dialog by pressing outside it
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          // The background color
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                // The loading indicator
                CircularProgressIndicator(),
                SizedBox(
                  height: 15,
                ),
                Text('Running verification checks')
              ],
            ),
          ),
        );
      });

  navigator.push(route);

  return () {
    if (!route.isActive) {
      // Already dismissed: nothing to remove.
      return;
    }
    navigator.removeRoute(route);
  };
}

void showVerificationResultDialog(BuildContext context, List<Text> results, {VoidCallback? onDismissed}) {
  showDialog(
      useRootNavigator: false,
      context: context,
      builder: (dialogContext) => AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: results,
            ),
            actions: [
              GestureDetector(
                  child: Text('OK'),
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                  })
            ],
          )).then((_) {
        // Enable capture again, after the dialog is dismissed.
        onDismissed?.call();
      });
}

void showIdRejectedDialog(BuildContext context, String reason, {VoidCallback? onDismissed}) {
  showDialog(
      useRootNavigator: false,
      context: context,
      builder: (dialogContext) => AlertDialog(
            content: Text(
              reason,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            actions: [
              GestureDetector(
                  child: Text('OK'),
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                  })
            ],
          )).then((_) {
        // Enable capture again, after the dialog is dismissed.
        onDismissed?.call();
      });
}
