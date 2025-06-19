import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/dimensions.dart';
import '../../utils/invoice_pdf_generator.dart';
import 'model/invoice.dart';

class InvoiceDetailScreen extends StatelessWidget {
  final Invoice invoice;

  const InvoiceDetailScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final spacing = AppDimensions.spacing(context);
    final padding = AppDimensions.padding(context);
    final radius = AppDimensions.cardRadius(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice ${invoice.id}"),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              final pdf = await InvoicePdfGenerator.generate(invoice);
              await Printing.sharePdf(bytes: await pdf.save(), filename: 'Invoice_${invoice.id}.pdf');
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Metatech", style: Theme.of(context).textTheme.displaySmall),
            SizedBox(height: spacing),

            // Address & Invoice ID Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    "Office 503, Nassima Tower, Sheikh Zayed Road, Dubai, UAE",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textPrimary),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Invoice", style: Theme.of(context).textTheme.displayMedium),
                      Text('#${invoice.id}', style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing),

            // Billing Details Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bill To', style: Theme.of(context).textTheme.labelMedium),
                      Text('Ali Husnain', style: Theme.of(context).textTheme.labelMedium),
                      Text('Office 503, Nassima Tower, Sheikh Zayed Road, Dubai, UAE',
                          style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Invoice Date:', style: Theme.of(context).textTheme.labelMedium),
                          SizedBox(width: spacing),
                          Text(invoice.date, style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      SizedBox(height: spacing / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Terms:', style: Theme.of(context).textTheme.labelMedium),
                          SizedBox(width: spacing),
                          Text("Due on Receipt", style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing * 2),

            // Header Row
            Container(
              padding: EdgeInsets.symmetric(vertical: spacing, horizontal: padding),
              decoration: BoxDecoration(
                color: AppColors.brand.shade50,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Row(
                children: const [
                  Expanded(child: Text('#')),
                  Expanded(child: Text('Item & Description')),
                  Expanded(child: Text('Qty')),
                  Expanded(child: Text('Rate')),
                  Expanded(child: Text('Amount')),
                ],
              ),
            ),
            SizedBox(height: spacing),

            // Invoice Items
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: invoice.items.length,
              separatorBuilder: (_, __) => Divider(color: AppColors.divider),
              itemBuilder: (context, index) {
                final item = invoice.items[index];
                return Container(
                  padding: EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingSmall(context),
                    horizontal: AppDimensions.padding(context),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text('${index + 1}')),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, style: Theme.of(context).textTheme.bodyMedium),
                            Text(item.description, style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      Expanded(child: Text(item.qty.toString())),
                      Expanded(
                        child: Text(
                          item.rate.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.amount.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: spacing * 2),

            // Totals Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildTotalRow(context, 'Sub Total:', invoice.subTotal),
                _buildTotalRow(context, 'Tax Rate:', invoice.taxRate),
                _buildTotalRow(context, 'Total:', invoice.total),
                _buildTotalRow(context, 'Balance Due:', invoice.total),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.print),
        onPressed: () async {
          final pdf = await InvoicePdfGenerator.generate(invoice);
          await Printing.layoutPdf(onLayout: (format) => pdf.save());
        },
      ),
    );
  }

  Widget _buildTotalRow(BuildContext context, String label, double value) {
    return Padding(
      padding: EdgeInsets.only(top: AppDimensions.spacingSmall(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textPrimary)),
          SizedBox(width: AppDimensions.spacing(context)),
          Text(
            value.toStringAsFixed(2),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
