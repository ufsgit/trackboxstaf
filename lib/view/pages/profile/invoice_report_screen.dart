// import 'package:breffini_staff/controller/profile_controller.dart';
// import 'package:breffini_staff/core/theme/color_resources.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:open_file/open_file.dart';
// import 'package:flutter/services.dart';

// class InvoiceReportScreen extends StatelessWidget {
//   const InvoiceReportScreen({super.key});

//   Future<void> _generateAndDownloadPDF(BuildContext context, int index,
//       ProfileController profileController) async {
//     final pdf = pw.Document();
//     final regularFont =
//         await rootBundle.load("assets/fonts/PlusJakartaSans-Regular.ttf");
//     final boldFont =
//         await rootBundle.load("assets/fonts/PlusJakartaSans-Bold.ttf");
//     final semiBoldFont =
//         await rootBundle.load("assets/fonts/PlusJakartaSans-SemiBold.ttf");

//     final ttfRegular = pw.Font.ttf(regularFont);
//     final ttfBold = pw.Font.ttf(boldFont);
//     final ttfSemiBold = pw.Font.ttf(semiBoldFont);
//     // Load company logo
//     final ByteData imageData =
//         await rootBundle.load('assets/images/ic_launcher.png');
//     final Uint8List imageBytes = imageData.buffer.asUint8List();

//     // Define styles matching your widgets
//     final titleStyle = pw.TextStyle(
//       font: ttfBold,
//       fontSize: 24,
//       color: PdfColor.fromHex('616161'),
//     );

//     final grey500Style = pw.TextStyle(
//       font: ttfRegular,
//       fontSize: 14,
//       color: PdfColor.fromHex('9E9E9E'),
//     );

//     final grey600Style = pw.TextStyle(
//       font: ttfSemiBold,
//       fontSize: 14,
//       color: PdfColor.fromHex('757575'),
//     );

//     final grey700Style = pw.TextStyle(
//       font: ttfSemiBold,
//       fontSize: 14,
//       color: PdfColor.fromHex('616161'),
//     );

//     final addressStyle = pw.TextStyle(
//       font: ttfSemiBold,
//       fontSize: 12,
//       color: PdfColor.fromHex('757575'),
//     );

//     pdf.addPage(
//       pw.Page(
//         margin: const pw.EdgeInsets.all(40),
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.Text('Invoice', style: titleStyle),
//               pw.SizedBox(height: 16),

//               pw.Container(
//                 height: 175,
//                 child: pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Text(
//                           'Invoice no: ${profileController.getInvoice[index].invoiceId}',
//                           style: grey600Style,
//                         ),
//                         pw.SizedBox(height: 4),
//                         pw.Text(
//                           'Date: ${DateFormat('MMM dd, yyyy').format(profileController.getInvoice[index].invoiceDate)}',
//                           style: grey600Style,
//                         ),
//                         pw.SizedBox(height: 12),
//                         _buildPDFRichText(
//                             'Bill to',
//                             profileController.getInvoice[index].name,
//                             grey600Style),
//                         pw.SizedBox(height: 4),
//                         _buildPDFRichText(
//                             'Position',
//                             profileController.getInvoice[index].position,
//                             grey600Style),
//                         pw.SizedBox(height: 4),
//                         _buildPDFRichText(
//                             'Course',
//                             profileController.getInvoice[index].courseName,
//                             grey600Style),
//                       ],
//                     ),

//                     // Right Column
//                     pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.end,
//                       children: [
//                         pw.Container(
//                           height: 32,
//                           width: 26,
//                           child: pw.Image(pw.MemoryImage(imageBytes)),
//                         ),
//                         pw.SizedBox(height: 16),
//                         pw.Text(
//                           '''Breffni Tower,176/10,
// Vazhappally west,
// Thuruthy p.o,
// Changanassery,
// Kottayam-686535
// 8899889988
// info@breffniacademy.in''',
//                           style: addressStyle,
//                           textAlign: pw.TextAlign.right,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               pw.SizedBox(height: 32),

//               // Course Details Section using your buildRowDetails style
//               _buildPDFRowDetails(
//                   'Class name',
//                   profileController.getInvoice[index].courseName,
//                   grey500Style,
//                   grey700Style),
//               _buildPDFRowDetails(
//                   'Payment period',
//                   profileController.getInvoice[index].paymentPeriod,
//                   grey500Style,
//                   grey700Style),
//               _buildPDFRowDetails(
//                   'Hours',
//                   profileController.getInvoice[index].classHours,
//                   grey500Style,
//                   grey700Style),
//               pw.SizedBox(height: 24),
//               _buildPDFRowDetails(
//                   'Total Amount',
//                   profileController.getInvoice[index].totalAmount,
//                   grey500Style,
//                   grey700Style),
//               pw.SizedBox(height: 24),
//               _buildPDFRowDetails('Approved By', 'Authorized Signature',
//                   grey500Style, grey700Style),
//               pw.SizedBox(height: 14),
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Text(profileController.getInvoice[index].approvedBy,
//                       style: const pw.TextStyle(fontSize: 16)),
//                   pw.Column(
//                     children: [
//                       pw.Text('', style: const pw.TextStyle(fontSize: 16)),
//                       pw.SizedBox(
//                         height: 16,
//                       ),
//                       pw.Text('Signature',
//                           style: const pw.TextStyle(fontSize: 16)),
//                     ],
//                   ),
//                 ],
//               ),

//               pw.SizedBox(height: 32),

//               // Terms & Conditions
//               pw.Text('Terms & Conditions:', style: grey600Style),
//               pw.SizedBox(height: 4),
//               pw.Text('* Payment is due within 30 days', style: grey600Style),
//               pw.Text('* Please include invoice number on your payment',
//                   style: grey600Style),
//               pw.Text('* Make all checks payable to company name',
//                   style: grey600Style),
//             ],
//           );
//         },
//       ),
//     );

//     // Get the application directory
//     final directory = await getApplicationDocumentsDirectory();
//     final String fileName =
//         'Invoice_${profileController.getInvoice[index].invoiceId}.pdf';
//     final String filePath = '${directory.path}/$fileName';

//     // Save the PDF
//     final File file = File(filePath);
//     await file.writeAsBytes(await pdf.save());

//     // Show success dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Download Complete'),
//           content: const Text('Invoice has been downloaded successfully.'),
//           actions: [
//             TextButton(
//               child: const Text('View'),
//               onPressed: () {
//                 OpenFile.open(filePath);
//                 Navigator.pop(context);
//               },
//             ),
//             TextButton(
//               child: const Text('Close'),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   pw.Widget _buildPDFRowDetails(String label, String value,
//       pw.TextStyle labelStyle, pw.TextStyle valueStyle) {
//     return pw.Row(
//       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//       children: [
//         pw.Text(label, style: labelStyle),
//         pw.Text(value, style: valueStyle),
//       ],
//     );
//   }

//   pw.Widget _buildPDFRichText(String label, String value, pw.TextStyle style) {
//     return pw.RichText(
//       text: pw.TextSpan(
//         style: style,
//         children: [
//           pw.TextSpan(text: label),
//           const pw.TextSpan(text: ' : '),
//           pw.TextSpan(
//             text: value,
//             style: style.copyWith(fontWeight: pw.FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ProfileController profileController = Get.put(ProfileController());
//     return SafeArea(
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: Container(
//             color: ColorResources.colorwhite,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: Container(
//                       height: 24,
//                       width: 24,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(50),
//                         color: ColorResources.colorBlue100,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         child: Icon(
//                           Icons.arrow_back_ios,
//                           color: ColorResources.colorBlack.withOpacity(.4),
//                           size: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Invoice details',
//                     style: GoogleFonts.plusJakartaSans(
//                       color: ColorResources.colorBlack,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         backgroundColor: ColorResources.colorgrey200,
//         body: SingleChildScrollView(
//           child: ListView.builder(
//             itemCount: profileController.getInvoice.length,
//             shrinkWrap: true,
//             physics: const ClampingScrollPhysics(),
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 child: Container(
//                   width: Get.width,
//                   color: ColorResources.colorwhite,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Invoice',
//                               style: GoogleFonts.plusJakartaSans(
//                                 color: ColorResources.colorgrey700,
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                             TextButton(
//                                 onPressed: () => _generateAndDownloadPDF(
//                                     context, index, profileController),
//                                 child: Text(
//                                   'Download',
//                                   style: GoogleFonts.plusJakartaSans(
//                                     color: ColorResources.colorBlue600,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ))
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                         _buildInvoiceDetails(
//                             billTo: profileController.getInvoice[index].name,
//                             course:
//                                 profileController.getInvoice[index].courseName,
//                             date: DateFormat('MMM dd, yyyy').format(
//                                 profileController
//                                     .getInvoice[index].invoiceDate),
//                             invoiceNo: profileController
//                                 .getInvoice[index].invoiceId
//                                 .toString(),
//                             position:
//                                 profileController.getInvoice[index].position),
//                         const SizedBox(
//                           height: 32,
//                         ),
//                         buildRowDetails(
//                             label: 'Class name',
//                             value:
//                                 profileController.getInvoice[index].courseName),
//                         buildRowDetails(
//                             label: 'Payment period',
//                             value: profileController
//                                 .getInvoice[index].paymentPeriod),
//                         buildRowDetails(
//                             label: 'Hours',
//                             value:
//                                 profileController.getInvoice[index].classHours),
//                         // buildRowDetails(
//                         //     label: 'Rate',
//                         //     value:
//                         //         profileController.getInvoice[index].totalAmount),
//                         const SizedBox(
//                           height: 24,
//                         ),
//                         buildRowDetails(
//                             label: 'Total Amount',
//                             value:
//                                 profileController.getInvoice[index].totalAmount,
//                             fontWeight: FontWeight.w600),
//                         const SizedBox(
//                           height: 24,
//                         ),
//                         buildRowDetails(
//                             label: 'Approved By',
//                             value: 'Authorized Signature',
//                             valueColor: ColorResources.colorgrey400,
//                             fontWeight: FontWeight.w700),
//                         const SizedBox(
//                           height: 14,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               profileController.getInvoice[index].approvedBy,
//                               style: GoogleFonts.plusJakartaSans(
//                                 color: ColorResources.colorBlack,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w800,
//                               ),
//                             ),
//                             Column(
//                               children: [
//                                 Text(
//                                   '',
//                                   style: GoogleFonts.plusJakartaSans(
//                                     color: ColorResources.colorBlack,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w800,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Signature',
//                                   style: GoogleFonts.plusJakartaSans(
//                                     color: ColorResources.colorBlack,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 32,
//                         ),
//                         Text(
//                           'Terms & Conditions:',
//                           style: GoogleFonts.plusJakartaSans(
//                             color: ColorResources.colorgrey600,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 4,
//                         ),
//                         Text(
//                           '* Payment is due within 30 days',
//                           style: GoogleFonts.plusJakartaSans(
//                             color: ColorResources.colorgrey600,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Text(
//                           '* Please include invoice number on your payment',
//                           style: GoogleFonts.plusJakartaSans(
//                             color: ColorResources.colorgrey600,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Text(
//                           '* Make all checks payable to company name',
//                           style: GoogleFonts.plusJakartaSans(
//                             color: ColorResources.colorgrey600,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// //widgets in this page
// Widget buildRowDetails({
//   required String label,
//   required String value,
//   Color? labelColor,
//   Color? valueColor,
//   double? fontSize,
//   FontWeight? fontWeight,
//   EdgeInsetsGeometry? padding,
//   MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceBetween,
// }) {
//   return Padding(
//     padding: padding ?? EdgeInsets.zero,
//     child: Row(
//       mainAxisAlignment: mainAxisAlignment,
//       children: [
//         Text(
//           label,
//           style: GoogleFonts.plusJakartaSans(
//             color: labelColor ?? ColorResources.colorgrey500,
//             fontSize: fontSize ?? 14,
//             fontWeight: fontWeight ?? FontWeight.w500,
//           ),
//         ),
//         Text(
//           value,
//           style: GoogleFonts.plusJakartaSans(
//             color: valueColor ?? ColorResources.colorgrey700,
//             fontSize: fontSize ?? 14,
//             fontWeight: fontWeight ?? FontWeight.w500,
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildInvoiceDetails(
//     {required String invoiceNo,
//     required String date,
//     required String billTo,
//     required String position,
//     required String course}) {
//   return SizedBox(
//     height: 185.h,
//     width: Get.width,
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildLeftColumn(
//             billTo: billTo,
//             course: course,
//             date: date,
//             invoiceNo: invoiceNo,
//             position: position),
//         _buildRightColumn(),
//       ],
//     ),
//   );
// }

// Widget _buildLeftColumn(
//     {required String invoiceNo,
//     required String date,
//     required String billTo,
//     required String position,
//     required String course}) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       _buildDetailText('Invoice no:$invoiceNo', FontWeight.w600, 14),
//       const SizedBox(height: 4),
//       _buildDetailText('Date:$date', FontWeight.w500, 14),
//       const SizedBox(height: 12),
//       buildRichTextWidget('Bill to', billTo, FontWeight.w500),
//       const SizedBox(height: 4),
//       buildRichTextWidget('Position', position, FontWeight.w500),
//       const SizedBox(height: 4),
//       buildRichTextWidget('Course', course, FontWeight.w500),
//     ],
//   );
// }

// Widget _buildRightColumn() {
//   const addressText = '''
// Breffni Tower,176/10,
// Vazhappally west,
// Thuruthy p.o,
// Changanassery,
// Kottayam-686535
// 8899889988
// info@breffniacademy.in''';

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.end,
//     mainAxisAlignment: MainAxisAlignment.end,
//     children: [
//       SizedBox(
//         height: 32,
//         width: 26,
//         child: Image.asset('assets/images/ic_launcher.png'),
//       ),
//       const SizedBox(
//         height: 16,
//       ),
//       Expanded(
//         child: Text(
//           addressText,
//           style: GoogleFonts.plusJakartaSans(
//             color: ColorResources.colorgrey600,
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//           ),
//           textAlign: TextAlign.right,
//         ),
//       ),
//     ],
//   );
// }

// Widget _buildDetailText(String text, FontWeight weight, double fontSize) {
//   return Text(
//     text,
//     style: GoogleFonts.plusJakartaSans(
//       color: ColorResources.colorgrey600,
//       fontSize: fontSize,
//       fontWeight: weight,
//     ),
//   );
// }

// Widget buildRichTextWidget(String label, String value, FontWeight weight) {
//   return RichText(
//     text: TextSpan(
//       style: GoogleFonts.plusJakartaSans(
//         color: ColorResources.colorgrey600,
//         fontSize: 14,
//       ),
//       children: [
//         TextSpan(
//           text: label,
//           style: TextStyle(
//             fontWeight: weight,
//           ),
//         ),
//         const TextSpan(
//           text: ' : ', // Add space between label and value
//         ),
//         TextSpan(
//           text: value,
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             color: ColorResources.colorgrey600,
//           ),
//         ),
//       ],
//     ),
//   );
// }
