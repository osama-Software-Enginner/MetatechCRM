// Invoice BLoC
import 'package:flutter_bloc/flutter_bloc.dart';

import 'InvoiceEvent.dart';
import 'InvoiceState.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc() : super(InvoiceLoading()) {
    on<LoadInvoices>(_onLoadInvoices);
    on<AddInvoice>(_onAddInvoice);
    on<DeleteInvoice>(_onDeleteInvoice);
  }

  final List<Invoice> _invoices = [];

  void _onLoadInvoices(LoadInvoices event, Emitter<InvoiceState> emit) {
    emit(InvoiceLoaded(_invoices));
  }

  void _onAddInvoice(AddInvoice event, Emitter<InvoiceState> emit) {
    _invoices.add(event.invoice);
    emit(InvoiceLoaded(_invoices));
  }

  void _onDeleteInvoice(DeleteInvoice event, Emitter<InvoiceState> emit) {
    _invoices.removeWhere((invoice) => invoice.id == event.invoiceId);
    emit(InvoiceLoaded(_invoices));
  }
}