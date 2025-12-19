import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../../data/models/transaction_model.dart';

class CsvExportService {
  static Future<void> exportTransactions(List<TransactionModel> transactions) async {
    List<List<dynamic>> rows = [];
    
    // Add header
    rows.add([
      "ID",
      "Title",
      "Amount",
      "Type",
      "Category",
      "Date",
      "Note"
    ]);

    // Add data
    for (var transaction in transactions) {
      rows.add([
        transaction.id,
        transaction.title,
        transaction.amount,
        transaction.type,
        transaction.category,
        DateFormat('yyyy-MM-dd').format(transaction.date),
        transaction.note ?? ""
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);

    final directory = await getTemporaryDirectory();
    final path = "${directory.path}/transactions_export.csv";
    final file = File(path);
    
    await file.writeAsString(csvData);

    await Share.shareXFiles([XFile(path)], text: 'Here is my transaction history.');
  }
}
