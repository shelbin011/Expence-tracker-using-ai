class AppConstants {
  static const Map<String, String> countryCurrencies = {
    'United States': '\$',
    'United Kingdom': '£',
    'Europe': '€',
    'India': '₹',
    'Japan': '¥',
    'Canada': 'C\$',
    'Australia': 'A\$',
    'Brazil': 'R\$',
    'Russia': '₽',
  };

  static const Map<String, IconData> categoryIcons = {
    'Food': Icons.fastfood,
    'Travel': Icons.flight,
    'Bills': Icons.receipt_long,
    'Shopping': Icons.shopping_bag,
    'Salary': Icons.attach_money,
    'Investment': Icons.trending_up,
    'Health': Icons.medical_services,
    'Entertainment': Icons.movie,
    'Other': Icons.category,
  };

  static const Map<String, Color> categoryColors = {
    'Food': Colors.orange,
    'Travel': Colors.blue,
    'Bills': Colors.red,
    'Shopping': Colors.purple,
    'Salary': Colors.green,
    'Investment': Colors.teal,
    'Health': Colors.pink,
    'Entertainment': Colors.indigo,
    'Other': Colors.grey,
  };
}
