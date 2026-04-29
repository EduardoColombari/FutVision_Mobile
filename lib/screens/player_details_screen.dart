import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/football_api.dart';
import '../utils/translations.dart';
import '../widgets/favorite_button.dart';

class PlayerDetailsScreen extends StatefulWidget {
  final String id;
  const PlayerDetailsScreen({super.key, required this.id});

  @override
  State<PlayerDetailsScreen> createState() => _PlayerDetailsScreenState();
}

class _PlayerDetailsScreenState extends State<PlayerDetailsScreen> {
  Map<String, dynamic>? _player;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchPlayer(widget.id)
        .then((p) => setState(() => _player = p))
        .catchError((_) => setState(() => _error = 'Erro ao carregar dados do jogador.'))
        .whenComplete(() => setState(() => _loading = false));
  }

  int? _calcAge(String? d) {
    if (d == null) return null;
    try { return (DateTime.now().difference(DateTime.parse(d)).inDays / 365.25).floor(); }
    catch (_) { return null; }
  }

  String _formatDate(String? d) {
    if (d == null) return '—';
    final p = d.split('-');
    return p.length == 3 ? '${p[2]}/${p[1]}/${p[0]}' : d;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(
      backgroundColor: Color(0xFF0D0D1A),
      body: Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF))),
    );

    if (_error != null) return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('⚠️ $_error', style: const TextStyle(color: Colors.redAccent)),
          TextButton(onPressed: () => context.pop(), child: const Text('← Voltar', style: TextStyle(color: Color(0xFF00E5FF)))),
        ],
      )),
    );

    final p = _player!;
    final age = _calcAge(p['dateBorn']);
    const statusMap = {'Active': 'Ativo', 'Retired': 'Aposentado', 'Coaching': 'Treinador'};
    const sideMap = {'Left': 'Canhoto', 'Right': 'Destro', 'Both': 'Ambidestro'};

    final fields = [
      if (p['dateBorn'] != null) {'icon': '🎂', 'label': 'Nascimento', 'value': '${_formatDate(p['dateBorn'])}${age != null ? ' ($age anos)' : ''}'},
      if (p['strBirthLocation'] != null) {'icon': '📍', 'label': 'Local', 'value': p['strBirthLocation']},
      if (p['strNationality'] != null) {'icon': '🌐', 'label': 'Nacionalidade', 'value': tl(countryNames, p['strNationality'])},
      if (p['strPosition'] != null) {'icon': '⚽', 'label': 'Posição', 'value': tl(positionNames, p['strPosition'])},
      if (p['strSide'] != null) {'icon': '👟', 'label': 'Pé', 'value': sideMap[p['strSide']] ?? p['strSide']},
      if (p['strNumber'] != null) {'icon': '🔢', 'label': 'Camisa', 'value': p['strNumber']},
      if (p['strHeight'] != null) {'icon': '📏', 'label': 'Altura', 'value': p['strHeight']},
      if (p['strWeight'] != null) {'icon': '⚖️', 'label': 'Peso', 'value': p['strWeight']},
      if (p['strTeam'] != null) {'icon': '🏟️', 'label': 'Time atual', 'value': p['strTeam']},
      if (p['strTeam2'] != null) {'icon': '🏳️', 'label': 'Seleção', 'value': p['strTeam2']},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D1A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(p['strPlayer'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 16)),
        actions: [FavoriteButton(type: 'player', item: p)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: (p['strCutout'] ?? p['strPoster']) != null
                      ? CachedNetworkImage(
                          imageUrl: p['strCutout'] ?? p['strPoster'],
                          width: 80, height: 80, fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(width: 80, height: 80, color: const Color(0xFF2A2A3E), child: const Icon(Icons.person, color: Colors.white24, size: 40)),
                        )
                      : Container(width: 80, height: 80, color: const Color(0xFF2A2A3E), child: const Icon(Icons.person, color: Colors.white24, size: 40)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${tl(countryNames, p['strNationality'])} · ${p['strTeam'] ?? ''}',
                          style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      Text(p['strPlayer'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        children: [
                          if (p['strPosition'] != null)
                            _badge(tl(positionNames, p['strPosition'])),
                          if (p['strStatus'] != null)
                            _badge(statusMap[p['strStatus']] ?? p['strStatus'],
                                color: p['strStatus'] == 'Active' ? Colors.green.withOpacity(0.2) : null),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (p['strDescriptionEN'] != null) ...[
              const SizedBox(height: 16),
              Text(
                (p['strDescriptionEN'] as String).length > 500
                    ? '${(p['strDescriptionEN'] as String).substring(0, 500)}...'
                    : p['strDescriptionEN'],
                style: const TextStyle(color: Colors.white60, fontSize: 13, height: 1.5),
              ),
            ],
            const SizedBox(height: 20),
            const Text('Informações', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.2,
              children: fields.map((f) => Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF2A2A3E)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${f['icon']} ${f['label']}', style: const TextStyle(color: Colors.white54, fontSize: 10)),
                    const SizedBox(height: 2),
                    Text(f['value']!, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                  ],
                ),
              )).toList(),
            ),
            if ([p['strFanart1'], p['strFanart2'], p['strFanart3'], p['strFanart4']].any((e) => e != null)) ...[
              const SizedBox(height: 20),
              const Text('Galeria', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [p['strFanart1'], p['strFanart2'], p['strFanart3'], p['strFanart4']]
                      .whereType<String>()
                      .map((img) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(imageUrl: img, height: 120, width: 200, fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => const SizedBox()),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _badge(String text, {Color? color}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color ?? const Color(0xFF2A2A3E),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: Colors.white12),
    ),
    child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 11)),
  );
}
