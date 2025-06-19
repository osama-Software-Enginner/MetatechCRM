import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/CustomAppBar.dart';
import '../../widgets/customDrawer.dart';
import 'bloc/InvoiceBloc.dart';
import 'bloc/InvoiceEvent.dart';
import 'bloc/InvoiceState.dart';
import 'invoice_detail_screen.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_text_styles.dart';
import '../../design_system/dimensions.dart';

class InvoiceListScreen extends StatelessWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InvoiceBloc()..add(LoadInvoices()),
      child: Scaffold(
        appBar: CustomAppBar(),
        drawer: CustomDrawer(),
        body: BlocBuilder<InvoiceBloc, InvoiceState>(
          builder: (context, state) {
            if (state is InvoiceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is InvoiceListLoaded) {
              final invoices = state.invoices;

              return Padding(
                padding: EdgeInsets.all(AppDimensions.padding(context)),
                child: Column(
                  children: [
                    // Header Row
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: AppDimensions.paddingSmall(context),
                        horizontal: AppDimensions.padding(context),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.brand.shade50,
                        borderRadius: BorderRadius.circular(AppDimensions.cardRadius(context)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('ID', style: Theme.of(context).textTheme.titleSmall),
                          ),
                          Expanded(
                            child: Text('Status', style: Theme.of(context).textTheme.titleSmall),
                          ),
                          Expanded(
                            child: Text('Date', style: Theme.of(context).textTheme.titleSmall),
                          ),
                          Expanded(
                            child: Text('Total', style: Theme.of(context).textTheme.titleSmall),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Invoices List
                    Expanded(
                      child: ListView.separated(
                        itemCount: invoices.length,
                        separatorBuilder: (_, __) => Divider(color: AppColors.divider),
                        itemBuilder: (context, index) {
                          final invoice = invoices[index];
                          return InkWell(
                            borderRadius: BorderRadius.circular(AppDimensions.cardRadius(context)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => InvoiceDetailScreen(invoice: invoice),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: AppDimensions.paddingSmall(context),
                                horizontal: AppDimensions.padding(context),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(AppDimensions.cardRadius(context)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(invoice.id,
                                        style: Theme.of(context).textTheme.bodyMedium),
                                  ),
                                  Expanded(
                                    child: Text(invoice.status,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: AppColors.textSecondary)),
                                  ),
                                  Expanded(
                                    child: Text(invoice.date,
                                        style: Theme.of(context).textTheme.bodyMedium),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '\$${invoice.total.toStringAsFixed(2)}',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  ],
                ),
              );
            } else {
              return const Center(child: Text("No invoices available."));
            }
          },
        ),
      ),
    );
  }
}
