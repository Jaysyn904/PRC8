//::///////////////////////////////////////////////
//:: PRC Runescar Scribing NUI constants
//:: prc_nui_rb_const
//:://////////////////////////////////////////////

const string PRC_RUNESCAR_SCRIBE_NUI_WINDOW_ID = "prc_runescar_scribe";
const string PRC_RUNESCAR_SCRIBE_NUI_BUTTON = "spellbookScribeRunescars";
const string PRC_RUNESCAR_DEFAULT_SAVE_BUTTON = "runeDefaultSave";
const string PRC_RUNESCAR_DEFAULT_SCRIBE_BUTTON = "runeDefaultScribe";

// A saved set is persistent character data.  Spell IDs are stored as ID + 1
// so zero remains an unambiguous missing value in the persistence layer.  The
// version marker is written last, after all seven spell/level pairs.
const string PRC_RUNESCAR_DEFAULT_VERSION_VAR = "PRC_RuneScribe_DefaultVersion";
const string PRC_RUNESCAR_DEFAULT_SPELL_VAR_BASE = "PRC_RuneScribe_DefaultSpell_";
const string PRC_RUNESCAR_DEFAULT_LEVEL_VAR_BASE = "PRC_RuneScribe_DefaultLevel_";
const int PRC_RUNESCAR_DEFAULT_VERSION = 1;

// The main /sb event stays small: it records one requested operation and lets
// the dedicated plan script perform and revalidate the persistent mutation.
const string PRC_RUNESCAR_DEFAULT_ACTION_VAR = "PRC_RuneScribe_DefaultAction";
const int PRC_RUNESCAR_DEFAULT_ACTION_SAVE = 1;
const int PRC_RUNESCAR_DEFAULT_ACTION_SCRIBE = 2;
const int PRC_RUNESCAR_DEFAULT_ACTION_CLEAR = 3;

// A session survives editor-only layout rebuilds.  Every rebuild receives a
// new layout generation so a delayed mouseup from the replaced layout cannot
// resolve against a new body position, spell map, or caster level.
const string PRC_RUNESCAR_SCRIBE_ACTIVE_SESSION_VAR = "PRC_RuneScribe_ActiveSession";
const string PRC_RUNESCAR_SCRIBE_SESSION_GENERATION_VAR = "PRC_RuneScribe_SessionGeneration";
const string PRC_RUNESCAR_SCRIBE_LAYOUT_GENERATION_VAR = "PRC_RuneScribe_LayoutGeneration";
const string PRC_RUNESCAR_SCRIBE_MAP_GENERATION_VAR = "PRC_RuneScribe_MapGeneration";
const string PRC_RUNESCAR_SCRIBE_REBUILD_TOKEN_VAR = "PRC_RuneScribe_RebuildToken";
const string PRC_RUNESCAR_SCRIBE_BOOTSTRAP_VAR = "PRC_RuneScribe_Bootstrap";

const string PRC_RUNESCAR_SCRIBE_LOCATION_VAR = "PRC_RuneScribe_Location";
const string PRC_RUNESCAR_SCRIBE_TIER_VAR = "PRC_RuneScribe_Tier";
const string PRC_RUNESCAR_SCRIBE_SPELL_VAR = "PRC_RuneScribe_Spell";
const string PRC_RUNESCAR_SCRIBE_CASTER_LEVEL_VAR = "PRC_RuneScribe_CasterLevel";
const string PRC_RUNESCAR_SCRIBE_GEOMETRY_VAR = "PRC_RuneScribe_Geometry";

const string PRC_RUNESCAR_SCRIBE_SPELL_MAP_VAR = "PRC_RuneScribe_SpellMap";
const string PRC_RUNESCAR_SCRIBE_SPELL_NAMES_VAR = "PRC_RuneScribe_SpellNames";

const string PRC_RUNESCAR_SCRIBE_LOCATION_BUTTON = "runeScribeLocation_";
const string PRC_RUNESCAR_SCRIBE_TIER_BUTTON = "runeScribeTier_";
const string PRC_RUNESCAR_SCRIBE_SPELL_LIST_BUTTON = "runeScribeSpell";
const string PRC_RUNESCAR_SCRIBE_CASTER_DOWN_BUTTON = "runeScribeCasterDown";
const string PRC_RUNESCAR_SCRIBE_CASTER_UP_BUTTON = "runeScribeCasterUp";
const string PRC_RUNESCAR_SCRIBE_SAVE_BUTTON = "runeScribeSave";
const string PRC_RUNESCAR_SCRIBE_CANCEL_BUTTON = "runeScribeCancel";
const string PRC_RUNESCAR_SCRIBE_GENERATION_MARKER = "_g";

// Keep virtual-list bind names short and unrelated.  Older NUI clients can
// alias adjacent list binds which share a long prefix.
const string PRC_RUNESCAR_SCRIBE_SPELL_NAMES_BIND = "rb_sp_name";
const string PRC_RUNESCAR_SCRIBE_SPELL_COUNT_BIND = "rb_sp_count";

const int PRC_RUNESCAR_SCRIBE_POSITION_COUNT = 7;
const int PRC_RUNESCAR_SCRIBE_TIER_COUNT = 5;
const int PRC_RUNESCAR_SCRIBE_SPELL_COUNT = 32;
