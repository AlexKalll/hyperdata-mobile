import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mahder_mobile/core/theme/app_colors.dart';
import 'package:mahder_mobile/core/widgets/button.dart';
import 'package:mahder_mobile/features/home/presentation/controllers/home_controller.dart';

class WithdrawDialog extends StatefulWidget {
  const WithdrawDialog({super.key});

  @override
  State<WithdrawDialog> createState() => _WithdrawDialogState();
}

class _WithdrawDialogState extends State<WithdrawDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();
  String _paymentMethod = 'Telebirr';

  HomeController get _controller => Get.find<HomeController>();

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _controller.withdrawMoney(
      amount: double.parse(_amountController.text.trim()),
      phoneNumber: _phoneController.text.trim(),
      paymentMethod: _paymentMethod,
    );
    if (success && mounted) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AlertDialog(
        title: const Text('Withdraw funds'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _paymentMethod,
                  decoration:
                      const InputDecoration(labelText: 'Payment method'),
                  items: const [
                    DropdownMenuItem(
                        value: 'Telebirr', child: Text('Telebirr')),
                    DropdownMenuItem(
                        value: 'CBE Birr', child: Text('CBE Birr')),
                  ],
                  onChanged: _controller.isWithdrawing.value
                      ? null
                      : (value) => setState(() => _paymentMethod = value!),
                ),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone number'),
                  enabled: !_controller.isWithdrawing.value,
                  validator: (value) => value?.trim().isEmpty == true
                      ? 'Enter a phone number'
                      : null,
                ),
                TextFormField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Amount'),
                  enabled: !_controller.isWithdrawing.value,
                  validator: (value) {
                    final amount = double.tryParse(value?.trim() ?? '');
                    if (amount == null || amount <= 0) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed:
                _controller.isWithdrawing.value ? null : () => Get.back(),
            child: const Text('Cancel'),
          ),
          SizedBox(
            width: 135,
            child: ButtonWidget(
              text: 'Withdraw',
              onPressed: _controller.isWithdrawing.value ? null : _submit,
              isLoading: _controller.isWithdrawing.value,
              loadingText: 'Submitting',
              height: 42,
              fontSize: 14,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
