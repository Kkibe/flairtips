import 'package:cloud_firestore/cloud_firestore.dart';

class Tip {
  final String id;
  final String home;
  final String away;
  final String date;
  final String time;
  final String odd;
  final String pick;
  final String type;
  final String results;
  final String status;
  final String won;
  final bool premium;

  Tip({
    required this.id,
    required this.home,
    required this.away,
    required this.date,
    required this.time,
    required this.odd,
    required this.pick,
    required this.type,
    required this.results,
    required this.status,
    required this.won,
    required this.premium,
  });

  factory Tip.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Tip(
      id: doc.id,
      home: data['home'],
      away: data['away'],
      date: data['date'],
      time: data['time'],
      odd: data['odd'],
      pick: data['pick'],
      type: data['type'],
      results: data['results'],
      status: data['status'],
      won: data['won'],
      premium: data.containsKey('premium') ? (data['premium'] ?? false) : false,
    );
  }

  /// Optional: Convert string odd to double for math
  double get oddValue {
    return double.tryParse(odd) ?? 0.0;
  }
}
