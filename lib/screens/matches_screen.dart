import 'package:flutter/material.dart';
import '../services/football_api.dart';
import '../widgets/league_card.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  List<dynamic> _leagues = [];
  Map<String, dynamic>? _selected;
  List<dynamic> _events = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchLeagues().then((l) => setState(() => _leagues = l)).catchError((_) {});
  }

  Future<void> _handleLeague(Map<String, dynamic> league) async {
    setState(() { _selected = league; _loading = true; _error = null; });
    try {
      final data = await fetchNextEvents(league['idLeague']);
      setState(() {
        _events = data;
        if (data.isEmpty) _error = 'Nenhum jogo encontrado.';
      });
    } catch (_) {
      setState(() => _error = 'Erro ao carregar jogos.');
    } finally {
      setState(() => _loading = false);
    }
  }

  String _formatDate(String? dateStr, String? timeStr) {
    if (dateStr == null) return '—';
    try {
      final dt = DateTime.parse('${dateStr}T${timeStr ?? '00:00:00'}');
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Próximos Jogos', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Selecione uma liga para ver os próximos jogos.', style: TextStyle(color: Colors.white54)),
          const SizedBox(height: 16),
          if (_leagues.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _leagues.take(10).map((l) => LeagueCard(
                league: l,
                active: _selected?['idLeague'] == l['idLeague'],
                onSelect: _handleLeague,
              )).toList(),
            ),
          const SizedBox(height: 16),
          if (_loading)
            const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF)))
          else if (_error != null)
            Text('⚠️ $_error', style: const TextStyle(color: Colors.redAccent))
          else if (_events.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _events.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final ev = _events[i];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2A2A3E)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                if (ev['strHomeTeamBadge'] != null)
                                  Image.network(ev['strHomeTeamBadge'], width: 40, height: 40, errorBuilder: (_, __, ___) => const SizedBox(height: 40)),
                                const SizedBox(height: 6),
                                Text(ev['strHomeTeam'] ?? '', textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('VS', style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                if (ev['strAwayTeamBadge'] != null)
                                  Image.network(ev['strAwayTeamBadge'], width: 40, height: 40, errorBuilder: (_, __, ___) => const SizedBox(height: 40)),
                                const SizedBox(height: 6),
                                Text(ev['strAwayTeam'] ?? '', textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('📅 ${_formatDate(ev['dateEvent'], ev['strTime'])}',
                              style: const TextStyle(color: Colors.white54, fontSize: 12)),
                          if (ev['strVenue'] != null) ...[
                            const Text('  ·  ', style: TextStyle(color: Colors.white24)),
                            Flexible(child: Text('🏟️ ${ev['strVenue']}',
                                style: const TextStyle(color: Colors.white54, fontSize: 12),
                                overflow: TextOverflow.ellipsis)),
                          ],
                        ],
                      ),
                      if (ev['intRound'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text('Rodada ${ev['intRound']}',
                              style: const TextStyle(color: Colors.white38, fontSize: 11)),
                        ),
                    ],
                  ),
                );
              },
            )
          else if (_selected == null)
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
