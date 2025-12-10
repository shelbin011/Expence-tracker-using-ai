class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final String type; // 'income' or 'expense'
  final String category;
  final String? note;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type,
      'category': category,
      'note': note,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      type: map['type'],
      category: map['category'],
      note: map['note'],
    );
  }
}
