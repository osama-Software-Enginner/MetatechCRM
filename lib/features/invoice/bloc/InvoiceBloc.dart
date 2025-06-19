// 📁 bloc/invoice_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/invoice.dart';
import 'InvoiceEvent.dart';
import 'InvoiceState.dart';


class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc() : super(InvoiceInitial()) {
    on<LoadInvoices>((event, emit) {
      emit(InvoiceLoading());

      final invoices = [
        Invoice(
          id: 'INV842002',
          status: 'Draft',
          date: '27th Jul 2021',
          taxRate: 5,
          customerName: 'Kim Girocking',
          customerAddress: '123 Main St, NY',
          items: [
            InvoiceItem(title: 'SEO', description: 'Instagram marketing', qty: 1, unit: 'Job', rate: 100.0),
            InvoiceItem(title: 'Social Media Content', description: 'Instagram marketing', qty: 1, unit: 'Job', rate: 100.0),
          ],
        ),
        Invoice(
          id: 'INV842004',
          status: 'Paid',
          date: '25th Jul 2021',
          taxRate: 5,
          customerName: 'Jackson Balabala',
          customerAddress: '456 Second Ave, LA',
          items: [
            InvoiceItem(title: 'SEO Audit', description: 'Instagram marketing', qty: 1, unit: 'Job', rate: 100.0),

            InvoiceItem(title: 'Brand Audit', description: 'Audit + Analysis', qty: 2, unit: 'Job', rate: 100.0),
          ],
        ),
      ];

      emit(InvoiceListLoaded(invoices));
    });
  }
}
