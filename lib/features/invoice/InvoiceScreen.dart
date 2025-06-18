import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_text_styles.dart';
import '../../design_system/dimensions.dart';
import '../../widgets/CustomAppBar.dart';
import '../../widgets/customDrawer.dart';
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

// BLoC States
abstract class InvoiceState {}

class InvoiceLoading extends InvoiceState {}
class InvoiceLoaded extends InvoiceState {
  final List<Invoice> invoices;
  InvoiceLoaded(this.invoices);
}
class InvoiceError extends InvoiceState {
  final String message;
  InvoiceError(this.message);
}

// Invoice BLoC
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

// Invoice Feature Wrapper Widget
class InvoiceFeature extends StatelessWidget {
  const InvoiceFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoiceBloc>(
      create: (context) => InvoiceBloc()..add(LoadInvoices()),
      child: Navigator(
        onGenerateRoute: (settings) {
          if (settings.name == '/add') {
            return MaterialPageRoute(builder: (context) => AddInvoiceScreen());
          } else if (settings.name == '/detail') {
            final invoice = settings.arguments as Invoice;
            return MaterialPageRoute(
              builder: (context) => InvoiceDetailScreen(invoice: invoice),
            );
          }
          return MaterialPageRoute(builder: (context) => InvoiceListScreen());
        },
      ),
    );
  }
}

// Invoice List Screen
class InvoiceListScreen extends StatelessWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if InvoiceBloc is available
    final invoiceBloc = context.read<InvoiceBloc?>();
    if (invoiceBloc == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            'Error: InvoiceBloc not found. Use InvoiceFeature.',
            style: AppTextStyles.textTheme(context).bodyLarge?.copyWith(
              color: AppColors.error,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: BlocBuilder<InvoiceBloc, InvoiceState>(
        builder: (context, state) {
          if (state is InvoiceLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.black));
          } else if (state is InvoiceLoaded) {
            return state.invoices.isEmpty
                ? Center(
              child: Text(
                'No Invoices Yet',
                style: AppTextStyles.textTheme(context).bodyLarge?.copyWith(
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.all(AppDimensions.padding(context)),
              itemCount: state.invoices.length,
              itemBuilder: (context, index) {
                final invoice = state.invoices[index];
                return InvoiceCard(invoice: invoice);
              },
            );
          } else if (state is InvoiceError) {
            return Center(
              child: Text(
                state.message,
                style: AppTextStyles.textTheme(context).bodyLarge?.copyWith(
                  color: AppColors.error,
                ),
              ),
            );
          }
          return Container();
        },
      ),
      floatingActionButton: IconButton(
        icon: Icon(
          Icons.add_circle_outline,
          color: Colors.black,
          size: AppDimensions.iconSize(context),
        ),
        onPressed: () => Navigator.pushNamed(context, '/addInvoice'),
      ),
    );
  }
}

// Invoice Card Widget
class InvoiceCard extends StatelessWidget {
  final Invoice invoice;

  const InvoiceCard({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDimensions.elevationMedium(context),
      color: Colors.white,
      margin: EdgeInsets.symmetric(
        vertical: AppDimensions.marginSmall(context),
        horizontal: AppDimensions.margin(context),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius(context)),
        side: const BorderSide(color: Colors.black12, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius(context)),
        onTap: () => Navigator.pushNamed(context, '/detail', arguments: invoice),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.padding(context)),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppDimensions.paddingSmall(context)),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(AppDimensions.buttonRadius(context)),
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: Colors.black,
                  size: AppDimensions.iconSizeSmall(context),
                ),
              ),
              SizedBox(width: AppDimensions.spacing(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice.clientName,
                      style: AppTextStyles.textTheme(context).titleMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppDimensions.spacingSmall(context)),
                    Text(
                      '\$${invoice.amount.toStringAsFixed(2)}',
                      style: AppTextStyles.textTheme(context).bodyMedium?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      invoice.date.toString().split(' ')[0],
                      style: AppTextStyles.textTheme(context).bodySmall?.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                  size: AppDimensions.iconSizeSmall(context),
                ),
                onPressed: () => context.read<InvoiceBloc>().add(DeleteInvoice(invoice.id)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Add Invoice Screen
class AddInvoiceScreen extends StatefulWidget {
  const AddInvoiceScreen({super.key});

  @override
  _AddInvoiceScreenState createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _clientNameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if InvoiceBloc is available
    final invoiceBloc = context.read<InvoiceBloc?>();
    if (invoiceBloc == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            'Error: InvoiceBloc not found. Use InvoiceFeature.',
            style: AppTextStyles.textTheme(context).bodyLarge?.copyWith(
              color: AppColors.error,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: AppDimensions.elevationLow(context),
        title: Text(
          'Create Invoice',
          style: AppTextStyles.textTheme(context).titleLarge?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.paddingLarge(context)),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Invoice Details',
                style: AppTextStyles.textTheme(context).titleMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppDimensions.spacing(context)),
              TextFormField(
                controller: _clientNameController,
                decoration: InputDecoration(
                  labelText: 'Client Name',
                  labelStyle: AppTextStyles.textTheme(context).labelLarge?.copyWith(
                    color: Colors.black54,
                  ),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.buttonRadius(context)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.buttonRadius(context)),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                validator: (value) => value!.isEmpty ? 'Please enter client name' : null,
              ),
              SizedBox(height: AppDimensions.spacing(context)),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: AppTextStyles.textTheme(context).labelLarge?.copyWith(
                    color: Colors.black54,
                  ),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.buttonRadius(context)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.buttonRadius(context)),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  prefixText: '\$ ',
                ),
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter amount';
                  if (double.tryParse(value) == null) return 'Please enter a valid number';
                  return null;
                },
              ),
              SizedBox(height: AppDimensions.spacing(context)),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: AppTextStyles.textTheme(context).labelLarge?.copyWith(
                    color: Colors.black54,
                  ),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.buttonRadius(context)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.buttonRadius(context)),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                maxLines: 4,
                validator: (value) => value!.isEmpty ? 'Please enter description' : null,
              ),
              SizedBox(height: AppDimensions.spacingLarge(context)),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final invoice = Invoice(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      clientName: _clientNameController.text,
                      amount: double.parse(_amountController.text),
                      date: DateTime.now(),
                      description: _descriptionController.text,
                    );
                    context.read<InvoiceBloc>().add(AddInvoice(invoice));
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingLarge(context),
                    vertical: AppDimensions.padding(context),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.buttonRadius(context)),
                  ),
                  elevation: AppDimensions.elevationLow(context),
                ),
                child: Text(
                  'Create Invoice',
                  style: AppTextStyles.textTheme(context).titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Invoice Detail Screen
class InvoiceDetailScreen extends StatelessWidget {
  final Invoice invoice;

  const InvoiceDetailScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    // Check if InvoiceBloc is available
    final invoiceBloc = context.read<InvoiceBloc?>();
    if (invoiceBloc == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            'Error: InvoiceBloc not found. Use InvoiceFeature.',
            style: AppTextStyles.textTheme(context).bodyLarge?.copyWith(
              color: AppColors.error,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: AppDimensions.elevationLow(context),
        title: Text(
          'Invoice #${invoice.id.substring(0, 8)}',
          style: AppTextStyles.textTheme(context).titleLarge?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.paddingLarge(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(AppDimensions.padding(context)),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppDimensions.cardRadius(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Client',
                    style: AppTextStyles.textTheme(context).labelLarge?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    invoice.clientName,
                    style: AppTextStyles.textTheme(context).titleLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacing(context)),
                  Text(
                    'Amount',
                    style: AppTextStyles.textTheme(context).labelLarge?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    '\$${invoice.amount.toStringAsFixed(2)}',
                    style: AppTextStyles.textTheme(context).titleLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacing(context)),
                  Text(
                    'Date',
                    style: AppTextStyles.textTheme(context).labelLarge?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    invoice.date.toString().split(' ')[0],
                    style: AppTextStyles.textTheme(context).bodyLarge?.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimensions.spacingLarge(context)),
            Text(
              'Description',
              style: AppTextStyles.textTheme(context).titleMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppDimensions.spacingSmall(context)),
            Container(
              padding: EdgeInsets.all(AppDimensions.padding(context)),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppDimensions.cardRadius(context)),
              ),
              child: Text(
                invoice.description,
                style: AppTextStyles.textTheme(context).bodyMedium?.copyWith(
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: AppDimensions.spacingLarge(context)),
            const Divider(color: Colors.black12),
            SizedBox(height: AppDimensions.spacing(context)),
            ElevatedButton(
              onPressed: () {
                context.read<InvoiceBloc>().add(DeleteInvoice(invoice.id));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge(context),
                  vertical: AppDimensions.padding(context),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.buttonRadius(context)),
                ),
                elevation: AppDimensions.elevationLow(context),
              ),
              child: Text(
                'Delete Invoice',
                style: AppTextStyles.textTheme(context).titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}