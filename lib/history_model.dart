//history_model.dart file
class HistoryItem {
  final int? id; // Useful for database operations
  final String expression;
  final String result;
  final String timestamp;

  HistoryItem(
      {this.id,
      required this.expression,
      required this.result,
      required this.timestamp});
  // Convert a HistoryItem into a Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
      'timestamp': timestamp
    };
  }

  // Construct a HistoryItem from a database map
  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
        id: map['id'],
        expression: map['expression'],
        result: map['result'],
        timestamp: map['timestamp']);
  }
}
