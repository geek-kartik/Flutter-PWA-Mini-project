// pdf_blob_viewer.dart

import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:ui_web' as ui;

class PdfBlobViewer extends StatefulWidget {
  final String pdfUrl;

  const PdfBlobViewer({super.key, required this.pdfUrl});

  @override
  State<PdfBlobViewer> createState() => _PdfBlobViewerState();
}

class _PdfBlobViewerState extends State<PdfBlobViewer> {
  String? viewId;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadPdf(widget.pdfUrl);
  }

  Future<void> loadPdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception("Failed to load PDF");
      }

      final bytes = response.bodyBytes;

      final blob = html.Blob([bytes], 'application/pdf');
      final blobUrl = html.Url.createObjectUrlFromBlob(blob);

      viewId = 'pdf-viewer-${blobUrl.hashCode}';

      ui.platformViewRegistry.registerViewFactory(
        viewId!,
            (int id) {
          final iframe = html.IFrameElement()
            ..src = blobUrl
            ..style.border = 'none'
            ..width = '100%'
            ..height = '100%';
          return iframe;
        },
      );

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text("Error: $error"));
    }

    return SizedBox(
      height: 600,
      child: HtmlElementView(viewType: viewId!),
    );
  }
}
