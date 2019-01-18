import 'package:flutter/material.dart';
import 'tick.dart';

void showTickOverlay(BuildContext context) async {
  OverlayState overlayState = Overlay.of(context);
  OverlayEntry overlayEntry = OverlayEntry(builder: (BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Tick(),
    );
  });
  overlayState.insert(overlayEntry);
  await Future.delayed(Duration(seconds: 1));
  overlayEntry.remove();
}
