import 'dart:io';
import 'dart:typed_data';
import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';

class AnswerKeyPage extends StatefulWidget {
  final String answerKey;

  const AnswerKeyPage({
    Key? key,
    required this.answerKey,
  }) : super(key: key);

  @override
  State<AnswerKeyPage> createState() => _AnswerKeyPageState();
}

class _AnswerKeyPageState extends State<AnswerKeyPage> {
  Future<Uint8List?> cachePdf() async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = Uri.parse(widget.answerKey).pathSegments.last;
    final filePath = '${directory.path}/$fileName';

    File file = File(filePath);
    if (!file.existsSync()) {
      try {
        final response = await http.get(Uri.parse(widget.answerKey));
        await file.writeAsBytes(response.bodyBytes);
      } catch (e) {
        print('Error caching PDF: $e');
        return null;
      }
    }

    return file.readAsBytes(); // Return the PDF data as Uint8List
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<Uint8List?>(
        future: cachePdf(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorResources.colorBlue600,
              ),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error loading PDF'));
          }

          return PdfPreview(
            allowPrinting: false,
            allowSharing: false,
            useActions: false,
            canChangeOrientation: false,
            canChangePageFormat: false,
            previewPageMargin: EdgeInsets.zero,
            pdfFileName: "report.pdf",
            pdfPreviewPageDecoration: BoxDecoration(color: Colors.white),
            build: (format) async {
              return snapshot.data!;
            },
          );
        },
      ),
    );
  }
}
