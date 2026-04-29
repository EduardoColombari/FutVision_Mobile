import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LeagueCard extends StatelessWidget {
  final Map<String, dynamic> league;
  final bool active;
  final void Function(Map<String, dynamic>) onSelect;

  const LeagueCard({
    super.key,
    required this.league,
    required this.active,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(league),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF00E5FF).withOpacity(0.15)
              : const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? const Color(0xFF00E5FF) : const Color(0xFF2A2A3E),
            width: active ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (league['strBadge'] != null)
              CachedNetworkImage(
                imageUrl: league['strBadge'],
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorWidget: (_, __, ___) => const SizedBox(width: 24),
              ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                league['strLeague'] ?? '',
                style: TextStyle(
                  color: active ? const Color(0xFF00E5FF) : Colors.white70,
                  fontSize: 12,
                  fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
