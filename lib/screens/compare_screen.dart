import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/football_api.dart';
import '../utils/translations.dart';

const _statRows = [
  {'label': 'Liga', 'key': 'strLeague', 'translate': 'league'},
  {'label': 'País', 'key': 'strCountry', 'translate': 'country'},
  {'label': 'Fundado', 'key': 'intFormedYear'},
  {'label': 'Estádio', 'key': 'strStadium'},
  {'label': 'Capacidade', 'key': 'intStadiumCapacity'},
  {'label': 'Localização', 'key': 'strLocation'},
];

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  Map<String, dynamic>? _team1;
  Map<String, dynamic>? _team2;

  void _setTeam(int slot, Map<String, dynamic>? team) {
    setState(() {
      if (slot == 1) _team1 = team;
      else _team2 = team;
    });
  }

  String _val(Map<String, dynamic> team, Map row) {
    final key = row['key'] as String;
    final translate = row['translate'] as String?;
    final v = team[key]?.toString();
    if (v == null || v.isEmpty) return '—';
    if (translate == 'league') return tl(leagueNames, v);
    if (translate == 'country') return tl(countryNames, v);
    return v;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Comparar Times', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Busque dois times para comparar lado a lado.', style: TextStyle(color: Colors.white54)),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _TeamSelector(label: 'Time 1', onSelect: (t) => _setTeam(1, t))),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 40),
                child: Text('VS', style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              Expanded(child: _TeamSelector(label: 'Time 2', onSelect: (t) => _setTeam(2, t))),
            ],
          ),
          if (_team1 != null && _team2 != null) ...[
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2A2A3E)),
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        Expanded(child: _teamHeader(_team1!)),
                        Expanded(child: _teamHeader(_team2!)),
                      ],
                    ),
                  ),
                  const Divider(color: Color(0xFF2A2A3E), height: 1),
                  ..._statRows.map((row) => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(child: Text(row['label'] as String, style: const TextStyle(color: Colors.white54, fontSize: 12))),
                            Expanded(child: Text(_val(_team1!, row), style: const TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center)),
                            Expanded(child: Text(_val(_team2!, row), style: const TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center)),
                          ],
                        ),
                      ),
                      const Divider(color: Color(0xFF2A2A3E), height: 1),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _teamHeader(Map<String, dynamic> team) => Column(
    children: [
      if (team['strBadge'] != null)
        CachedNetworkImage(imageUrl: team['strBadge'], width: 36, height: 36, fit: BoxFit.contain,
            errorWidget: (_, __, ___) => const SizedBox(width: 36)),
      const SizedBox(height: 4),
      Text(team['strTeam'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12), textAlign: TextAlign.center),
    ],
  );
}

class _TeamSelector extends StatefulWidget {
  final String label;
  final void Function(Map<String, dynamic>?) onSelect;

  const _TeamSelector({required this.label, required this.onSelect});

  @override
  State<_TeamSelector> createState() => _TeamSelectorState();
}

class _TeamSelectorState extends State<_TeamSelector> {
  Map<String, dynamic>? _selected;
  List<dynamic> _results = [];
  bool _loading = false;
  final _controller = TextEditingController();

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    setState(() => _loading = true);
    try {
      final data = await searchTeams(query);
      setState(() => _results = data);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 8),
        if (_selected != null)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.4)),
            ),
            child: Column(
              children: [
                if (_selected!['strBadge'] != null)
                  CachedNetworkImage(imageUrl: _selected!['strBadge'], width: 40, height: 40, fit: BoxFit.contain,
                      errorWidget: (_, __, ___) => const SizedBox(width: 40)),
                const SizedBox(height: 6),
                Text(_selected!['strTeam'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    setState(() { _selected = null; _results = []; _controller.clear(); });
                    widget.onSelect(null);
                  },
                  child: const Text('Trocar', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 12)),
                ),
              ],
            ),
          )
        else ...[
          TextField(
            controller: _controller,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: InputDecoration(
              hintText: 'Ex: Arsenal...',
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
              filled: true,
              fillColor: const Color(0xFF1A1A2E),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2A2A3E))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2A2A3E))),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search, color: Color(0xFF00E5FF), size: 18),
                onPressed: () => _search(_controller.text),
              ),
            ),
            onSubmitted: _search,
          ),
          if (_loading)
            const Padding(padding: EdgeInsets.only(top: 8), child: LinearProgressIndicator(color: Color(0xFF00E5FF))),
          if (_results.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF2A2A3E)),
              ),
              child: Column(
                children: _results.take(5).map((t) => GestureDetector(
                  onTap: () {
                    setState(() { _selected = t; _results = []; });
                    widget.onSelect(t);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      children: [
                        if (t['strBadge'] != null)
                          Image.network(t['strBadge'], width: 20, height: 20, errorBuilder: (_, __, ___) => const SizedBox(width: 20)),
                        const SizedBox(width: 8),
                        Expanded(child: Text('${t['strTeam']} — ${t['strLeague'] ?? ''}',
                            style: const TextStyle(color: Colors.white70, fontSize: 11), overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ),
                )).toList(),
              ),
            ),
          ],
        ],
      ],
    );
  }
}
