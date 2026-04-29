import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/football_api.dart';
import '../utils/translations.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  List<dynamic> _players = [];
  bool _loading = false;
  String? _error;
  bool _searched = false;
  final _controller = TextEditingController();

  final _statusMap = const {'Active': 'Ativo', 'Retired': 'Aposentado', 'Coaching': 'Treinador'};

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    setState(() { _loading = true; _error = null; _searched = true; });
    try {
      final data = await searchPlayersByName(query);
      setState(() {
        _players = data;
        if (data.isEmpty) _error = 'Nenhum jogador encontrado.';
      });
    } catch (_) {
      setState(() => _error = 'Erro ao buscar jogadores.');
    } finally {
      setState(() => _loading = false);
    }
  }

  String _formatDate(String? d) {
    if (d == null) return '—';
    final parts = d.split('-');
    if (parts.length != 3) return d;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  int? _calcAge(String? d) {
    if (d == null) return null;
    try {
      final diff = DateTime.now().difference(DateTime.parse(d));
      return (diff.inDays / 365.25).floor();
    } catch (_) { return null; }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Jogadores', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Busque jogadores pelo nome.', style: TextStyle(color: Colors.white54)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Ex: Messi, Ronaldo, Vini Jr...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF1A1A2E),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2A2A3E))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2A2A3E))),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  onSubmitted: _search,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _search(_controller.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E5FF),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Buscar', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_loading)
            const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF)))
          else if (_error != null)
            Text('⚠️ $_error', style: const TextStyle(color: Colors.redAccent))
          else if (_players.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _players.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final p = _players[i];
                final age = _calcAge(p['dateBorn']);
                return GestureDetector(
                  onTap: () => context.push('/player/${p['idPlayer']}'),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF2A2A3E)),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: (p['strCutout'] ?? p['strThumb']) != null
                              ? CachedNetworkImage(
                                  imageUrl: p['strCutout'] ?? p['strThumb'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => Container(
                                    width: 60, height: 60,
                                    color: const Color(0xFF2A2A3E),
                                    child: const Icon(Icons.sports_soccer, color: Colors.white24),
                                  ),
                                )
                              : Container(
                                  width: 60, height: 60,
                                  color: const Color(0xFF2A2A3E),
                                  child: const Icon(Icons.sports_soccer, color: Colors.white24),
                                ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p['strPlayer'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                              Text(p['strTeam'] ?? '—', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 6,
                                children: [
                                  if (p['strPosition'] != null)
                                    _tag(tl(positionNames, p['strPosition'])),
                                  if (p['strNationality'] != null)
                                    _tag(tl(countryNames, p['strNationality'])),
                                  if (p['strStatus'] != null)
                                    _tag(_statusMap[p['strStatus']] ?? p['strStatus'],
                                        color: p['strStatus'] == 'Active' ? Colors.green.withOpacity(0.2) : null),
                                ],
                              ),
                              if (p['dateBorn'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text('🎂 ${_formatDate(p['dateBorn'])}${age != null ? ' ($age anos)' : ''}',
                                      style: const TextStyle(color: Colors.white38, fontSize: 11)),
                                ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.white24),
                      ],
                    ),
                  ),
                );
              },
            )
          else if (!_searched)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 32),
                child: Text('🔍 Digite o nome de um jogador para buscar.', style: TextStyle(color: Colors.white38)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _tag(String text, {Color? color}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: color ?? const Color(0xFF2A2A3E),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 10)),
  );
}
