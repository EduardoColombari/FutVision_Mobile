import 'dart:convert';
import 'package:http/http.dart' as http;

const _apiKey = '123';
const _base = 'https://www.thesportsdb.com/api/v1/json/$_apiKey';

Future<Map<String, dynamic>> _get(String path) async {
  final res = await http.get(Uri.parse('$_base$path'));
  if (res.statusCode != 200) throw Exception('Erro na requisição');
  return jsonDecode(res.body);
}

Future<List<dynamic>> fetchLeagues() async {
  final data = await _get('/all_leagues.php');
  return (data['leagues'] as List? ?? [])
      .where((l) => l['strSport'] == 'Soccer')
      .toList();
}

Future<Map<String, dynamic>> fetchLeague(String id) async {
  final data = await _get('/lookupleague.php?id=$id');
  final l = (data['leagues'] as List?)?.firstOrNull;
  if (l == null) throw Exception('Liga não encontrada');
  return l;
}

Future<List<dynamic>> searchTeams(String name) async {
  final data = await _get('/searchteams.php?t=${Uri.encodeComponent(name)}');
  return (data['teams'] as List? ?? [])
      .where((t) => t['strSport'] == 'Soccer')
      .toList();
}

Future<Map<String, dynamic>> fetchTeam(String id) async {
  final data = await _get('/lookupteam.php?id=$id');
  final t = (data['teams'] as List?)?.firstOrNull;
  if (t == null) throw Exception('Time não encontrado');
  return t;
}

Future<List<dynamic>> searchPlayers(String teamName) async {
  final data = await _get('/searchplayers.php?t=${Uri.encodeComponent(teamName)}');
  return data['player'] as List? ?? [];
}

Future<List<dynamic>> searchPlayersByName(String name) async {
  final data = await _get('/searchplayers.php?p=${Uri.encodeComponent(name)}');
  return (data['player'] as List? ?? [])
      .where((p) => p['strSport'] == 'Soccer')
      .toList();
}

Future<Map<String, dynamic>> fetchPlayer(String id) async {
  final data = await _get('/lookupplayer.php?id=$id');
  final p = (data['players'] as List?)?.firstOrNull;
  if (p == null) throw Exception('Jogador não encontrado');
  return p;
}

Future<List<dynamic>> fetchNextEvents(String leagueId) async {
  final data = await _get('/eventsnextleague.php?id=$leagueId');
  return data['events'] as List? ?? [];
}

Future<List<dynamic>> fetchStandings(String leagueId, String season) async {
  final data = await _get('/lookuptable.php?l=$leagueId&s=$season');
  return data['table'] as List? ?? [];
}
