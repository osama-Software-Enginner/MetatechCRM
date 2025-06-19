// 📁 model/invoice.dart
class InvoiceItem {
  final String title;
  final String description;
  final int qty;
  final String unit;
  final double rate;
  final double amount;

  InvoiceItem({
    required this.title,
    required this.description,
    required this.qty,
    required this.unit,
    required this.rate,
  }) : amount = qty * rate;
}

class Invoice {
  final String id;
  final String status;
  final String date;
  final double taxRate;
  final String customerName;
  final String customerAddress;
  final List<InvoiceItem> items;

  Invoice({
    required this.id,
    required this.status,
    required this.date,
    required this.taxRate,
    required this.customerName,
    required this.customerAddress,
    required this.items,
  });

  double get subTotal => items.fold(0, (sum, item) => sum + item.amount);
  double get tax => subTotal * (taxRate / 100);
  double get total => subTotal + tax;
}