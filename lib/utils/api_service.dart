import 'dart:convert';
import 'package:flairtips/models/tip.dart';
import 'package:flairtips/models/user.dart';
import 'package:flairtips/utils/user_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final storage = FlutterSecureStorage();
const String baseUrl = 'https://api.flairtips.com/api/v1';

Future<void> saveLoginData(Map<String, dynamic> json) async {
  final data = json['data'];
  final user = data['user'];
  final accessToken = data['access_token'];
  final refreshToken = json['token_string'];
  final subscriptionActive = json['subscription_active'];

  if (user == null || accessToken == null || refreshToken == null) {
    throw Exception('Invalid login response: Missing required fields');
  }

  // Merge subscription_active into user map
  final mergedUser = {...user, 'subscription_active': subscriptionActive};

  await storage.write(key: 'access_token', value: accessToken);
  await storage.write(key: 'refresh_token', value: refreshToken);
  await storage.write(key: 'user', value: jsonEncode(mergedUser));
}

Future<void> loginUser(String email, String password) async {
  final requestBody = {
    "request": {
      "request_id": DateTime.now().millisecondsSinceEpoch,
      "data": {"identity": email, "password": password},
    },
  };

  final response = await http.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(requestBody),
  );

  final responseData = jsonDecode(response.body);
  if (response.statusCode == 200 && responseData['status'] == 1) {
    await saveLoginData(responseData);
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Login failed');
  }
}

Future<Map<String, dynamic>> registerUser({
  required String fullName,
  required String email,
  required String password,
}) async {
  final url = Uri.parse('$baseUrl/auth/register');

  final requestBody = {
    "request": {
      "request_id": DateTime.now().millisecondsSinceEpoch,
      "data": {"full_name": fullName, "email": email, "password": password},
    },
  };

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(requestBody),
  );

  final responseData = jsonDecode(response.body);

  if (response.statusCode == 200 && responseData['status'] == 1) {
    return responseData;
  } else {
    throw Exception(responseData['message'] ?? 'Registration failed');
  }
}

Future<User?> getSavedUser() async {
  final userJson = await storage.read(key: 'user');
  if (userJson != null) {
    final decoded = jsonDecode(userJson);
    return User.fromJson(decoded);
  }
  return null;
}

Future<void> logoutUser() async {
  await storage.deleteAll();
}

Future<bool> isLoggedIn() async {
  final token = await storage.read(key: 'access_token');
  return token != null;
}

Future<List<Tip>> getTips(bool isPremiumScreen, String date) async {
  final requestId = DateTime.now().millisecondsSinceEpoch;

  String? token;
  if (isPremiumScreen) {
    token = await storage.read(key: 'access_token');
    if (token == null) throw Exception('User not logged in');
  }

  final requestBody = jsonEncode({
    "request": {
      "request_id": requestId,
      "data": {"date": date, "type": "all", "page": 1, "country": ""},
    },
  });

  final headers = {
    'Content-Type': 'application/json',
    if (isPremiumScreen && token != null) 'Authorization': 'Bearer $token',
  };

  final response = await http.post(
    Uri.parse(
      isPremiumScreen
          ? '$baseUrl/fixtures/fixture_details'
          : '$baseUrl/fixtures/get_fixtures',
    ),
    headers: headers,
    body: requestBody,
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> body = jsonDecode(response.body);
    if (body['status'] == 1) {
      if (body['data'] == null) {
        return [];
      }
      final Map<String, dynamic> data = body['data'];
      final List<Tip> tips = [];

      for (final countryEntry in data.entries) {
        final country = countryEntry.key;
        final Map<String, dynamic> leagues = countryEntry.value;

        for (final leagueEntry in leagues.entries) {
          final league = leagueEntry.key;
          final List<dynamic> matches = leagueEntry.value;

          for (final match in matches) {
            // Augment each match with league/country info for parsing
            match['leagueName'] = league;
            match['country'] = country;

            tips.add(
              Tip.fromJson({
                'id': match['match_id'],
                'home': match['home_team'],
                'away': match['away_team'],
                'homeImage': match['home_team_logo'],
                'awayImage': match['away_team_logo'],
                'date': match['date'],
                'fixtureDate': match['fixture_date'],
                'time': match['fixture_time'],
                'homeOdd': match['home_team_odd'],
                'drawOdd': match['draw_odd'],
                'awayOdd': match['away_team_odd'],
                'tip': match['tip'],
                'bestTip': match['best_tip'],
                'homeScore': match['home_score'],
                'awayScore': match['away_score'],
                'confidence': match['confidence'],
                'isPlayed': match['is_played'],
                'isScoreUpdated': match['is_score_updated'],
                'playing': match['playing'],
                'country': match['country'],
                'countryId': match['country_id'],
                'leagueLogo': match['league_logo'],
                'leagueName': match['league_name'],
              }, premium: isPremiumScreen),
            );
          }
        }
      }

      return tips;
    } else {
      // If it's a premium screen and the token is invalid, throw
      if (isPremiumScreen) {
        throw UnauthorizedException(body['message'] ?? 'Unauthorized access');
      }
      throw Exception(body['message'] ?? 'Failed to fetch tips');
    }
  } else {
    throw Exception('Failed to fetch tips');
  }
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}

int generatePaymentId() =>
    DateTime.now().millisecondsSinceEpoch.remainder(1000000);

Future<void> initiatePayment({
  required int planId,
  required String phone,
  required int userId,
}) async {
  final token = await storage.read(key: 'access_token');
  if (token == null) throw Exception('User not logged in');

  final paymentId = generatePaymentId();
  final url = Uri.parse('$baseUrl/deposits/initiate_payment');

  final requestBody = {
    "request": {
      "request_id": "1",
      "data": {
        "plan_id": planId,
        "phone": phone,
        "payment_id": paymentId,
        "user_id": userId,
      },
    },
  };

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(requestBody),
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Request failed: ${response.statusCode} - ${response.body}',
    );
  }
}

//not used

Future<void> getFixtureDetail(String id) async {
  final token = await storage.read(key: 'access_token');
  if (token == null) throw Exception('User not logged in');

  final requestId = DateTime.now().millisecondsSinceEpoch;

  final requestBody = {
    "request": {
      "request_id": requestId,
      "data": {"id": id},
    },
  };

  final url = Uri.parse('$baseUrl/fixtures/fixture_details');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(requestBody),
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Request failed: ${response.statusCode} - ${response.body}',
    );
  }
}
