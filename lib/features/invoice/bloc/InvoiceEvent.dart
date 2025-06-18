
// Invoice Model
class Invoice {
  final String id;
  final String clientName;
  final double amount;
  final DateTime date;
  final String description;

  Invoice({
    required this.id,
    required this.clientName,
    required this.amount,
    required this.date,
    required this.description,
  });
}

// BLoC Events
abstract class InvoiceEvent {}

class LoadInvoices extends InvoiceEvent {}
class AddInvoice extends InvoiceEvent {
  final Invoice invoice;
  AddInvoice(this.invoice);
}
class DeleteInvoice extends InvoiceEvent {
  final String invoiceId;
  DeleteInvoice(this.invoiceId);
}