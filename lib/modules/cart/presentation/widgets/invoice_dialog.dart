import 'package:flutter/material.dart';
import 'package:mini_project_pwa/core/utils/helpers/pdf_download_helper.dart';

/// Dialog to show dummy invoice details with download pdf option
void showInvoiceDialog({
  required BuildContext context,
  required String invoiceUrl,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Payment Successful 🎉"),
        content: const Text("Would you like to download your invoice?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Later"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              PdfDownloadHelper.downloadProtectedPdf(
                url: invoiceUrl,
                title: .invoice,
              );
            },
            child: const Text(
              "Download",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
