import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/football_api.dart';
import '../widgets/league_card.dart';
import '../widgets/team_card.dart';

const _features = [
  {'icon': '🏆', 'title': 'Classificações', 'desc': 'Tabelas completas das principais ligas.', 'route': '/standings'},
  {'icon': '⚽', 'title': 'Próximos Jogos', 'desc': 'Calendário com horários e confrontos.', 'route': '/matches'},
  {'icon': '👤', 'title': 'Jogadores', 'desc': 'Busque qualquer jogador do mundo.', 'route': '/players'},
  {'icon': '⚖️', 'title': 'Comparar Times', 'desc': 'Compare dois times lado a lado.', 'route': '/compare'},
];

const _stats = [
  {'value': '200+', 'label': 'Ligas'},
  {'value': '15k+', 'label': 'Times'},
  {'value': '100k+', 'label': 'Jogadores'},
  {'value': 'Real', 'label': 'Tempo Real'},
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _leagues = [];
  Map<String, dynamic>? _selected;
  List<dynamic> _teams = [];
  bool _loading = false;
  String? _error;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLeagues().then((l) => setState(() => _leagues = l)).catchError((_) {});
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    setState(() { _loading = true; _error = null; _selected = null; });
    try {
      final data = await searchTeams(query);
      setState(() {
        _teams = data;
        if (data.isEmpty) _error = 'Nenhum time encontrado.';
      });
    } catch (_) {
      setState(() => _error = 'Erro ao buscar times.');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _handleLeague(Map<String, dynamic> league) async {
    setState(() { _selected = league; _loading = true; _error = null; });
    _controller.clear();
    try {
      final data = await searchTeams(league['strLeague']);
      setState(() {
        _teams = data;
        if (data.isEmpty) _error = 'Nenhum time encontrado para esta liga.';
      });
    } catch (_) {
      setState(() => _error = 'Erro ao carregar times.');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0D0D1A), Color(0xFF1A1A2E)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3)),
                  ),
                  child: const Text('⚡ Dados em tempo real',
                      style: TextStyle(color: Color(0xFF00E5FF), fontSize: 12)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'O futebol mundial\nna palma da sua\nmão.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Explore times, jogadores, classificações e próximos jogos das principais ligas do mundo.',
                  style: TextStyle(color: Colors.white60, fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => context.push('/standings'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E5FF),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Ver Classificações', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => context.push('/players'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white30),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Buscar Jogadores'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Stats bar
          Container(
            color: const Color(0xFF12121F),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _stats.map((s) => Column(
                children: [
                  Text(s['value']!, style: const TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(s['label']!, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              )).toList(),
            ),
          ),

          // Features
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('O que você encontra aqui', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 12)),
                const SizedBox(height: 8),
                const Text('Tudo sobre futebol em um só lugar',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: _features.map((f) => GestureDetector(
                    onTap: () => context.push(f['route']!),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A2E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2A2A3E)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f['icon']!, style: const TextStyle(fontSize: 24)),
                          const SizedBox(height: 8),
                          Text(f['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text(f['desc']!, style: const TextStyle(color: Colors.white54, fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),

          // Explore
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Explorar', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 12)),
                const SizedBox(height: 8),
                const Text('Busque times e ligas',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Buscar time (ex: Arsenal, Flamengo...)',
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: const Color(0xFF1A1A2E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF2A2A3E)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF2A2A3E)),
                          ),
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
                else if (_teams.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _teams.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => TeamCard(team: _teams[i]),
                  )
                else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Text('⚽ Busque um time ou selecione uma liga acima.',
                          style: TextStyle(color: Colors.white38)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
