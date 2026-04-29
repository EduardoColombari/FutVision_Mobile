import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/favorites_service.dart';
import '../services/auth_service.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: favoritesStream(),
      builder: (context, snap) {
        final favorites = snap.data ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Favoritos', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Seus times e jogadores salvos.', style: TextStyle(color: Colors.white54)),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      await signOut();
                      if (context.mounted) context.go('/login');
                    },
                    icon: const Icon(Icons.logout, color: Colors.white38, size: 18),
                    label: const Text('Sair', style: TextStyle(color: Colors.white38, fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (snap.connectionState == ConnectionState.waiting)
                const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF)))
              else if (favorites.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Column(
                      children: [
                        const Icon(Icons.star_border, color: Colors.white24, size: 64),
                        const SizedBox(height: 16),
                        const Text('Nenhum favorito ainda.', style: TextStyle(color: Colors.white38, fontSize: 16)),
                        const SizedBox(height: 8),
                        const Text('Toque em ⭐ nos times e jogadores\npara salvá-los aqui.',
                            style: TextStyle(color: Colors.white24, fontSize: 13), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: favorites.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final fav = favorites[i];
                    final isTeam = fav['type'] == 'team';
                    return GestureDetector(
                      onTap: () => context.push('/${fav['type']}/${fav['id']}'),
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
                              child: fav['badge'] != null
                                  ? CachedNetworkImage(
                                      imageUrl: fav['badge'],
                                      width: 48, height: 48, fit: BoxFit.contain,
                                      errorWidget: (_, __, ___) => _placeholder(isTeam),
                                    )
                                  : _placeholder(isTeam),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(fav['name'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                  Text(fav['subtitle'] ?? '', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00E5FF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(isTeam ? 'Time' : 'Jogador',
                                  style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 10)),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => removeFavorite(fav['type'], fav['id']),
                              child: const Icon(Icons.star, color: Color(0xFF00E5FF), size: 22),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _placeholder(bool isTeam) => Container(
    width: 48, height: 48,
    color: const Color(0xFF2A2A3E),
    child: Icon(isTeam ? Icons.shield : Icons.person, color: Colors.white24),
  );
}
