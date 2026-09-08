import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import '../core/constants/app_constants.dart';

/// ExportService - PRD 05 WYSIWYG core
/// Captures RepaintBoundary at canvasPixelRatio 2.0
/// Preview == Export pixel-identical
class ExportService {
  /// Export canvas from [key] to PNG file at 2.0 pixel ratio
  static Future<File?> exportPng(
    GlobalKey key, {
    String fileName = 'greetings_export',
    double? pixelRatio,
  }) async {
    try {
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        debugPrint('Export: boundary not found');
        return null;
      }
      final ratio = pixelRatio ?? AppConstants.canvasPixelRatio;
      final image = await boundary.toImage(pixelRatio: ratio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;
      final pngBytes = byteData.buffer.asUint8List();
      // Size gate
      if (pngBytes.length > AppConstants.maxImageSizeBytes) {
        debugPrint('Export: exceeds 5MB ${pngBytes.length}');
      }
      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/${fileName}_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(pngBytes);
      return file;
    } catch (e) {
      debugPrint('Export failed: $e');
      return null;
    }
  }

  /// Export as bytes for direct share/upload
  static Future<Uint8List?> exportBytes(
    GlobalKey key, {
    double? pixelRatio,
  }) async {
    try {
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final ratio = pixelRatio ?? AppConstants.canvasPixelRatio;
      final image = await boundary.toImage(pixelRatio: ratio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Export bytes failed: $e');
      return null;
    }
  }

  /// Verify WYSIWYG - compares two captures byte-wise
  static Future<bool> verifyIdentical(GlobalKey a, GlobalKey b) async {
    final ba = await exportBytes(a);
    final bb = await exportBytes(b);
    if (ba == null || bb == null) return false;
    if (ba.length != bb.length) return false;
    for (var i = 0; i < ba.length; i++) {
      if (ba[i] != bb[i]) return false;
    }
    return true;
  }
}
