import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../utils/translations.dart';

class TeamCard extends StatelessWidget {
  final Map<String, dynamic> team;

  const TeamCard({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/team/${team['idTeam']}'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A3E)),
        ),
        child: Row(
          children: [
            if (team['strBadge'] != null)
              CachedNetworkImage(
                imageUrl: team['strBadge'],
                width: 48,
                height: 48,
                fit: BoxFit.contain,
                errorWidget: (_, __, ___) => const Icon(Icons.sports_soccer, size: 48, color: Colors.white24),
              )
            else
              const Icon(Icons.sports_soccer, size: 48, color: Colors.white24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team['strTeam'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tl(leagueNames, team['strLeague']),
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  if (team['strCountry'] != null)
                    Text(
                      tl(countryNames, team['strCountry']),
                      style: const TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}
