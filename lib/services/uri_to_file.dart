import 'dart:io';

import 'package:flutter/material.dart';

// Convert a URI to a File
Future<File?> uriToFile(Uri? uri) async {
  if (uri == null) {
    return null;
  }

  try {
    // Attempt to create a File from the URI
    return File.fromUri(uri);
  } catch (e) {
    // Handle any errors that occur during the process
    debugPrint('Error converting URI to File: $e');
    return null;
  }
}
