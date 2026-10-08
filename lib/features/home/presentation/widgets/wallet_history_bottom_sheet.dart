import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mahder_mobile/core/theme/app_colors.dart';
import 'package:mahder_mobile/features/home/data/models/wallet_transaction.dart';
import 'package:mahder_mobile/features/home/presentation/controllers/home_controller.dart';

class WalletHistoryBottomSheet extends StatelessWidget {
  const WalletHistoryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 12, 12),
            child: Row(
              children: [
                const Icon(Icons.history, color: AppColors.primary),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Wallet history',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Obx(() {
              if (controller.isWalletHistoryLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.walletTransactions.isEmpty) {
                return const Center(child: Text('No wallet history yet'));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.walletTransactions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, index) => _TransactionTile(
                  transaction: controller.walletTransactions[index],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final WalletTransaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == 'Credit';
    final color = isCredit ? AppColors.green : AppColors.red;
    final sign = transaction.amount >= 0 ? '+' : '';
    final date = transaction.createdDate == null
        ? ''
        : DateFormat.yMMMd()
            .add_jm()
            .format(transaction.createdDate!.toLocal());

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: AppColors.gray,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(isCredit ? Icons.add : Icons.remove, color: color),
      ),
      title: Text(transaction.type),
      subtitle: Text('${transaction.status}${date.isEmpty ? '' : ' • $date'}'),
      trailing: Text(
        '$sign${transaction.amount.toStringAsFixed(2)} ETB',
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
