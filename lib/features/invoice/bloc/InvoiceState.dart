// 📁 bloc/invoice_state.dart
import '../model/invoice.dart';

abstract class InvoiceState {}

class InvoiceInitial extends InvoiceState {}

class InvoiceLoading extends InvoiceState {}

class InvoiceListLoaded extends InvoiceState {
  final List<Invoice> invoices;
  InvoiceListLoaded(this.invoices);
}

class InvoiceError extends InvoiceState {
  final String message;
  InvoiceError(this.message);
}