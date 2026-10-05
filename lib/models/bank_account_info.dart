import 'package:flutter/material.dart';

class BankAccount {
  const BankAccount({
    required this.id,
    required this.bankName,
    required this.shortLabel,
    required this.ifsc,
    required this.holderName,
    required this.accountNumber,
    required this.upiId,
    required this.accent,
    required this.mark,
  });

  final String id;
  final String bankName;
  final String shortLabel;
  final String ifsc;
  final String holderName;
  final String accountNumber;
  final String upiId;
  final Color accent;
  final String mark;

  String get maskedLast4Display {
    final digits = accountNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 4) return 'XXXX XXXX $digits';
    return 'XXXX XXXX ${digits.substring(digits.length - 4)}';
  }

  String get maskedMid {
    final digits = accountNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 6) return digits;
    return '${digits.substring(0, 5)}xxx${digits.substring(digits.length - 2)}';
  }
}

class BankAccountStore extends ChangeNotifier {
  BankAccountStore._() {
    accounts = List<BankAccount>.from(dummyBankAccounts);
    selectedId = accounts.isEmpty ? null : accounts.first.id;
  }

  static final BankAccountStore instance = BankAccountStore._();

  List<BankAccount> accounts = [];
  String? selectedId;

  BankAccount? get selected {
    for (final account in accounts) {
      if (account.id == selectedId) return account;
    }
    return accounts.isEmpty ? null : accounts.first;
  }

  void select(String id) {
    selectedId = id;
    notifyListeners();
  }

  void add(BankAccount account) {
    accounts = [...accounts, account];
    selectedId = account.id;
    notifyListeners();
  }
}

const dummyBankAccounts = [
  BankAccount(
    id: 'sbi-1',
    bankName: 'SBI Bank',
    shortLabel: 'SBI',
    ifsc: 'SBIN0001123',
    holderName: 'Mayank Reddy',
    accountNumber: '1234400012',
    upiId: 'mayank@oksbi',
    accent: Color(0xFF2F6BFF),
    mark: 'S',
  ),
  BankAccount(
    id: 'bob-1',
    bankName: 'BOB Bank',
    shortLabel: 'BOB',
    ifsc: 'BARB0HYD123',
    holderName: 'Mayank Reddy',
    accountNumber: '1234400050',
    upiId: 'mayank@okaxis',
    accent: Color(0xFFFF8A1E),
    mark: 'B',
  ),
];
