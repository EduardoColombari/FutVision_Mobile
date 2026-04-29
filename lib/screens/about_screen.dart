import 'package:flutter/material.dart';

const _techs = [
  {'icon': '🐦', 'name': 'Flutter', 'desc': 'Framework para apps multiplataforma'},
  {'icon': '🎯', 'name': 'Dart', 'desc': 'Linguagem de programação moderna'},
  {'icon': '🔀', 'name': 'go_router', 'desc': 'Navegação e rotas dinâmicas'},
  {'icon': '🌐', 'name': 'http', 'desc': 'Cliente HTTP para consumo de APIs'},
  {'icon': '🖼️', 'name': 'cached_network_image', 'desc': 'Imagens com cache eficiente'},
  {'icon': '🎨', 'name': 'Material Design', 'desc': 'Sistema de design do Google'},
];

const _features = [
  {'icon': '🏆', 'text': 'Classificações por liga e temporada'},
  {'icon': '⚽', 'text': 'Próximos jogos com data e estádio'},
  {'icon': '👤', 'text': 'Busca de jogadores com dados completos'},
  {'icon': '🏟️', 'text': 'Detalhes de times com elenco e galeria'},
  {'icon': '⚖️', 'text': 'Comparação lado a lado entre times'},
  {'icon': '🌐', 'text': 'Tradução automática para português'},
  {'icon': '📱', 'text': 'Interface nativa para mobile'},
];

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                const Text('Sobre o projeto', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 12)),
                const SizedBox(height: 12),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'FutVision — ', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                      TextSpan(text: 'futebol', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 28, fontWeight: FontWeight.bold)),
                      TextSpan(text: '\nem dados', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Plataforma mobile para explorar o universo do futebol mundial. Desenvolvida como projeto acadêmico com Flutter.',
                  style: TextStyle(color: Colors.white60, fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // O que é
                const Text('O projeto', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 12)),
                const SizedBox(height: 8),
                const Text('O que é o FutVision?', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Text(
                  'FutVision é um app mobile desenvolvido em Flutter que consome dados em tempo real da TheSportsDB API para oferecer uma experiência completa de exploração do futebol mundial.\n\nO projeto nasceu como atividade acadêmica com o objetivo de aplicar na prática conceitos modernos de desenvolvimento mobile: componentização, rotas dinâmicas, consumo de APIs REST e gerenciamento de estado.',
                  style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.6),
                ),
                const SizedBox(height: 16),
                ..._features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Text(f['icon']!, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      Text(f['text']!, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                )),

                const SizedBox(height: 28),
                // Tecnologias
                const Text('Stack', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 12)),
                const SizedBox(height: 8),
                const Text('Tecnologias utilizadas', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2,
                  children: _techs.map((t) => Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF2A2A3E)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${t['icon']} ${t['name']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                        const SizedBox(height: 2),
                        Text(t['desc']!, style: const TextStyle(color: Colors.white38, fontSize: 10), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  )).toList(),
                ),

                const SizedBox(height: 28),
                // API
                const Text('Dados', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 12)),
                const SizedBox(height: 8),
                const Text('API utilizada', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2A2A3E)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text('TheSportsDB', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                          Spacer(),
                          Text('thesportsdb.com ↗', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Base de dados esportiva com times, jogadores, ligas, jogos e imagens de todo o mundo.',
                          style: TextStyle(color: Colors.white60, fontSize: 12, height: 1.4)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: ['all_leagues', 'searchteams', 'lookupteam', 'searchplayers', 'lookupplayer', 'eventsnextleague', 'lookuptable']
                            .map((ep) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0D0D1A),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: const Color(0xFF2A2A3E)),
                                  ),
                                  child: Text(ep, style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 10, fontFamily: 'monospace')),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),
                // Autor
                const Text('Autor', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 12)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2A2A3E)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E5FF).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3)),
                        ),
                        child: const Center(child: Text('EE', style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, fontSize: 16))),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Eduardo Colombari Elias', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                            SizedBox(height: 4),
                            Text('Estudante de Engenharia de Software na Uni-FACEF. Projeto acadêmico de Dispositivos Móveis.',
                                style: TextStyle(color: Colors.white54, fontSize: 12, height: 1.4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
