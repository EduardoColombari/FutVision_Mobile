import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

final _db = FirebaseFirestore.instance;

CollectionReference<Map<String, dynamic>> _favCol() =>
    _db.collection('users').doc(currentUser!.uid).collection('favorites');

Future<void> addFavorite(String type, Map<String, dynamic> item) async {
  final id = type == 'team' ? item['idTeam'] : item['idPlayer'];
  await _favCol().doc('${type}_$id').set({
    'type': type,
    'id': id,
    'name': type == 'team' ? item['strTeam'] : item['strPlayer'],
    'badge': type == 'team' ? item['strBadge'] : (item['strCutout'] ?? item['strThumb']),
    'subtitle': type == 'team' ? (item['strLeague'] ?? '') : (item['strTeam'] ?? ''),
    'addedAt': FieldValue.serverTimestamp(),
  });
}

Future<void> removeFavorite(String type, String id) =>
    _favCol().doc('${type}_$id').delete();

Future<bool> isFavorite(String type, String id) async {
  final doc = await _favCol().doc('${type}_$id').get();
  return doc.exists;
}

Stream<List<Map<String, dynamic>>> favoritesStream() =>
    _favCol().orderBy('addedAt', descending: true).snapshots().map(
      (snap) => snap.docs.map((d) => d.data()).toList(),
    );
