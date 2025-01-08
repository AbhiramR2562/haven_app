import 'dart:io';
import 'package:flutter/material.dart';
import 'package:haven/models/product_model.dart';
import 'package:haven/utils/snackbar_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;

class ReceiptPage extends StatefulWidget {
  final List<ProductModel> products;
  final int quantities;
  final double totalAmount;

  ReceiptPage({
    required this.products,
    required this.totalAmount,
    required this.quantities,
  });

  @override
  _ReceiptPageState createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  @override
  void initState() {
    super.initState();
    // Check and request storage permission every time the page is loaded
    _checkAndRequestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 250,
                        width: 250,
                        child: Image.asset("assets/images/plant_purchased.png"),
                      ),
                    ),
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 50),
                    const SizedBox(height: 10),
                    const Text(
                      'Payment Successful!',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // Manually display each product
              for (var product in widget.products)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      // If there's an image URL, display the image
                      product.imageUrl.isNotEmpty
                          ? Image.asset(
                              product.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image,
                              size: 50, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Quantity: ${widget.quantities} - \$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                'Total Paid: \$${widget.totalAmount.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your order will be processed shortly.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              // Share and Download Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Share the receipt (this is not implemented here)
                      await _shareReceipt(context);
                    },
                    child: const Text('Share'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Check permissions and download the receipt as a PDF
                      await _checkAndRequestPermission();
                    },
                    child: const Text('Download'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to check and request storage permission with a dialog box
  Future<void> _checkAndRequestPermission() async {
    var status = await Permission.storage.status;

    if (!status.isGranted) {
      // If permission is not granted, show a dialog asking for permission
      _showPermissionDialog();
    } else {
      // Permission is already granted, generate and save the PDF
      await _generateAndDownloadPDF(widget.products, widget.totalAmount);
    }
  }

  // Function to show a dialog for storage permission request
  Future<void> _showPermissionDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Storage Permission Required"),
          content: const Text(
              "We need storage permission to save your receipt. Do you want to allow it?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Deny'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Request the permission
                await _requestPermission();
              },
              child: const Text('Allow'),
            ),
          ],
        );
      },
    );
  }

  // Function to request storage permission
  Future<void> _requestPermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission granted, generate and save the PDF
      await _generateAndDownloadPDF(widget.products, widget.totalAmount);
    } else {
      // If permission is denied, show a snackbar or message
      if (context.mounted) {
        showSnackBar(context, 'Storage permission denied');
      }
    }
  }

  // Function to generate and download the PDF
  Future<void> _generateAndDownloadPDF(
      List<ProductModel> products, double totalAmount) async {
    final pdf = pw.Document();

    // Add a page with receipt details
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.Text('Payment Successful!',
                style: const pw.TextStyle(fontSize: 20)),
            pw.SizedBox(height: 20),
            for (var product in products)
              pw.Row(
                children: [
                  // Add product name, quantity, and price to the PDF
                  pw.Column(
                    children: [
                      pw.Text(product.name),
                      pw.Text(
                          'Quantity: 1 - \$${product.price.toStringAsFixed(2)}'),
                    ],
                  ),
                ],
              ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Total Paid: \$${totalAmount.toStringAsFixed(2)}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Your order will be processed shortly.'),
          ]);
        },
      ),
    );

    // Get the app's document directory
    final outputDir =
        await getExternalStorageDirectory(); // Using external storage directory
    if (outputDir != null) {
      final filePath =
          '${outputDir.path}/receipt_${DateTime.now().millisecondsSinceEpoch}.pdf';

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      // Show a confirmation message and the path of the saved file
      if (context.mounted) {
        showSnackBar(context, 'Receipt saved at: $filePath');
      }
      print("PDF saved at: $filePath");
    } else {
      if (context.mounted) {
        showSnackBar(context, 'Failed to get external storage directory.');
      }
    }
  }

  // Function to share the receipt via email or other apps
  Future<void> _shareReceipt(BuildContext context) async {
    final outputDir = await getExternalStorageDirectory();
    final filePath =
        '${outputDir?.path}/receipt_${DateTime.now().millisecondsSinceEpoch}.pdf';

    print('Receipt ready for sharing at: $filePath');
  }
}
