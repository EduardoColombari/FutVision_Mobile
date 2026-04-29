import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/football_api.dart';
import '../utils/translations.dart';
import '../widgets/favorite_button.dart';

class TeamDetailsScreen extends StatefulWidget {
  final String id;
  const TeamDetailsScreen({super.key, required this.id});

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  Map<String, dynamic>? _team;
  List<dynamic> _players = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchTeam(widget.id).then((t) async {
      final players = await searchPlayers(t['strTeam']);
      setState(() { _team = t; _players = players; });
    }).catchError((_) {
      setState(() => _error = 'Erro ao carregar dados do time.');
    }).whenComplete(() => setState(() => _loading = false));
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

    final team = _team!;
    final fields = [
      if (team['intFormedYear'] != null) {'icon': '📅', 'label': 'Fundado em', 'value': team['intFormedYear'].toString()},
      if (team['strStadium'] != null) {'icon': '🏟️', 'label': 'Estádio', 'value': team['strStadium']},
      if (team['strCountry'] != null) {'icon': '🌐', 'label': 'País', 'value': tl(countryNames, team['strCountry'])},
      if (team['strLocation'] != null) {'icon': '📍', 'label': 'Localização', 'value': team['strLocation']},
      if (team['strColour1'] != null) {'icon': '🎽', 'label': 'Cor principal', 'value': team['strColour1']},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D1A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(team['strTeam'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 16)),
        actions: [FavoriteButton(type: 'team', item: team)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (team['strBadge'] != null)
                  CachedNetworkImage(imageUrl: team['strBadge'], width: 72, height: 72, fit: BoxFit.contain,
                      errorWidget: (_, __, ___) => const SizedBox(width: 72)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${tl(countryNames, team['strCountry'])} · ${tl(leagueNames, team['strLeague'])}',
                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      Text(team['strTeam'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      if (team['strTeamShort'] != null)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E5FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3)),
                          ),
                          child: Text(team['strTeamShort'], style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 11)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (team['strDescriptionEN'] != null) ...[
              const SizedBox(height: 16),
              Text(
                (team['strDescriptionEN'] as String).length > 400
                    ? '${(team['strDescriptionEN'] as String).substring(0, 400)}...'
                    : team['strDescriptionEN'],
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
            if ([team['strFanart1'], team['strFanart2'], team['strFanart3'], team['strFanart4']].any((e) => e != null)) ...[
              const SizedBox(height: 20),
              const Text('Galeria', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [team['strFanart1'], team['strFanart2'], team['strFanart3'], team['strFanart4']]
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
            if (_players.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text('Jogadores', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75,
                ),
                itemCount: _players.length,
                itemBuilder: (_, i) {
                  final p = _players[i];
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF2A2A3E)),
                    ),
                    child: Column(
                      children: [
                        if (p['strThumb'] != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: CachedNetworkImage(imageUrl: p['strThumb'], width: 50, height: 50, fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => const Icon(Icons.person, color: Colors.white24, size: 50)),
                          )
                        else
                          const Icon(Icons.person, color: Colors.white24, size: 50),
                        const SizedBox(height: 4),
                        Text(p['strPlayer'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                        Text(tl(positionNames, p['strPosition']), style: const TextStyle(color: Colors.white38, fontSize: 9), textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
