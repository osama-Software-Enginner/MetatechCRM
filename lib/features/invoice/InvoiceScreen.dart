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
        body: Row(
          children: [
            const CustomDrawer(selectedRoute: '/invoices'),
            Expanded(
              child: BlocBuilder<InvoiceBloc, InvoiceState>(
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
                            child: ListView.builder(
                              itemCount: invoices.length,
                              itemBuilder: (context, index) {
                                final invoice = invoices[index];

                                return TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0, end: 1),
                                  duration: Duration(milliseconds: 400 + index * 100),
                                  curve: Curves.easeOut,
                                  builder: (context, value, child) {
                                    return Opacity(
                                      opacity: value,
                                      child: Transform.translate(
                                        offset: Offset(0, (1 - value) * 20),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                                    child: InkWell(
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
                                              child: Text(invoice.id, style: Theme.of(context).textTheme.bodyMedium),
                                            ),
                                            Expanded(
                                              child: Text(
                                                invoice.status,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(color: AppColors.textSecondary),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(invoice.date, style: Theme.of(context).textTheme.bodyMedium),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '\$${invoice.total.toStringAsFixed(2)}',
                                                textAlign: TextAlign.right,
                                                style: Theme.of(context).textTheme.bodyMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
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
          ],
        ),
      ),
    );
  }
}
