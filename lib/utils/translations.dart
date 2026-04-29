const leagueNames = {
  'English Premier League': 'Premier League (Inglaterra)',
  'English League Championship': 'Championship (Inglaterra)',
  'German Bundesliga': 'Bundesliga (Alemanha)',
  'Italian Serie A': 'Serie A (Itália)',
  'French Ligue 1': 'Ligue 1 (França)',
  'Spanish La Liga': 'La Liga (Espanha)',
  'Dutch Eredivisie': 'Eredivisie (Holanda)',
  'Belgian Pro League': 'Pro League (Bélgica)',
  'Portuguese Primeira Liga': 'Primeira Liga (Portugal)',
  'American Major League Soccer': 'MLS (EUA)',
  'Brazilian Série A': 'Brasileirão Série A',
  'Brazilian Série B': 'Brasileirão Série B',
  'Argentine Primera Division': 'Primera División (Argentina)',
  'Mexican Primera Division Liga MX': 'Liga MX (México)',
  'Turkish Süper Lig': 'Süper Lig (Turquia)',
  'UEFA Champions League': 'UEFA Champions League',
  'UEFA Europa League': 'UEFA Europa League',
};

const positionNames = {
  'Goalkeeper': 'Goleiro',
  'Defender': 'Defensor',
  'Midfielder': 'Meio-campista',
  'Forward': 'Atacante',
  'Striker': 'Atacante',
  'Winger': 'Ponta',
  'Centre-Back': 'Zagueiro',
  'Left-Back': 'Lateral Esquerdo',
  'Right-Back': 'Lateral Direito',
  'Central Midfield': 'Meia Central',
  'Defensive Midfield': 'Volante',
  'Attacking Midfield': 'Meia Atacante',
  'Centre-Forward': 'Centroavante',
};

const countryNames = {
  'England': 'Inglaterra',
  'Spain': 'Espanha',
  'Germany': 'Alemanha',
  'Italy': 'Itália',
  'France': 'França',
  'Portugal': 'Portugal',
  'Netherlands': 'Holanda',
  'Belgium': 'Bélgica',
  'Scotland': 'Escócia',
  'Brazil': 'Brasil',
  'Argentina': 'Argentina',
  'Mexico': 'México',
  'USA': 'EUA',
  'Australia': 'Austrália',
  'Turkey': 'Turquia',
  'Russia': 'Rússia',
  'Greece': 'Grécia',
};

String tl(Map<String, String> map, String? key) {
  if (key == null || key.isEmpty) return '—';
  return map[key] ?? key;
}
