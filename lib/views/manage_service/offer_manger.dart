import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/offer.dart';
import '../../services/offer_service.dart';
import '../../utils/app_colors.dart';

class OfferManagementScreen extends StatefulWidget {
  final String placeId;

  const OfferManagementScreen({super.key, required this.placeId});

  @override
  _OfferManagementScreenState createState() => _OfferManagementScreenState();
}

class _OfferManagementScreenState extends State<OfferManagementScreen> {
  final OfferService _offerService = OfferService();
  late Future<List<Offer>> _offersFuture;

  @override
  void initState() {
    super.initState();
    _fetchOffers();
  }

  void _fetchOffers() {
    _offersFuture = _offerService.getOffersByPlace(widget.placeId.toString());
  }

  void _showOfferForm({Offer? offer}) {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController(text: offer?.title ?? '');
    final _descriptionController =
        TextEditingController(text: offer?.description ?? '');
    final _originalPriceController = TextEditingController(
        text: offer != null ? offer.originalPrice.toString() : '');
    final _discountedPriceController = TextEditingController(
        text: offer != null ? offer.discountedPrice.toString() : '');
    final _startDateController = TextEditingController(
        text: offer != null
            ? DateFormat('yyyy-MM-dd').format(offer.startDate)
            : '');
    final _endDateController = TextEditingController(
        text: offer != null
            ? DateFormat('yyyy-MM-dd').format(offer.endDate)
            : '');
    final _isSpecial = offer?.isSpecial ?? false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(offer == null ? 'إضافة عرض جديد' : 'تعديل العرض'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'عنوان العرض',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'يرجى إدخال عنوان العرض' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'وصف العرض',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'يرجى إدخال وصف العرض' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _originalPriceController,
                  decoration: InputDecoration(
                    labelText: 'السعر الأصلي',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'يرجى إدخال السعر الأصلي' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _discountedPriceController,
                  decoration: InputDecoration(
                    labelText: 'السعر بعد الخصم',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'يرجى إدخال السعر بعد الخصم' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _startDateController,
                  decoration: InputDecoration(
                    labelText: 'تاريخ البداية (yyyy-MM-dd)',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: offer?.startDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      _startDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                  validator: (value) =>
                      value!.isEmpty ? 'يرجى إدخال تاريخ البداية' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _endDateController,
                  decoration: InputDecoration(
                    labelText: 'تاريخ الانتهاء (yyyy-MM-dd)',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: offer?.endDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      _endDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                  validator: (value) =>
                      value!.isEmpty ? 'يرجى إدخال تاريخ الانتهاء' : null,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  value: _isSpecial,
                  title: const Text('عرض مميز'),
                  onChanged: (value) {
                    setState(() {
                      offer?.isSpecial = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                print(offer?.id);
                final newOffer = Offer(
                  id: offer?.id ?? '',
                  title: _titleController.text,
                  description: _descriptionController.text,
                  originalPrice: double.parse(_originalPriceController.text),
                  discountedPrice:
                      double.parse(_discountedPriceController.text),
                  startDate:
                      DateFormat('yyyy-MM-dd').parse(_startDateController.text),
                  endDate:
                      DateFormat('yyyy-MM-dd').parse(_endDateController.text),
                  placeId: widget.placeId,
                  isSpecial: _isSpecial,
                );

                if (offer == null) {
                  await _offerService.addOffer(newOffer);
                } else {
                  await _offerService.updateOffer(newOffer);
                }
                Navigator.pop(context);
                setState(() => _fetchOffers());
              }
            },
            child: Text(offer == null ? 'إضافة' : 'تحديث'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة العروض'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: FutureBuilder<List<Offer>>(
        future: _offersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'حدث خطأ أثناء تحميل العروض',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          final offers = snapshot.data!;
          if (offers.isEmpty) {
            return Center(
              child: Text(
                'لا توجد عروض مضافة بعد',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(
                    offer.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(offer.description,
                          style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      Text(
                        'السعر الأصلي: ${offer.originalPrice.toStringAsFixed(2)} - السعر بعد الخصم: ${offer.discountedPrice.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'تاريخ الانتهاء: ${DateFormat('yyyy-MM-dd').format(offer.endDate)}',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        _showOfferForm(offer: offer);
                      } else if (value == 'delete') {
                        _offerService.deleteOffer(offer.id);
                        setState(() => _fetchOffers());
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: const [
                            Icon(Icons.edit, size: 20, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('تعديل'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: const [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('حذف'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showOfferForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
