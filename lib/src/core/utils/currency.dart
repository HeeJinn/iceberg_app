import 'package:intl/intl.dart';

final NumberFormat _pesoCurrencyFormatter = NumberFormat.currency(
  locale: 'en_PH',
  symbol: '\u20B1',
  decimalDigits: 2,
);

String formatCurrency(num amount, {int decimalDigits = 2}) {
  if (decimalDigits == 2) {
    return _pesoCurrencyFormatter.format(amount);
  }

  return NumberFormat.currency(
    locale: 'en_PH',
    symbol: '\u20B1',
    decimalDigits: decimalDigits,
  ).format(amount);
}

String formatCompactCurrency(num amount) {
  final absoluteAmount = amount.abs();
  final sign = amount < 0 ? '-' : '';

  if (absoluteAmount >= 1000) {
    final scaled = absoluteAmount / 1000;
    final suffixValue = scaled >= 10 || scaled == scaled.roundToDouble()
        ? scaled.toStringAsFixed(0)
        : scaled.toStringAsFixed(1);
    return '${sign}\u20B1${suffixValue}k';
  }

  return '${sign}${formatCurrency(absoluteAmount, decimalDigits: 0)}';
}
