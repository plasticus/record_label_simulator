// ─── PATTERNS ────────────────────────────────────────────────────────────────
// Structural templates for generated text. Vocabulary lives in CSV files.
// Add new pattern lists here as the game expands (songs, albums, etc.)

// ─── BAND NAME PATTERNS ──────────────────────────────────────────────────────

const List<String> bandPatterns = [
  'The [Adjective] [Noun_Plural]',          // The Cosmic Vipers
  '[Adjective] [Noun]',                      // Rusty Overdrive
  '[Color] [Noun]',                          // Crimson Wraith
  'The [Gerund_Verb] [Noun]',               // The Bleeding Empire
  'The [Color] [Noun_Plural]',              // The Neon Phantoms
  '[Noun] [Noun]',                           // Thunder Vortex
  '[Gerund_Verb] [Human_Name]',             // Haunting Roxie
  '[Adjective] [Human_Name]',               // Velvet Ziggy
  '[Human_Name] and the [Noun_Plural]',     // Lemmy and the Jackals
  '[Gerund_Verb] [Noun_Plural]',            // Screaming Wolves
  '[Adverb] [Gerund_Verb] [Noun_Plural]',  // Violently Crashing Foxes
  '[Human_Name] [Noun]',                    // Ozzy Havoc
  'The [Noun_Plural] Who [Adverb] [Verb]', // The Ravens Who Loudly Burn
  'The [Noun_Plural]',                      // The Hornets
  '[Verb] The [Noun]',                      // Haunt The Tempest
  '[Adverb] [Adjective] [Noun]',           // Quietly Electric Asylum
  '[Color] [Gerund_Verb] [Noun]',          // Amber Howling Requiem
  '[Number] [Noun_Plural] [Adverb_Place]', // Seven Stallions Adrift
  '[Verb] [Preposition] [Article] [Noun]', // Burn Into The Abyss
  '[Noun] [Preposition] [Noun]',           // Venom Of Thunder
  '[First_Syllable][Second_Syllable]',                              // Kaelic
  '[Adjective] [First_Syllable][Second_Syllable]',                  // Savage Novon
  'The [First_Syllable][Second_Syllable] [First_Syllable][Second_Syllable]', // The Razeth Glimor
  'The [First_Syllable][Second_Syllable] [Noun]', // The Elthum Earthquake
  '[Acronym: [Noun] [Noun] [Noun]]',       // VHR (Venom Havoc Reckoning)
];

// ─── PORTMANTEAU SYLLABLES ───────────────────────────────────────────────────
// Used by the [First_Syllable][Second_Syllable] pattern above.

const List<String> firstSyllables = [
  'Ast', 'Brix', 'Crag', 'Dra', 'Eph', 'Fend', 'Glim', 'Hext', 'Id', 'Jor',
  'Kael', 'Lox', 'Myl', 'Nova', 'Oph', 'Plax', 'Quor', 'Raz', 'Syr', 'Thra',
  'Urb', 'Vex', 'Wyr', 'Xan', 'Yor', 'Zon',
  'Bryn', 'Cors', 'Drev', 'Elth', 'Fyrn', 'Grav', 'Ixor', 'Keth',
  'Mryn', 'Nox', 'Prex', 'Rhal', 'Stryx', 'Thex', 'Ulv',
];

const List<String> secondSyllables = [
  'is', 'ar', 'on', 'ic', 'it', 'en', 'ax', 'or', 'ia', 'us',
  'ek', 'um', 'lyr', 'ax', 'thos', 'odon', 'ix', 'ica', 'alon', 'eth',
  'orn', 'ath', 'eld', 'yn', 'yx', 'ael', 'oth', 'una',
  'aris', 'enox', 'ivan', 'ular', 'enth',
];

// ─── SONG NAME PATTERNS ──────────────────────────────────────────────────────
// TODO: add song name patterns here when ready.