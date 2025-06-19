import 'package:pdf/widgets.dart' as pw;
import '../features/invoice/model/invoice.dart';

class InvoicePdfGenerator {
  static Future<pw.Document> generate(Invoice invoice) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text('Metatech', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Text("Invoice ID: ${invoice.id}"),
          pw.Text("Date: ${invoice.date}"),
          pw.Text("Status: ${invoice.status}"),
          pw.Divider(),
          pw.Text("Bill To: Ali Husnain"),
          pw.Text("Address: Office 503, Nassima Tower, Sheikh Zayed Road, Dubai, UAE"),
          pw.SizedBox(height: 20),

          pw.Table.fromTextArray(
            headers: ['#', 'Item', 'Description', 'Qty', 'Rate', 'Amount'],
            data: List.generate(invoice.items.length, (index) {
              final item = invoice.items[index];
              return [
                '${index + 1}',
                item.title,
                item.description,
                item.qty.toString(),
                item.rate.toStringAsFixed(2),
                item.amount.toStringAsFixed(2),
              ];
            }),
          ),

          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Sub Total: ${invoice.subTotal.toStringAsFixed(2)}"),
                  pw.Text("Tax Rate: ${invoice.taxRate.toStringAsFixed(2)}%"),
                  pw.Text("Total: ${invoice.total.toStringAsFixed(2)}"),
                  pw.Text("Balance Due: ${invoice.total.toStringAsFixed(2)}"),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    return pdf;
  }
}
