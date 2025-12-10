import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';
import '../models/goal_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('finance_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';
    const boolType = 'INTEGER NOT NULL';
    const nullableTextType = 'TEXT';

    await db.execute('''
CREATE TABLE transactions (
  id $idType,
  title $textType,
  amount $doubleType,
  date $textType,
  type $textType,
  category $textType,
  note $nullableTextType
)
''');

    await db.execute('''
CREATE TABLE goals (
  id $idType,
  title $textType,
  targetAmount $doubleType,
  savedAmount $doubleType,
  deadline $textType,
  isCompleted $boolType
)
''');
  }

  // Transaction CRUD
  Future<int> createTransaction(TransactionModel transaction) async {
    final db = await instance.database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<TransactionModel> readTransaction(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'transactions',
      columns: ['id', 'title', 'amount', 'date', 'type', 'category', 'note'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TransactionModel.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<TransactionModel>> readAllTransactions() async {
    final db = await instance.database;
    final orderBy = 'date DESC';
    final result = await db.query('transactions', orderBy: orderBy);

    return result.map((json) => TransactionModel.fromMap(json)).toList();
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await instance.database;
    return db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await instance.database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Goal CRUD
  Future<int> createGoal(GoalModel goal) async {
    final db = await instance.database;
    return await db.insert('goals', goal.toMap());
  }

  Future<List<GoalModel>> readAllGoals() async {
    final db = await instance.database;
    final result = await db.query('goals');
    return result.map((json) => GoalModel.fromMap(json)).toList();
  }

  Future<int> updateGoal(GoalModel goal) async {
    final db = await instance.database;
    return db.update(
      'goals',
      goal.toMap(),
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }

  Future<int> deleteGoal(int id) async {
    final db = await instance.database;
    return await db.delete(
      'goals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
