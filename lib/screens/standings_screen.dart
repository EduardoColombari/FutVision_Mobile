import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/football_api.dart';
import '../widgets/league_card.dart';

const _seasons = ['2024-2025', '2023-2024', '2022-2023', '2021-2022'];

class StandingsScreen extends StatefulWidget {
  const StandingsScreen({super.key});

  @override
  State<StandingsScreen> createState() => _StandingsScreenState();
}

class _StandingsScreenState extends State<StandingsScreen> {
  List<dynamic> _leagues = [];
  Map<String, dynamic>? _selectedLeague;
  String _season = _seasons[0];
  List<dynamic> _table = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchLeagues().then((l) => setState(() => _leagues = l)).catchError((_) {});
  }

  Future<void> _load(Map<String, dynamic> league, String season) async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await fetchStandings(league['idLeague'], season);
      setState(() {
        _table = data;
        if (data.isEmpty) _error = 'Classificação não disponível para esta temporada.';
      });
    } catch (_) {
      setState(() => _error = 'Erro ao carregar classificação.');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Classificação', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Selecione uma liga e temporada.', style: TextStyle(color: Colors.white54)),
          const SizedBox(height: 16),
          if (_leagues.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _leagues.take(10).map((l) => LeagueCard(
                league: l,
                active: _selectedLeague?['idLeague'] == l['idLeague'],
                onSelect: (league) {
                  setState(() => _selectedLeague = league);
                  _load(league, _season);
                },
              )).toList(),
            ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _seasons.map((s) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() => _season = s);
                    if (_selectedLeague != null) _load(_selectedLeague!, s);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _season == s ? const Color(0xFF00E5FF).withOpacity(0.15) : const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _season == s ? const Color(0xFF00E5FF) : const Color(0xFF2A2A3E),
                      ),
                    ),
                    child: Text(s, style: TextStyle(
                      color: _season == s ? const Color(0xFF00E5FF) : Colors.white54,
                      fontSize: 12,
                    )),
                  ),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 16),
          if (_loading)
            const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF)))
          else if (_error != null)
            Text('⚠️ $_error', style: const TextStyle(color: Colors.redAccent))
          else if (_table.isNotEmpty)
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF12121F),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(width: 28, child: Text('#', style: TextStyle(color: Colors.white54, fontSize: 11))),
                      Expanded(child: Text('Time', style: TextStyle(color: Colors.white54, fontSize: 11))),
                      SizedBox(width: 24, child: Text('J', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 11))),
                      SizedBox(width: 24, child: Text('V', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 11))),
                      SizedBox(width: 24, child: Text('E', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 11))),
                      SizedBox(width: 24, child: Text('D', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 11))),
                      SizedBox(width: 32, child: Text('SG', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 11))),
                      SizedBox(width: 32, child: Text('Pts', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                ..._table.map((row) => GestureDetector(
                  onTap: () => context.push('/team/${row['idTeam']}'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 28, child: Text('${row['intRank']}', style: const TextStyle(color: Colors.white54, fontSize: 12))),
                        Expanded(
                          child: Row(
                            children: [
                              if (row['strBadge'] != null)
                                Image.network(row['strBadge'], width: 18, height: 18, errorBuilder: (_, __, ___) => const SizedBox(width: 18)),
                              const SizedBox(width: 6),
                              Flexible(child: Text(row['strTeam'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 12), overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ),
                        SizedBox(width: 24, child: Text('${row['intPlayed'] ?? ''}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                        SizedBox(width: 24, child: Text('${row['intWin'] ?? ''}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                        SizedBox(width: 24, child: Text('${row['intDraw'] ?? ''}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                        SizedBox(width: 24, child: Text('${row['intLoss'] ?? ''}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                        SizedBox(width: 32, child: Text('${row['intGoalDifference'] ?? ''}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                        SizedBox(width: 32, child: Text('${row['intPoints'] ?? ''}', textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, fontSize: 12))),
                      ],
                    ),
                  ),
                )),
              ],
            )
          else if (_selectedLeague == null)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 32),
                child: Text('⚽ Selecione uma liga acima.', style: TextStyle(color: Colors.white38)),
              ),
            ),
        ],
      ),
    );
  }
}
