import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../services/auth_service.dart';

class FavoriteButton extends StatefulWidget {
  final String type;
  final Map<String, dynamic> item;

  const FavoriteButton({super.key, required this.type, required this.item});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFav = false;
  bool _loading = true;

  String get _id => widget.type == 'team'
      ? widget.item['idTeam']
      : widget.item['idPlayer'];

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      isFavorite(widget.type, _id).then((v) {
        if (mounted) setState(() { _isFav = v; _loading = false; });
      });
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _toggle() async {
    if (currentUser == null) return;
    setState(() => _loading = true);
    if (_isFav) {
      await removeFavorite(widget.type, _id);
    } else {
      await addFavorite(widget.type, widget.item);
    }
    if (mounted) setState(() { _isFav = !_isFav; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) return const SizedBox();
    return IconButton(
      onPressed: _loading ? null : _toggle,
      icon: _loading
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF00E5FF)))
          : Icon(
              _isFav ? Icons.star : Icons.star_border,
              color: _isFav ? const Color(0xFF00E5FF) : Colors.white38,
            ),
    );
  }
}
