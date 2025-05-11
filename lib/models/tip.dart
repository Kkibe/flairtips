class Tip {
  final String id;
  final String home;
  final String away;
  final String? homeImage; // can be null
  final String? awayImage; // can be null
  final String date; // "Tue, 29th Apr 2025"
  final String fixtureDate; //"17:00PM, 29-04-2025"
  final String time; //"17:00"
  final String homeOdd;
  final String drawOdd;
  final String awayOdd;
  final String tip;
  final String bestTip; // can be empty string
  final String homeScore; // can be empty string
  final String awayScore; // can be empty string
  final String confidence;
  final bool isPlayed; // 0 or 1
  final String playing; // Finished / Upcoming
  final bool premium; // 0 or 1
  final bool isScoreUpdated; // 0 or 1

  final String country;
  final String countryId;
  final String leagueLogo; // can be empty string
  final String leagueName;

  Tip({
    required this.id,
    required this.home,
    required this.away,
    this.homeImage,
    this.awayImage,
    required this.date,
    required this.fixtureDate,
    required this.time,
    required this.homeOdd,
    required this.drawOdd,
    required this.awayOdd,
    required this.tip,
    required this.bestTip,
    required this.homeScore,
    required this.awayScore,
    required this.confidence,
    required this.isPlayed,
    required this.premium,
    required this.isScoreUpdated,
    required this.playing,
    required this.country,
    required this.countryId,
    required this.leagueLogo,
    required this.leagueName,
  });

  factory Tip.fromJson(Map<String, dynamic> json, {bool premium = false}) {
    return Tip(
      id: json['id'].toString(),
      home: json['home'] ?? '',
      away: json['away'] ?? '',
      homeImage: json['homeImage'],
      awayImage: json['awayImage'],
      date: json['date'] ?? '',
      fixtureDate: json['fixtureDate'] ?? '',
      time: json['time'] ?? '',
      homeOdd: json['homeOdd'] ?? '',
      drawOdd: json['drawOdd'] ?? '',
      awayOdd: json['awayOdd'] ?? '',
      tip: json['tip'] ?? '',
      bestTip: json['bestTip'] ?? '-',
      homeScore: json['homeScore'] ?? '',
      awayScore: json['awayScore'] ?? '',
      confidence: json['confidence'] ?? '',
      isPlayed: (json['isPlayed'] ?? 0) == 1,
      premium: premium,
      isScoreUpdated: (json['isScoreUpdated'] ?? 0) == 1,
      playing: json['playing'] ?? '',
      country: json['country'] ?? '',
      countryId: json['countryId'] ?? '',
      leagueLogo: json['leagueLogo'] ?? '',
      leagueName: json['leagueName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'home': home,
      'away': away,
      'homeImage': homeImage,
      'awayImage': awayImage,
      'date': date,
      'fixtureDate': fixtureDate,
      'time': time,
      'homeOdd': homeOdd,
      'drawOdd': drawOdd,
      'awayOdd': awayOdd,
      'tip': tip,
      'bestTip': bestTip,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'confidence': confidence,
      'isPlayed': isPlayed ? 1 : 0,
      'premium': premium ? 1 : 0,
      'isScoreUpdated': isScoreUpdated ? 1 : 0,
      'playing': playing,
      'country': country,
      'countryId': countryId,
      'leagueLogo': leagueLogo,
      'leagueName': leagueName,
    };
  }
}
