import 'package:flutter/material.dart';
import '../../data/models/transaction_model.dart';
import 'transaction_tile.dart';

class TransactionSearchDelegate extends SearchDelegate {
  final List<TransactionModel> transactions;
  final Function(int) onDelete;

  TransactionSearchDelegate({required this.transactions, required this.onDelete});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = transactions.where((t) {
      return t.title.toLowerCase().contains(query.toLowerCase()) ||
             t.category.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final transaction = results[index];
        return TransactionTile(
          transaction: transaction,
          onDelete: () {
             onDelete(transaction.id!);
             // We might need to refresh search results, but simplicity for now
             close(context, null); 
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = transactions.where((t) {
       return t.title.toLowerCase().contains(query.toLowerCase()) ||
             t.category.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final transaction = suggestions[index];
        return ListTile(
          title: Text(transaction.title),
          subtitle: Text(transaction.category),
          trailing: Text(transaction.amount.toStringAsFixed(2)),
          onTap: () {
            // Optional: navigate to detail or fill query
            query = transaction.title;
            showResults(context);
          },
        );
      },
    );
  }
}
