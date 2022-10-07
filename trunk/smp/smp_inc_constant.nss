/*:://////////////////////////////////////////////
//:: Name Spell Constants
//:: FileName SMP_INC_Constant
//:://////////////////////////////////////////////
    This include file is meant for spells which do not
    use default numbers. All spells which are new
    have constants here.

    Also includes all spell-related item specifics and so on.

    Included in SMP_inc_spells, and SMP_inc_prespells.

    Remember, for the lines in the .2da, add 16777216 + (tlk entry number) for
    the name and descriptions.

    TLK entries start at 88,000 (to 97,999, which is 10000 lines)

    Meaning we start at 16689216 (88,000) to 16699215 (97,999)

    Note that descriptions and names of spells are 89000+, and item properties
    much higher for space reasons.

    1.67  | 5 Feet
    3.33  | 10 Feet
    5.0   | 15 Feet
    6.67  | 20 feet
    8.33  | 25 Feet
    10.0  | 30 Feet
    11.67 | 35 Feet
    13.33 | 40 Feet
    15.0  | 45 Feet
    16.67 | 50 Feet

//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// Other constants
#include "SMP_INC_VISUALS"
#include "SMP_INC_POLYCONT"
// Setting locals
#include "SMP_INC_LOCALS"
// "Color"'s for text
#include "SMP_INC_COLOR"

// New value for invalid spells, -1, which should be already present really.
const int SPELL_INVALID = -1;
// New value for invalid duration, -1
const int DURATION_INVALID = -1;

// Ranges

const float RADIUS_SIZE_FEET_5  = 1.67; // 5 Feet
const float RADIUS_SIZE_FEET_10 = 3.33; // 10 Feet
const float RADIUS_SIZE_FEET_15 = 5.0;  // 15 Feet
const float RADIUS_SIZE_FEET_20 = 6.67; // 20 Feet
const float RADIUS_SIZE_FEET_25 = 8.33; // 25 Feet
const float RADIUS_SIZE_FEET_30 = 10.0; // 30 Feet
const float RADIUS_SIZE_FEET_35 = 11.67;// 35 Feet
const float RADIUS_SIZE_FEET_40 = 13.33;// 40 Feet
const float RADIUS_SIZE_FEET_45 = 15.0; // 45 Feet
const float RADIUS_SIZE_FEET_50 = 16.67;// 50 Feet

const float RANGE_SPELL_TOUCH   = 2.25;// 2.25M range
const float RANGE_SPELL_CLOSE   = 8.0; // 8.0M range
const float RANGE_SPELL_MEDIUM  = 20.0;// 20.0M range
const float RANGE_SPELL_LONG    = 40.0;// 40.0M range

// New races
const int RACIAL_TYPE_MAGIC_FORCE = 20;// RACIAL_TYPE_OUTSIDER

// New classes (for the new races, the packages)
const int CLASS_TYPE_MAGICAL_FORCE = 24;// CLASS_TYPE_OUTSIDER

// New packages for above classes
const int PACKAGE_MAGICAL_FORCE = 86;// PACKAGE_OUTSIDER


// Special
// - If this is TRUE for a creature, local int, then they are a plant race.
const string SMP_PLANT = "SMP_PLANT";
// - If this is TRUE, for a creature, they are "crystaline".
const string SMP_CRYSTALLINE = "SMP_CRYSTALLINE";
// - This is the wieght of a door, in Pounds (lbs) used for Shatter. Set as local integer.
// - If 0, IE not set, then shatter doesn't work.
const string SMP_PLACEABLE_WEIGHT   = "SMP_PLACEABLE_WEIGHT";
// This needs to be set to TRUE on any placeable that CAN be opened with Open/Close spell.
const string SMP_CONST_CAN_BE_MAGICALLY_OPENED = "SMP_CONST_CAN_BE_MAGICALLY_OPENED";

// This is a special tag of an object that should be used to cast the spells associated
// with things like Domain Spell stoppers.
const string SMP_STATIC_SPELL_CASTER = "SMP_CASTER";

// This is set to a local object for the person's master.
const string SMP_MASTER = "SMP_MASTER";

// Set to TRUE for SMP_MAGICAL_TRAP_DETECTED_BY + GetName(oDetected) for magical
// traps. Local Int.
const string SMP_MAGICAL_TRAP_DETECTED_BY = "SMP_MTDB";
// This is set to TRUE on any visible rune/magical trap. Local Int.
const string SMP_MAGICAL_TRAP_ALWAYS_DETECTED = "SMP_MTAD";
// The level (Spell level, like 5 for Symbol of Pain) of the magical trap. Local Int.
const string SMP_MAGICAL_TRAP_LEVEL = "SMP_MAGICAL_TRAP_LEVEL";

// Creature things - for summons mainly. Res Ref's and tags.
const string SMP_CREATURE_RESREF_MAGES_SWORD = "SMP_magessword";
const string SMP_CREATURE_RESREF_WHIRLWIND = "SMP_whirlwind";
const string SMP_CREATURE_RESREF_FLAMING_SPHERE = "SMP_flamingsphere";
const string SMP_CREATURE_RESREF_CHANGESTAFF_TREANT = "SMP_changetreant";
const string SMP_CREATURE_RESREF_SPIRITUAL_WEAPON = "SMP_spiritualwea";

const string SMP_CREATURE_TAG_MAGES_SWORD = "SMP_magessword";


// Explosive runes.
// This is set to TRUE on an item if they have the runes
const string SMP_EXPLOSIVE_RUNES_SET = "SMP_EXPLOSIVE_RUNES_SET";
// This is the caster of the runes, also set to the item
const string SMP_EXPLOSIVE_RUNES_OBJECT = "SMP_EXPLOSIVE_RUNES_OBJECT";
// DC of the spell, set to a local int
const string SMP_EXPLOSIVE_RUNES_DC = "SMP_EXPLOSIVE_RUNES_DC";


/* Spell levels - unused currently
const int SMP_SPELL_LEVEL_0                         = 0;
const int SMP_SPELL_LEVEL_1                         = 1;
const int SMP_SPELL_LEVEL_2                         = 2;
const int SMP_SPELL_LEVEL_3                         = 3;
const int SMP_SPELL_LEVEL_4                         = 4;
const int SMP_SPELL_LEVEL_5                         = 5;
const int SMP_SPELL_LEVEL_6                         = 6;
const int SMP_SPELL_LEVEL_7                         = 7;
const int SMP_SPELL_LEVEL_8                         = 8;
const int SMP_SPELL_LEVEL_9                         = 9;
*/

// AOEs set thier values (Spell save DC, Caster Level) in locals for better useability
const string SMP_AOE_CASTER_LEVEL       = "SMP_AOE_CASTER_LEVEL";
const string SMP_AOE_SPELL_SAVE_DC      = "SMP_AOE_SPELL_SAVE_DC";
const string SMP_AOE_SPELL_METAMAGIC    = "SMP_AOE_SPELL_METAMAGIC";

// AOEs who have things for On Enter (EG: Acid fog slow) do not stack, but
// are tracked (how many AOE's are affecting the target) via. this local
// integer
const string SMP_SPELL_AOE_AMOUNT = "SMP_SPELL_AOE_AMOUNT";

// Items needed for spells.
// - TAGS!
// All divine focus's tagged...
const string SMP_ITEM_DIVINE_FOCUS          = "SMP_DIV_FOCUS";// Divine Focus Componant.
// However, the ResRef depends on thier alignment.
// Good:
const string SMP_ITEM_RESREF_DIVINE_FOCUS_LAWFUL_GOOD     = "SMP_div_focus_lg";
const string SMP_ITEM_RESREF_DIVINE_FOCUS_NEUTRAL_GOOD    = "SMP_div_focus_ng";
const string SMP_ITEM_RESREF_DIVINE_FOCUS_CHAOTIC_GOOD    = "SMP_div_focus_cg";
// Neutral:
const string SMP_ITEM_RESREF_DIVINE_FOCUS_LAWFUL_NEUTRAL  = "SMP_div_focus_ln";
const string SMP_ITEM_RESREF_DIVINE_FOCUS_NEUTRAL_NEUTRAL = "SMP_div_focus_nn";
const string SMP_ITEM_RESREF_DIVINE_FOCUS_CHAOTIC_NEUTRAL = "SMP_div_focus_cn";
// Evil:
const string SMP_ITEM_RESREF_DIVINE_FOCUS_LAWFUL_EVIL     = "SMP_div_focus_le";
const string SMP_ITEM_RESREF_DIVINE_FOCUS_NEUTRAL_EVIL    = "SMP_div_focus_ne";
const string SMP_ITEM_RESREF_DIVINE_FOCUS_CHAOTIC_EVIL    = "SMP_div_focus_ce";

// Resrefs for Wood Shape items
const string SMP_ITEM_RESREF_WS_CLUB = "SMP_ws_club";// Normal Club. Plot.
const string SMP_ITEM_RESREF_WS_STAFF = "SMP_ws_staff";// Normal Quarterstaff. Plot.
const string SMP_ITEM_RESREF_WS_BOX = "SMP_ws_box";// Normal Box Container. Plot.

// Material Component (IE: Removed on casting) : MC
// Focus item (IE: Just used with casting the spell, but costs money) : F

const string SMP_ITEM_ROPE                  = "SMP_ROPE";       // MC: Animate Rope
const string SMP_ITEM_WATER                 = "SMP_WATER";      // MC: Create Water
const string SMP_ITEM_SPELL_5LS_SILVER      = "SMP_SILVER";     // MC: Bless Water
const string SMP_ITEM_HOLY_SYMBOL_500       = "SMP_HOLYSYM_500";// F: Destruction
const string SMP_ITEM_DIAMOND_DUST          = "SMP_DIAMOND_DUST";// MC: Stoneskin (250GP worth)
const string SMP_ITEM_DIAMOND_DUST_100      = "SMP_DIAMOND_DUST_100";// MC: Restoration (100GP worth)
const string SMP_ITEM_INCENSE_25            = "SMP_INCENSE_25"; // MC: Augury.
const string SMP_ITEM_INCENSE_4000          = "SMP_INCENSE_4000";// MC: Forbiddance
const string SMP_ITEM_RUBY_DUST_1500        = "SMP_RUBYDUST_1500";// MC: Force Cage
const string SMP_ITEM_HOLY_WATER            = "SMP_HOLYWATER";  // MC: Consecrate
const string SMP_ITEM_CURSED_WATER          = "SMP_CURSEDWATER"; // MC: Desecrate
const string SMP_ITEM_SILVER_DUST_25        = "SMP_SILVERDUST_25";// MC2: Consecrate AND Desecrate
const string SMP_ITEM_CHAOS_RELIC_500       = "SMP_CHAOSRELIC_500";// F: Cloak of Chaos
const string SMP_ITEM_HOLY_RELIC_500        = "SMP_HOLYRELIC_500";// F: Holy Aura
const string SMP_ITEM_LAWFUL_RELIC_500      = "SMP_LAWRELIC_500";// F: Shield of Law
const string SMP_ITEM_EVIL_RELIC_500        = "SMP_EVILRELIC_500";// F: Unholy Aura
const string SMP_ITEM_MARKED_STICKS_25      = "SMP_MarkStick_25";// F: Augury
const string SMP_ITEM_DIAMOND_IN_METAL      = "SMP_DiamondMetal";// MC + F: Force Armor
const string SMP_ITEM_WOOD                  = "SMP_WOOD"; // MC: Wood for Wood Shape.
const string SMP_ITEM_RUBY_IN_LOOP_1500     = "SMP_RUBYLOOP_1500";// F: Analyze Dweomer
const string SMP_ITEM_WOLFSKIN              = "SMP_WOLFSKIN";// F: Wolfskin
const string SMP_ITEM_MINATURE_SCALES       = "SMP_MINSCALES";// F: Appraisal. 50GP worth.
const string PHS_ITEM_CRUSHED_BLACK_PEARL   = "SMP_CRUSHPEARL";// MC: Circle of Death: 500GP worth.

// "Made up spells"
const string SMP_ITEM_CRYSTALSHIELD         = "SMP_CRYSTALSHIELD"; // MC for Spellguard

// Acorns and Berries for Fire Seeds
const string SMP_ITEM_HOLLY_BERRIES         = "SMP_HOLLYBERRY";
const string SMP_ITEM_HOLLY_BERRY_BOMBS     = "SMP_HOLLYBOMB";
const string SMP_ITEM_ACORNS                = "SMP_ACORNS";

// Resrefs for "normal"(?) things
const string SMP_ITEM_RESREF_HOLLY_BERRY_BOMBS = "SMP_hollybomb";
const string SMP_ITEM_RESREF_CURSED_WATER   = "SMP_cursedwater";
const string SMP_ITEM_RESREF_HOLY_WATER     = "SMP_holywater";
const string SMP_ITEM_RESREF_FOOD           = "food";
const string SMP_ITEM_RESREF_WATER          = "SMP_water";

// Refuge speciall prepared item
const string SMP_ITEM_SPECIAL_REFUGE        = "SMP_REFUGEITEM";

// Spoiled food
const string SMP_ITEM_SPOILED_FOOD = "SMP_SPOILED_FOOD";
const string SMP_ITEM_SPOILED_WATER = "SMP_SPOILED_FOOD";

// SPECIAL: THE CASTER ITEM!
const string SMP_ITEM_CLASS_ITEM = "SMP_CLASS_ITEM";


// This stores the diamond for each target that they are using for
// protection Versus spells
const string SMP_STORED_PROT_SPELLS_ITEM    = "SMP_STORED_PROT_SPELLS_ITEM";

// AOE constants. All new for these spells.
const int SMP_AOE_PER_ACID_FOG              = 54;// Bioware Fog clouds. 5M radius.
const string SMP_AOE_TAG_PER_ACID_FOG           = "SMP_ACID_FOG";// These are all 2da references
const int SMP_AOE_PER_ALARM                 = 51;// Invisible 6.7M radius.
const string SMP_AOE_TAG_PER_ALARM              = "SMP_ALARM";
const int SMP_AOE_MOB_ANTILIFE_SHELL        = 52;// Green (New VFX) 3.3M radius.
const string SMP_AOE_TAG_MOB_ANTILIFE_SHELL     = "SMP_ANTILIFE_SHELL";
const int SMP_AOE_MOB_ANTIPLANT_SHELL       = 10;// 3.3M radius. As above? affects plants.
const string SMP_AOE_TAG_MOB_ANTIPLANT_SHELL    = "SMP_ANTIPLANT_SHELL";
const int SMP_AOE_PER_EVARDS_BLACK_TENTACLES = 10;// 6.67M radius. Tentacles, black...
const string SMP_AOE_TAG_PER_EVARDS_BLACK_TENTACLES = "SMP_EVARDS_BLACK_TENTACLES";
const int SMP_AOE_PER_BLADE_BARRIER_RECTANGLE = 10;// 10x1M area
const string SMP_AOE_TAG_PER_BLADE_BARRIER_RECTANGLE = "SMP_BLADE_BARRIER_RECTANGLE";
const int SMP_AOE_PER_BLADE_BARRIER_ROUND   = 10;// 3M Sphere, 1.5M radius centre sphere.
const string SMP_AOE_TAG_PER_BLADE_BARRIER_ROUND = "SMP_BLADE_BARRIER_ROUND";
const int SMP_AOE_PER_CALM_EMOTIONS         = 10;// AOE for Concentration.
const string SMP_AOE_TAG_PER_CALM_EMOTIONS      = "SMP_CALM_EMOTIONS";
const int SMP_AOE_PER_CONSECRATE            = 10;// 6.67M radius. Probably invisible - maybe holy aura like.
const string SMP_AOE_TAG_PER_CONSECRATE         = "SMP_CONSECRATE";
const int SMP_AOE_PER_CLOUDKILL             = 10;// 6.7M radius, yellowish and green vapors which look similar to Fog Cloud
const string SMP_AOE_TAG_PER_CLOUDKILL          = "SMP_CLOUDKILL";
const int SMP_AOE_MOB_DARKNESS              = 10;// 6.7M radius, darkness AOE.
const string SMP_AOE_TAG_MOB_DARKNESS           = "SMP_DARKNESS";
const int SMP_AOE_PER_DELAYED_FIREBALL      = 10;// 1.5M radius (or so). Bioware VFX.
const string SMP_AOE_TAG_PER_DELAYED_FIREBALL   = "SMP_DELAYED_FIREBALL";
const int SMP_AOE_PER_DESECRATE             = 10;// 6.67M radius. Probably invisible - maybe unholy aura like.
const string SMP_AOE_TAG_PER_DESECRATE          = "SMP_DESECRATE";
const int SMP_AOE_PER_DIMENSIONAL_LOCK      = 53;// Should have new VFX. 6.7M radius.
const string SMP_AOE_TAG_PER_DIMENSIONAL_LOCK   = "SMP_DIMENSIONAL_LOCK";
const int SMP_AOE_PER_ENTANGLE              = 10;// 13.33M radius spread. Vines and stuff.
const string SMP_AOE_TAG_PER_ENTANGLE           = "SMP_ENTANGLE";
const int SMP_AOE_PER_FOG_CLOUD             = 10;// 6.67M. Fog.
const string SMP_AOE_TAG_PER_FOG_CLOUD          = "SMP_FOG_CLOUD";
const int SMP_AOE_PER_FORBIDDANCE           = 10;// 60M cube (on each side) invisible AOE.
const string SMP_AOE_TAG_PER_FORBIDDANCE        = "SMP_FORBIDDANCE";
const int SMP_AOE_PER_FORCECAGE             = 10;// 6.67M Cube (On a side), invisible.
const string SMP_AOE_TAG_PER_FORCECAGE          = "SMP_FORCECAGE";
const int SMP_AOE_PER_GHOST_SOUND           = 55;// 5M, invisible AOE.
const string SMP_AOE_TAG_PER_GHOST_SOUND        = "SMP_GHOST_SOUND";
const int SMP_AOE_PER_GREASE                = 10;// 3.33M cube area.
const string SMP_AOE_TAG_PER_GREASE             = "SMP_GREASE";
const int SMP_AOE_MOB_HALLUCINATORY_TERRAIN = 10;// 10M cubed AOE.
const string SMP_AOE_TAG_MOB_HALLUCINATORY_TERRAIN = "SMP_HALLUCINATORY_TERRAIN";
const int SMP_AOE_PER_HYPNOTIC_PATTERN      = 10;// 3.33M radius, visual only really.
const string SMP_AOE_TAG_PER_HYPNOTIC_PATTERN   = "SMP_HYPNOTIC_PATTERN";
const int SMP_AOE_PER_INCENDIARY_CLOUD      = 10;// Bioware? 6.67M radius.
const string SMP_AOE_TAG_PER_INCENDIARY_CLOUD   = "SMP_INCENDIARY_CLOUD";
const int SMP_AOE_MOB_INVISIBILITY_PURGE_05 = 10;// 05ft. 01.67M radius. Removes any Invisibility from entering objects.
const int SMP_AOE_MOB_INVISIBILITY_PURGE_10 = 10;// 10ft. 03.33M radius.  " "
const int SMP_AOE_MOB_INVISIBILITY_PURGE_15 = 10;// 15ft. 05.00M radius.  " "
const int SMP_AOE_MOB_INVISIBILITY_PURGE_20 = 10;// 20ft. 06.67M radius.  " "
const int SMP_AOE_MOB_INVISIBILITY_PURGE_25 = 10;// 25ft. 08.33M radius.  " "
const int SMP_AOE_MOB_INVISIBILITY_PURGE_30 = 10;// 30ft. 10.00M radius.  " "
const int SMP_AOE_MOB_INVISIBILITY_PURGE_35 = 10;// 35ft. 11.67M radius.  " "
const int SMP_AOE_MOB_INVISIBILITY_PURGE_40 = 10;// 40ft. 13.33M radius.  " "
const int SMP_AOE_MOB_INVISIBILITY_PURGE_45 = 10;// 45ft. 15.00M radius.  " "
const int SMP_AOE_MOB_INVISIBILITY_PURGE_50 = 10;// 50ft. 16.67M radius.  " "
const string SMP_AOE_TAG_MOB_INVISIBILITY_PURGE_05 = "SMP_INVISIBILITY_PURGE_05";
const string SMP_AOE_TAG_MOB_INVISIBILITY_PURGE_10 = "SMP_INVISIBILITY_PURGE_10";
const string SMP_AOE_TAG_MOB_INVISIBILITY_PURGE_15 = "SMP_INVISIBILITY_PURGE_15";
const string SMP_AOE_TAG_MOB_INVISIBILITY_PURGE_20 = "SMP_INVISIBILITY_PURGE_20";
const string SMP_AOE_TAG_MOB_INVISIBILITY_PURGE_25 = "SMP_INVISIBILITY_PURGE_25";
const string SMP_AOE_TAG_MOB_INVISIBILITY_PURGE_30 = "SMP_INVISIBILITY_PURGE_30";
const string SMP_AOE_TAG_MOB_INVISIBILITY_PURGE_35 = "SMP_INVISIBILITY_PURGE_35";
const string SMP_AOE_TAG_MOB_INVISIBILITY_PURGE_40 = "SMP_INVISIBILITY_PURGE_40";
const string SMP_AOE_TAG_MOB_INVISIBILITY_PURGE_45 = "SMP_INVISIBILITY_PURGE_45";
const string SMP_AOE_TAG_MOB_INVISIBILITY_PURGE_50 = "SMP_INVISIBILITY_PURGE_50";
const int SMP_AOE_MOB_INVISIBILITY_SPHERE   = 10;// 3.33M radius. Applies Invisibility.
const string SMP_AOE_TAG_MOB_INVISIBILITY_SPHERE = "SMP_INVISIBILITY_SPHERE";
const int SMP_AOE_MOB_MAGCIR_CHAOS          = 10;// 3.33M radius. Magic circle against chaos.
const int SMP_AOE_MOB_MAGCIR_EVIL           = 10;// 3.33M radius. Magic circle against evil.
const int SMP_AOE_MOB_MAGCIR_GOOD           = 10;// 3.33M radius. Magic circle against good.
const int SMP_AOE_MOB_MAGCIR_LAW            = 10;// 3.33M radius. Magic circle against law.
const string SMP_AOE_TAG_MOB_MAGCIR_CHAOS       = "SMP_MAGCIR_CHAOS";
const string SMP_AOE_TAG_MOB_MAGCIR_EVIL        = "SMP_MAGCIR_EVIL";
const string SMP_AOE_TAG_MOB_MAGCIR_GOOD        = "SMP_MAGCIR_GOOD";
const string SMP_AOE_TAG_MOB_MAGCIR_LAW         = "SMP_MAGCIR_LAW";
const int SMP_AOE_PER_MIND_FOG              = 10;// 6.67M radius. Mind fog, blue, as Bioware?
const string SMP_AOE_TAG_PER_MIND_FOG           = "SMP_MIND_FOG";
const int SMP_AOE_PER_MISLEAD               = 10;// AOE for Concentration.
const string SMP_AOE_TAG_PER_MISLEAD            = "SMP_MISLEAD";
const int SMP_AOE_MOB_MIRAGE_ARCANA         = 10;// 10M cubed AOE.
const string SMP_AOE_TAG_MOB_MIRAGE_ARCANA      = "SMP_MIRAGE_ARCANA";
const int SMP_AOE_PER_OBSCURING_MIST        = 56;// 6.7M, similar to Acid Fog cloud effect, but MIST
const string SMP_AOE_TAG_PER_OBSCURING_MIST     = "SMP_OBSCURING_MIST";
const int SMP_AOE_PER_PLANT_GROWTH          = 10;// 10.0M, lots of growing, entangling plants. Highish, vineish.
const string SMP_AOE_TAG_PER_PLANT_GROWTH       = "SMP_PLANT_GROWTH";
const int SMP_AOE_PER_PRISMATIC_SPHERE      = 10;// 3.33M radius. Prismatic colored wall.
const string SMP_AOE_TAG_PER_PRISMATIC_SPHERE   = "SMP_PRISMATIC_SPHERE";
const int SMP_AOE_PER_PRISMATIC_WALL        = 10;// 10x1M Wall of colour.
const string SMP_AOE_TAG_PER_PRISMATIC_WALL     = "SMP_PRISMATIC_WALL";
const int SMP_AOE_PER_PYROTECHNICS          = 10;// 6.67M Radius, Big smoke cloud.
const string SMP_AOE_TAG_PER_PYROTECHNICS       = "SMP_PYROTECHNICS";
const int SMP_AOE_PER_RAGE                  = 10;// 0.1M. AOE for concentration.
const string SMP_AOE_TAG_PER_RAGE               = "SMP_RAGE";
const int SMP_AOE_PER_RAINBOW_PATTERN       = 10;// 0.1M. AOE for concentration.
const string SMP_AOE_TAG_PER_RAINBOW_PATTERN    = "SMP_RAINBOW_PATTERN";
const int SMP_AOE_MOB_REPEL_VIRMIN          = 10;// 3.33M. Invisible sphere, like Antilife Shell (invisble!)
const string SMP_AOE_TAG_MOB_REPEL_VIRMIN       = "SMP_REPEL_VIRMIN";
const int SMP_AOE_MOB_REPULSION_1           = 10;// 1M. Invisible.
const int SMP_AOE_MOB_REPULSION_2           = 10;// 2M. Invisible.
const int SMP_AOE_MOB_REPULSION_3           = 10;// 3M. Invisible.
const int SMP_AOE_MOB_REPULSION_4           = 10;// 4M. Invisible.
const int SMP_AOE_MOB_REPULSION_5           = 10;// 5M. Invisible.
const string SMP_AOE_TAG_MOB_REPULSION_1        = "SMP_REPULSION_1";
const string SMP_AOE_TAG_MOB_REPULSION_2        = "SMP_REPULSION_2";
const string SMP_AOE_TAG_MOB_REPULSION_3        = "SMP_REPULSION_3";
const string SMP_AOE_TAG_MOB_REPULSION_4        = "SMP_REPULSION_4";
const string SMP_AOE_TAG_MOB_REPULSION_5        = "SMP_REPULSION_5";
const int SMP_AOE_MOB_SHIELD_OTHER          = 57;// 8M invisible, purly for making srue they stay together.
const string SMP_AOE_TAG_MOB_SHIELD_OTHER      = "SMP_SHIELD_OTHER";
const int SMP_AOE_MOB_SILENCE               = 10;// 6.67M radius. Mobile AND permament
const string SMP_AOE_TAG_MOB_SILENCE           = "SMP_SILENCE";
const int SMP_AOE_PER_SLEET_STORM           = 10;// 13.33M radius, tempoary SNOW
const string SMP_AOE_TAG_PER_SLEET_STORM       = "SMP_SLEET_STORM";
const int SMP_AOE_PER_SOLID_FOG             = 10;// 6.67M radius, fog - solid, more so then Fog Cloud
const string SMP_AOE_TAG_PER_SOLID_FOG         = "SMP_SOLID_FOG";
const int SMP_AOE_PER_SPIKE_GROWTH_10       = 10;// 10x10M cube. Bushy Growth.
const int SMP_AOE_PER_SPIKE_GROWTH_12       = 11;// 12x12M cube. (level 6)
const int SMP_AOE_PER_SPIKE_GROWTH_14       = 12;// 14x14M cube. (level 7)
const int SMP_AOE_PER_SPIKE_GROWTH_16       = 13;// 16x16M cube. (level 8)
const int SMP_AOE_PER_SPIKE_GROWTH_18       = 14;// 18x18M cube. (level 9)
const int SMP_AOE_PER_SPIKE_GROWTH_20       = 15;// 20x20M cube. (level 10)
const string SMP_AOE_TAG_PER_SPIKE_GROWTH_10    = "SMP_SPIKE_GROWTH_10";
const string SMP_AOE_TAG_PER_SPIKE_GROWTH_12    = "SMP_SPIKE_GROWTH_12";
const string SMP_AOE_TAG_PER_SPIKE_GROWTH_14    = "SMP_SPIKE_GROWTH_14";
const string SMP_AOE_TAG_PER_SPIKE_GROWTH_16    = "SMP_SPIKE_GROWTH_16";
const string SMP_AOE_TAG_PER_SPIKE_GROWTH_18    = "SMP_SPIKE_GROWTH_18";
const string SMP_AOE_TAG_PER_SPIKE_GROWTH_20    = "SMP_SPIKE_GROWTH_20";
const int SMP_AOE_PER_SPIKE_STONES_10       = 10;// 10x10M cube. Spiky Stones.
const int SMP_AOE_PER_SPIKE_STONES_12       = 11;// 12x12M cube. (level 6)
const int SMP_AOE_PER_SPIKE_STONES_14       = 12;// 14x14M cube. (level 7)
const int SMP_AOE_PER_SPIKE_STONES_16       = 13;// 16x16M cube. (level 8)
const int SMP_AOE_PER_SPIKE_STONES_18       = 14;// 18x18M cube. (level 9)
const int SMP_AOE_PER_SPIKE_STONES_20       = 15;// 20x20M cube. (level 10)
const string SMP_AOE_TAG_PER_SPIKE_STONES_10    = "SMP_SPIKE_STONES_10";
const string SMP_AOE_TAG_PER_SPIKE_STONES_12    = "SMP_SPIKE_STONES_12";
const string SMP_AOE_TAG_PER_SPIKE_STONES_14    = "SMP_SPIKE_STONES_14";
const string SMP_AOE_TAG_PER_SPIKE_STONES_16    = "SMP_SPIKE_STONES_16";
const string SMP_AOE_TAG_PER_SPIKE_STONES_18    = "SMP_SPIKE_STONES_18";
const string SMP_AOE_TAG_PER_SPIKE_STONES_20    = "SMP_SPIKE_STONES_20";
const int SMP_AOE_PER_STINKING_CLOUD        = 10;// 6.67M radius.
const string SMP_AOE_TAG_PER_STINKING_CLOUD     = "SMP_STINKING_CLOUD";


const int SMP_AOE_PER_STORM_OF_VENGEANCE    = 58;// 120M radius. Needs the new VFX number, else, similar to Bioware's.
const string SMP_AOE_TAG_PER_STORM_OF_VENGEANCE = "SMP_STORM_OF_VENGEANCE";
const int SMP_AOE_PER_SYMBOL_OF_FEAR        = 59;// 3M Radius. Special VFX for symbol.
const string SMP_AOE_TAG_PER_SYMBOL_OF_FEAR     = "SMP_SYMBOL_OF_FEAR";
const int SMP_AOE_PER_TELEPORTATION_CIRCLEI = 60;// 1.7M Radius. Invisible version.
const string SMP_AOE_TAG_PER_TELEPORTATION_CIRCLEI = "SMP_TELEPORTATION_CIRCLEI";
const int SMP_AOE_PER_TELEPORTATION_CIRCLEV = 61;// 1.7M Radius. Visible version.
const string SMP_AOE_TAG_PER_TELEPORTATION_CIRCLEV = "SMP_TELEPORTATION_CIRCLEI";
const int SMP_AOE_PER_WALL_OF_FIRE_05       = 10;// 05M long, 2M wide, wall of fire.
const int SMP_AOE_PER_WALL_OF_FIRE_10       = 10;// 10M long, 2M wide, wall of fire.
const int SMP_AOE_PER_WALL_OF_FIRE_15       = 10;// 15M long, 2M wide, wall of fire.
const int SMP_AOE_PER_WALL_OF_FIRE_20       = 10;// 20M long, 2M wide, wall of fire.
const string SMP_AOE_TAG_PER_WALL_OF_FIRE_05    = "SMP_WALL_OF_FIRE_05";
const string SMP_AOE_TAG_PER_WALL_OF_FIRE_10    = "SMP_WALL_OF_FIRE_10";
const string SMP_AOE_TAG_PER_WALL_OF_FIRE_15    = "SMP_WALL_OF_FIRE_15";
const string SMP_AOE_TAG_PER_WALL_OF_FIRE_20    = "SMP_WALL_OF_FIRE_20";
const int SMP_AOE_PER_WALL_OF_FIRE_ROUND    = 10;// 5M Radius, 3M dougnut wall of fire.
const string SMP_AOE_TAG_PER_WALL_OF_FIRE_ROUND = "SMP_WALL_OF_FIRE_ROUND";
const int SMP_AOE_PER_WALL_OF_THORNS_LEVEL09 = 10;// Wall of thorns, level 9, 9x1M
const int SMP_AOE_PER_WALL_OF_THORNS_LEVEL10 = 10;// Wall of thorns, level 10, 10x1M
const int SMP_AOE_PER_WALL_OF_THORNS_LEVEL11 = 10;// Wall of thorns, level 11, 11x1M
const int SMP_AOE_PER_WALL_OF_THORNS_LEVEL12 = 10;// Wall of thorns, level 12, 12x1M
const int SMP_AOE_PER_WALL_OF_THORNS_LEVEL13 = 10;// Wall of thorns, level 13, 13x1M
const int SMP_AOE_PER_WALL_OF_THORNS_LEVEL14 = 10;// Wall of thorns, level 14, 14x1M
const int SMP_AOE_PER_WALL_OF_THORNS_LEVEL15 = 10;// Wall of thorns, level 15, 15x1M
const int SMP_AOE_PER_WALL_OF_THORNS_ROUND  = 10;// Wall of thorns, round 5M sphere, 3M dougnut.
const string SMP_AOE_TAG_PER_WALL_OF_THORNS_LEVEL09 = "SMP_WALL_OF_THORNS_LEVEL09";
const string SMP_AOE_TAG_PER_WALL_OF_THORNS_LEVEL10 = "SMP_WALL_OF_THORNS_LEVEL10";
const string SMP_AOE_TAG_PER_WALL_OF_THORNS_LEVEL11 = "SMP_WALL_OF_THORNS_LEVEL11";
const string SMP_AOE_TAG_PER_WALL_OF_THORNS_LEVEL12 = "SMP_WALL_OF_THORNS_LEVEL12";
const string SMP_AOE_TAG_PER_WALL_OF_THORNS_LEVEL13 = "SMP_WALL_OF_THORNS_LEVEL13";
const string SMP_AOE_TAG_PER_WALL_OF_THORNS_LEVEL14 = "SMP_WALL_OF_THORNS_LEVEL14";
const string SMP_AOE_TAG_PER_WALL_OF_THORNS_LEVEL15 = "SMP_WALL_OF_THORNS_LEVEL15";
const string SMP_AOE_TAG_PER_WALL_OF_THORNS_ROUND   = "SMP_WALL_OF_THORNS_ROUND";
const int SMP_AOE_PER_WEB                   = 10;// 6.67M radius. Webs, lots of them.
const string SMP_AOE_TAG_PER_WEB                = "SMP_WEB";
const int SMP_AOE_MOB_WHIRLWIND             = 10;// 3.33M radius. Whirlwind, on a special creature.
const string SMP_AOE_TAG_MOB_WHIRLWIND          = "SMP_WHIRLWIND";
const int SMP_AOE_PER_WIND_WALL             = 10;// 5M radius. Invisible, sphere.
const string SMP_AOE_TAG_PER_WIND_WALL          = "SMP_WIND_WALL";
const int SMP_AOE_PER_ZONE_OF_TRUTH         = 10;// 6.67M Radius. Invisible, emination (thus radius)
const string SMP_AOE_TAG_PER_ZONE_OF_TRUTH      = "SMP_ZONE_OF_TRUTH";

// Ability AOE's
const int SMP_AOE_MOB_BABBLE                = 10;// 20M Radius. Invisible?
const string SMP_AOE_TAG_MOB_BABBLE             = "SMP_BABBLE";


// VARIOUS ONES NOT PUT INTO THE SPELLS YET
const int SMP_AOE_PER_ENERGY_FIELD          = 10;// 6.67M Radius, as Acid Fog. Energy cloud. Black.
const string SMP_AOE_TAG_PER_ENERGY_FIELD       = "SMP_ENERGY_FIELD";
const int SMP_AOE_PER_WHATEVER              = 10;// 5M radius, See whatever spell.
const string SMP_AOE_TAG_PER_WHATEVER           = "SMP_WHATEVER";
const int SMP_AOE_MOB_FIGHT_THEME           = 10;// 0.1M radius, HB only, no visual.
const string SMP_AOE_TAG_PER_FIGHT_THEME        = "SMP_FIGHT_THEME";

// New item property constants
const int SMP_IP_CONST_CASTSPELL_GOODBERRY                  = 1;// Self only
const int SMP_IP_CONST_ONHIT_CASTSPELL_DISRUPTING_WEAPON    = 1;// On Hit only
const int SMP_IP_CONST_CASTSPELL_FIRESEED_ACORN             = 1;// Raged attack
const int SMP_IP_CONST_CASTSPELL_REFUGE                     = 1;// Personal only.

// Wild magic constants
// - the applying effects script
const string SMP_WILD_MAGIC_SCRIPT          = "SMP_ail_wildmagc";
// - Set to a LOCATION or OBJECT, the new one that the spell should hit
const string SMP_WILD_MAGIC_OVERRIDE_THING  = "SMP_WILD_MAGIC_OVERRIDE_THING";
// - Set to TRUE if the object/location of the spell has changed
const string SMP_WILD_MAGIC_CHECK           = "SMP_WILD_MAGIC_CHECK";
// - Set to TRUE if a object, else location
const string SMP_WILD_MAGIC_LOCATIONTARGET  = "SMP_WILD_MAGIC_LOCATIONTARGET";


// Other constants

// Object for Maze or Imprisonment
const string SMP_MAZEPRISON_OBJECT      = "SMP_MAZEPRISON_OBJECT";
// Maze target - Tag of waypoint
const string SMP_S_MAZE_TARGET          = "SMP_S_MAZE_TARGET";
// Imprisonment Target - Tag of waypoint
const string SMP_S_IMPRISONMENT_TARGET  = "SMP_S_IMPRISONMENT_TARGET";
// The objects that need to be created
const string SMP_MAZE_OBJECT            = "SMP_maze_marker";
const string SMP_IMPRISONMENT_OBJECT    = "SMP_pris_marker";
// And the variables set on the target to get them back
const string SMP_S_MAZEPRISON_LOCATION  = "SMP_S_MAZEPRISON_LOCATION";
const string SMP_S_MAZEPRISON_OLD_AREA  = "SMP_S_MAZEPRISON_OLD_AREA";
// - Only used in maze below
const string SMP_S_MAZE_ROUND_COUNTER   = "SMP_S_MAZE_ROUND_COUNTER";

/* - Removed for now
// Cloudkill moves! (Creature based, therefore will not upset any sort of walls)
// - Constants set on it for the spell to work
const string SMP_CLOUDKILL_LOCATION     = "SMP_CLOUDKILL_LOCATION";
const string SMP_CLOUDKILL_CASTER       = "SMP_CLOUDKILL_CASTER";
const string SMP_CLOUDKILL_SAVEDC       = "SMP_CLOUDKILL_SAVEDC";
const string SMP_CLOUDKILL_METAMAGIC    = "SMP_CLOUDKILL_METAMAGIC";
const string SMP_CLOUDKILL_DURATION     = "SMP_CLOUDKILL_DURATION";
// Incremented on pesudo-heartbeat
const string SMP_CLOUDKILL_ROUNDS_DONE  = "SMP_CLOUDKILL_ROUNDS_DONE";
// Constant used dynamically on targets. Adds ID of cloudkill object.
const string SMP_CLOUDKILL_6HD_SAVED    = "SMP_CLOUDKILL_6HD_SAVED";
*/

// The integers set for Spell Immunty spell, user choices.
const string SMP_SPELL_IMMUNITY_USER = "SMP_SPELL_IMMUNITY_USER";

// Integer for moving, barriers.
// - If TRUE on enter, it destroys the barrier.
const string SMP_MOVING_BARRIER             = "SMP_MOVING_BARRIER";
// - If TRUE, ignore On Enter events. The barrier starts on the first HB.
const string SMP_MOVING_BARRIER_START       = "SMP_MOVING_BARRIER_START";
// - Mobile barriers last location
const string SMP_MOVING_BARRIER_LOCATION    = "SMP_MOVING_BARRIER_LOCATION";

// These are sound constants. Can use SMP_PlaySounds(int iSoundVariable) with these
// - Used in Ghost Sounds
const int SMP_SOUNDS_HUMAN          = 1;
const int SMP_SOUNDS_HUMAN_LOUD     = 2;
const int SMP_SOUNDS_HUMAN_BATTLE   = 3;
const int SMP_SOUNDS_ORCS           = 4;
const int SMP_SOUNDS_ORCS_MOB       = 5;
const int SMP_SOUNDS_WIND           = 6;
const int SMP_SOUNDS_WIND_LOUD      = 7;
const int SMP_SOUNDS_WIND_GALE      = 8;
const int SMP_SOUNDS_WATER_DRIP     = 9;
const int SMP_SOUNDS_WATER_POOL     = 10;
const int SMP_SOUNDS_WATER_RIVER    = 11;
const int SMP_SOUNDS_RATS           = 12;


// These use AmbientSoundChangeDay/AmbientSoundChangeNight for a bit.
const int SMP_SOUNDS_AREA_WHISPERS  = 100;
const int SMP_SOUNDS_AREA_TALKING   = 101;
const int SMP_SOUNDS_AREA_FIGHTING  = 102;

// String setting (LocalString/Integer) constants for the variable names
const string SMP_GHOST_SOUND_SOUNDS_CUSTOM = "SMP_GHOST_SOUND_SOUNDS_CUSTOM";


/******************************* SPECIAL **************************************/


/******************************* MONSTER ABILITIES ****************************/

const int SMP_SPELLABILITY_BABBLE = 99999;


/******************************* SPELLS ***************************************/

// - If uncommented, the spell is not complete, or no spell script exsists.

/*
    Version number is at the end (IE where it is from) most will be "3.5 Standard"
    for the 3.5 standard ruleset
       - http://3.5srd.com/web/sovelior_sage_srd/Sovelior%20SRD/home.html

    Amounts of spells
    All: 605
A 30
B 22
C 60
D 55
E 18
F 33
G 21
H 29
I 29
J 1
K 3
L 10
M 45
N 3
O 7
P 43
Q 1
R 33
S 103
T 24
U 6
V 5
W 22
X 0
Y 0
Z 2
    14 Apirl - started spells.2da
*/

/*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*/
 // Seperate spells Count: 29
const int SMP_SPELL_ACID_FOG                    = 0;
const int SMP_SPELL_ACID_SPLASH                 = 10000;
const int SMP_SPELL_AID                         = 1;
const int SMP_SPELL_AIR_WALK                    = 10000;
const int SMP_SPELL_ALARM                       = 10000;
const int SMP_SPELL_ALARM_AUDIBLE                   = 10000;
const int SMP_SPELL_ALARM_MESSAGE                   = 10000;
const int SMP_SPELL_ALIGN_WEAPON                = 10000;
const int SMP_SPELL_ALIGN_WEAPON_EVIL               = 10000;
const int SMP_SPELL_ALIGN_WEAPON_GOOD               = 10000;
const int SMP_SPELL_ALIGN_WEAPON_CHAOTIC            = 10000;
const int SMP_SPELL_ALIGN_WEAPON_LAWFUL             = 10000;
const int SMP_SPELL_ALTER_SELF                  = 10000;
const int SMP_SPELL_ANALYZE_DWEOMER             = 10000;
//const int SMP_SPELL_ANIMAL_GROWTH               = 10000;
const int SMP_SPELL_ANIMAL_SHAPES               = 10000;
const int SMP_SPELL_ANIMAL_TRANCE               = 10000;
//const int SMP_SPELL_ANIMATE_DEAD                = 2;
//const int SMP_SPELL_ANIMATE_OBJECTS             = 10000;
//const int SMP_SPELL_ANIMATE_PLANTS              = 10000;
const int SMP_SPELL_ANIMATE_ROPE                = 10000;
const int SMP_SPELL_ANTILIFE_SHELL              = 10000;
//const int SMP_SPELL_ANTIMAGIC_FIELD             = 10000;
//const int SMP_SPELL_ANTIPATHY                   = 10000;
const int SMP_SPELL_ANTIPLANT_SHELL             = 10000;
//const int SMP_SPELL_ARCANE_EYE                  = 10000;
//const int SMP_SPELL_ARCANE_LOCK                 = 10000;
const int SMP_SPELL_ARCANE_MARK                 = 10000;
//const int SMP_SPELL_ARCANE_SIGHT                = 10000;
//const int SMP_SPELL_ARCANE_SIGHT_GREATER        = 10000;
//const int SMP_SPELL_ASTRAL_PROJECTION           = 10000;
//const int SMP_SPELL_ATONEMENT                   = 10000;
const int SMP_SPELL_AUGURY                      = 10000;
const int SMP_SPELL_AWAKEN                      = 10000;

/*BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB*/
 // B Count: 26
const int SMP_SPELL_BALEFUL_POLYMORPH           = 10000;
const int SMP_SPELL_BANE                        = 10000;
//const int SMP_SPELL_BANISHMENT                  = 10000;
const int SMP_SPELL_BARKSKIN                    = 3;
const int SMP_SPELL_BEARS_ENDURANCE             = 10000;
const int SMP_SPELL_BEARS_ENDURANCE_MASS        = 10000;
const int SMP_SPELL_BESTOW_CURSE                = 4;
const int SMP_SPELL_BESTOW_CURSE_ABILITY            = 1601;
const int SMP_SPELL_BESTOW_CURSE_ROLLS              = 1602;
const int SMP_SPELL_BESTOW_CURSE_CHANCE_NO_ACTION   = 1603;
const int SMP_SPELL_BIGBYS_CLENCHED_FIST        = 10000;// Hands use sub-dials for larger ones
const int SMP_SPELL_BIGBYS_CLENCHED_FIST_CLENCHED   = 10001;
const int SMP_SPELL_BIGBYS_CLENCHED_FIST_FORCEFUL   = 10002;
const int SMP_SPELL_BIGBYS_CLENCHED_FIST_INTERPOSING = 10003;
const int SMP_SPELL_BIGBYS_CRUSHING_HAND        = 10004;
const int SMP_SPELL_BIGBYS_CRUSHING_HAND_CRUSHING   = 10005;
const int SMP_SPELL_BIGBYS_CRUSHING_HAND_FORCEFUL   = 10006;
const int SMP_SPELL_BIGBYS_CRUSHING_HAND_INTERPOSING = 10007;
const int SMP_SPELL_BIGBYS_FORCEFUL_HAND        = 10008;
const int SMP_SPELL_BIGBYS_FORCEFUL_HAND_FORCEFUL   = 10009;
const int SMP_SPELL_BIGBYS_FORCEFUL_HAND_INTERPOSING = 10010;
const int SMP_SPELL_BIGBYS_GRASPING_HAND        = 10000;
const int SMP_SPELL_BIGBYS_GRASPING_HAND_GRASPING   = 10000;
const int SMP_SPELL_BIGBYS_GRASPING_HAND_FORCEFUL   = 10000;
const int SMP_SPELL_BIGBYS_GRASPING_HAND_INTERPOSING = 10000;
const int SMP_SPELL_BIGBYS_INTERPOSING_HAND     = 10000;// Only one without a sub-dial

//const int SMP_SPELL_BINDING                     = 10000;
const int SMP_SPELL_BLADE_BARRIER               = 5;
const int SMP_SPELL_BLADE_BARRIER_SQUARE            = 1604;
const int SMP_SPELL_BLADE_BARRIER_ROUND             = 1605;
const int SMP_SPELL_BLASPHEMY                   = 10000;
const int SMP_SPELL_BLESS                       = 6;
const int SMP_SPELL_BLESS_WATER                 = 10000;
const int SMP_SPELL_BLESS_WEAPON                = 10000;
const int SMP_SPELL_BLIGHT                      = 10000;
const int SMP_SPELL_BLINDNESS_DEAFNESS          = 8;
const int SMP_SPELL_BLINDNESS_DEAFNESS_BLIND        = 10000;
const int SMP_SPELL_BLINDNESS_DEAFNESS_DEAF         = 10000;
const int SMP_SPELL_BLINK                       = 10000;
const int SMP_SPELL_BLUR                        = 10000;
const int SMP_SPELL_BREAK_ENCHANTMENT           = 10000;
const int SMP_SPELL_BULLS_STRENGTH              = 9;
const int SMP_SPELL_BULLS_STRENGTH_MASS         = 10000;
const int SMP_SPELL_BURNING_HANDS               = 10;

/*CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC*/

const int SMP_SPELL_CALL_LIGHTNING              = 11;
const int SMP_SPELL_CALL_LIGHTNING_STORM        = 10000;
const int SMP_SPECIAL_CALL_BOLT_LIGHTNING           = 1608;
const int SMP_SPELL_CALM_ANIMALS                = 10000;
const int SMP_SPELL_CALM_EMOTIONS               = 10000;
const int SMP_SPELL_CATS_GRACE                  = 10000;
const int SMP_SPELL_CATS_GRACE_MASS             = 10000;
const int SMP_SPELL_CAUSE_FEAR                  = 10500;
const int SMP_SPELL_CHAIN_LIGHTNING             = 10000;
const int SMP_SPELL_CHANGESTAFF                 = 10000;
const int SMP_SPELL_CHAOS_HAMMER                = 10000;
const int SMP_SPELL_CHARM_ANIMAL                = 10000;
const int SMP_SPELL_CHARM_MONSTER               = 10000;
const int SMP_SPELL_CHARM_MONSTER_MASS          = 10000;
const int SMP_SPELL_CHARM_PERSON                = 10000;
const int SMP_SPELL_CHILL_METAL                 = 10000;
const int SMP_SPELL_CHILL_TOUCH                 = 10000;
const int SMP_SPELL_CIRCLE_OF_DEATH             = 10000;
//const int SMP_SPELL_CLAIRAUDIENCE_CLAIRVOYANCE  = 10000;
const int SMP_SPELL_CLOAK_OF_CHAOS              = 10000;
//const int SMP_SPELL_CLONE                       = 10000;
const int SMP_SPELL_CLOUDKILL                   = 10000;
const int SMP_SPELL_COLOR_SPRAY                 = 10000;
const int SMP_SPELL_COMMAND                     = 10000;
//const int SMP_SPELL_COMMAND_GREATER             = 10000;
//const int SMP_SPELL_COMMAND_PLANTS              = 10000;
//const int SMP_SPELL_COMMAND_UNDEAD              = 10000;
//const int SMP_SPELL_COMMUNE                     = 10000;
//const int SMP_SPELL_COMMUNE_WITH_NATURE         = 10000;
//const int SMP_SPELL_COMPREHEND_LANGUAGES        = 10000;
const int SMP_SPELL_CONE_OF_COLD                = 10000;
const int SMP_SPELL_CONFUSION                   = 10000;
const int SMP_SPELL_CONFUSION_LESSER            = 10000;
const int SMP_SPELL_CONSECRATE                  = 10000;
//const int SMP_SPELL_CONTACT_OTHER_PLANE         = 10000;
//const int SMP_SPELL_CONTAGION                   = 10000;
//const int SMP_SPELL_CONTINGENCY                 = 10000;
//const int SMP_SPELL_CONTINUAL_FLAME             = 10000;
//const int SMP_SPELL_CONTROL_PLANTS              = 10000;
//const int SMP_SPELL_CONTROL_UNDEAD              = 10000;
//const int SMP_SPELL_CONTROL_WATER               = 10000;
const int SMP_SPELL_CONTROL_WEATHER             = 10000;
const int SMP_SPELL_CONTROL_WEATHER_RAIN            = 10001;
const int SMP_SPELL_CONTROL_WEATHER_SNOW            = 10002;
const int SMP_SPELL_CONTROL_WEATHER_CLEAR           = 10003;
//const int SMP_SPELL_CONTROL_WINDS               = 10000;
//const int SMP_SPELL_CREATE_FOOD_AND_WATER       = 10000;
//const int SMP_SPELL_CREATE_GREATER_UNDEAD       = 10000;
//const int SMP_SPELL_CREATE_UNDEAD               = 10000;
const int SMP_SPELL_CREATE_WATER                = 10000;
const int SMP_SPELL_CREATE_WATER_BOTTLE             = 10000;
const int SMP_SPELL_CREATE_WATER_VISUAL             = 10000;
const int SMP_SPELL_CREATE_WATER_EXTINGUISH         = 10000;
//const int SMP_SPELL_CREEPING_DOOM               = 10000;
const int SMP_SPELL_CRUSHING_DISPARE            = 10000;
const int SMP_SPELL_CURE_CRITICAL_WOUNDS        = 10000;
const int SMP_SPELL_CURE_CRITICAL_WOUNDS_MASS   = 10000;
const int SMP_SPELL_CURE_LIGHT_WOUNDS           = 10000;
const int SMP_SPELL_CURE_LIGHT_WOUNDS_MASS      = 10000;
const int SMP_SPELL_CURE_MINOR_WOUNDS           = 10000;
const int SMP_SPELL_CURE_MODERATE_WOUNDS        = 10000;
const int SMP_SPELL_CURE_MODERATE_WOUNDS_MASS   = 10000;
const int SMP_SPELL_CURE_SERIOUS_WOUNDS         = 10000;
const int SMP_SPELL_CURE_SERIOUS_WOUNDS_MASS    = 10000;
const int SMP_SPELL_CURSE_WATER                 = 10000;

/*DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD*/

const int SMP_SPELL_DANCING_LIGHTS              = 1509;
const int SMP_SPELL_DARKNESS                    = 10000;
//const int SMP_SPELL_DARKVISION                  = 10000;
//const int SMP_SPELL_DAYLIGHT                    = 10000;
const int SMP_SPELL_DAZE                        = 10000;
const int SMP_SPELL_DAZE_MONSTER                = 10000;
const int SMP_SPELL_DEATH_KNELL                 = 10000;
const int SMP_SPELL_DEATH_WARD                  = 10000;
const int SMP_SPELL_DEATHWATCH                  = 10000;
const int SMP_SPELL_DEEP_SLUMBER                = 10000;
//const int SMP_SPELL_DEEPER_DARKNESS             = 10000;
const int SMP_SPELL_DELAY_POISON                = 10000;
const int SMP_SPELL_DELAYED_BLAST_FIREBALL      = 10000;
//const int SMP_SPELL_DEMAND                      = 10000;
const int SMP_SPELL_DESECRATE                   = 10000;
const int SMP_SPELL_DESTRUCTION                 = 10000;
//const int SMP_SPELL_DETECT_ANIMALS_OR_PLANTS    = 10000;
//const int SMP_SPELL_DETECT_CHAOS                = 10000;
//const int SMP_SPELL_DETECT_EVIL                 = 10000;
//const int SMP_SPELL_DETECT_GOOD                 = 10000;
//const int SMP_SPELL_DETECT_LAW                  = 10000;
//const int SMP_SPELL_DETECT_MAGIC                = 10000;
const int SMP_SPELL_DETECT_POISON               = 10000;
//const int SMP_SPELL_DETECT_SCRYING              = 10000;
//const int SMP_SPELL_DETECT_SECRET_DOORS         = 10000;
//const int SMP_SPELL_DETECT_SNARES_AND_PITS      = 10000;
//const int SMP_SPELL_DETECT_THOUGHTS             = 10000;
//const int SMP_SPELL_DETECT_UNDEAD               = 10000;
const int SMP_SPELL_DICTUM                      = 10000;
const int SMP_SPELL_DIMENSION_DOOR              = 1510;
const int SMP_SPELL_DIMENSIONAL_ANCHOR          = -10456;
const int SMP_SPELL_DIMENSIONAL_LOCK            = -10122;
//const int SMP_SPELL_DIMINISH_PLANTS             = 10000;
//const int SMP_SPELL_DISCERN_LIES                = 10000;
//const int SMP_SPELL_DISCERN_LOCATION            = 10000;
//const int SMP_SPELL_DISGUISE_SELF               = 10000;
const int SMP_SPELL_DISINTEGRATE                = 1511;
const int SMP_SPELL_DISMISSAL                   = 10000;
const int SMP_SPELL_DISPEL_CHAOS                = 10000;
const int SMP_SPELL_DISPEL_EVIL                 = 10000;
const int SMP_SPELL_DISPEL_GOOD                 = 10000;
const int SMP_SPELL_DISPEL_LAW                  = 10000;
const int SMP_SPELL_DISPEL_MAGIC                = 10000;
const int SMP_SPELL_DISPEL_MAGIC_GREATER        = 10000;
const int SMP_SPELL_DISPLACEMENT                = 11200;
const int SMP_SPELL_DISRUPT_UNDEAD              = -10222;
const int SMP_SPELL_DISRUPTING_WEAPON           = 10000;
//const int SMP_SPELL_DIVINATION                  = 10000;
const int SMP_SPELL_DIVINE_FAVOR                = 10000;
const int SMP_SPELL_DIVINE_POWER                = 10000;
//const int SMP_SPELL_DOMINATE_ANIMAL             = 10000;
const int SMP_SPELL_DOMINATE_PERSON             = 10000;
const int SMP_SPELL_DOMINATE_MONSTER            = 10000;
const int SMP_SPELL_DOOM                        = -10444;
//const int SMP_SPELL_DREAM                       = 10000;

/*EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE*/

const int SMP_SPELL_EAGLES_SPLENDOR             = 10000;
const int SMP_SPELL_EAGLES_SPLENDOR_MASS        = 10000;
const int SMP_SPELL_EARTHQUAKE                  = 10000;
//const int SMP_SPELL_ELEMENTAL_SWARM             = 10000;
const int SMP_SPELL_ENDURE_ELEMENTS             = 10000;
const int SMP_SPELL_ENERGY_DRAIN                = 10000;
const int SMP_SPELL_ENERVATION                  = 10000;
//const int SMP_SPELL_ENLARGE_PERSON              = 10000;
//const int SMP_SPELL_ENLARGE_PERSON_MASS         = 10000;
const int SMP_SPELL_ENTANGLE                    = 10000;
//const int SMP_SPELL_ENTHRALL                    = 10000;
const int SMP_SPELL_ENTROPIC_SHIELD             = 10000;
const int SMP_SPELL_ERASE                       = 10000;
const int SMP_SPELL_ETHEREAL_JAUNT              = 10000;
const int SMP_SPELL_ETHEREALNESS                = 10000;
const int SMP_SPELL_EVARDS_BLACK_TENTACLES      = 10000;
const int SMP_SPELL_EXPEDITIOUS_RETREAT         = 10000;
const int SMP_SPELL_EXPLOSIVE_RUNES             = 10000;
const int SMP_SPELL_EYEBITE                     = -10666;

/*FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF*/

//const int SMP_SPELL_FABRICATE                   = 10000;
const int SMP_SPELL_FAERIE_FIRE                 = 10100;
const int SMP_SPELL_FALSE_LIFE                  = 10000;
//const int SMP_SPELL_FALSE_VISION                = 10000;
const int SMP_SPELL_FEAR                        = -10555;
//const int SMP_SPELL_FEATHER_FALL                = 10000;
const int SMP_SPELL_FEEBLEMIND                  = 10012;
const int SMP_SPELL_FIND_THE_PATH               = 10000;
const int SMP_SPELL_FIND_TRAPS                  = 10000;
const int SMP_SPELL_FINGER_OF_DEATH             = 10000;
const int SMP_SPELL_FIRE_SEEDS                  = 10000;
const int SMP_SPELL_FIRE_SHIELD                 = 10000;
const int SMP_SPELL_FIRE_SHIELD_WARM                = 10000;
const int SMP_SPELL_FIRE_SHIELD_CHILL               = -10000;
const int SMP_SPELL_FIRE_STORM                  = 10000;
//const int SMP_SPELL_FIRE_TRAP                   = 10000;
const int SMP_SPELL_FIREBALL                    = 10000;
const int SMP_SPELL_FLAME_ARROW                 = 10000;
const int SMP_SPELL_FLAME_STRIKE                = 10000;
//const int SMP_SPELL_FLAMING_SPHERE              = 10000;
const int SMP_SPELL_FLARE                       = 10111;
const int SMP_SPELL_FLESH_TO_STONE              = 10000;
const int SMP_SPELL_FLY                         = 10000;
const int SMP_SPELL_FLOATING_DISK               = 10000;
const int SMP_SPELL_FOG_CLOUD                   = 10000;
const int SMP_SPELL_FORBIDDANCE                 = 10000;
const int SMP_SPELL_FORCECAGE                   = 10000;
const int SMP_SPELL_FORESIGHT                   = 10000;
const int SMP_SPELL_FOXS_CUNNING                = 10000;
const int SMP_SPELL_FOXS_CUNNING_MASS           = 10000;
const int SMP_SPELL_FREEDOM                     = 10000;
const int SMP_SPELL_FREEDOM_OF_MOVEMENT         = 10000;
const int SMP_SPELL_FREEZING_SPHERE             = 10000;

/*GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG*/

const int SMP_SPELL_GASEOUS_FORM                = 10000;
//const int SMP_SPELL_GATE                        = 10000;
//const int SMP_SPELL_GEAS                        = 10000;
//const int SMP_SPELL_GEAS_LESSER                 = 10000;
//const int SMP_SPELL_GENTLE_REPOSE               = 10000;
const int SMP_SPELL_GHOST_SOUND                 = 10000;
const int SMP_SPELL_GHOST_SOUND_HUMANS              = 10001;
const int SMP_SPELL_GHOST_SOUND_ORCS                = 10002;
const int SMP_SPELL_GHOST_SOUND_RATS                = 10003;
const int SMP_SPELL_GHOST_SOUND_WIND                = 10004;
const int SMP_SPELL_GHOST_SOUND_CUSTOM              = 10005;
const int SMP_SPELL_GHOUL_TOUCH                 = 10000;
//const int SMP_SPELL_GIANT_VERMIN                = 10000;
const int SMP_SPELL_GLIBNESS                    = 10000;
const int SMP_SPELL_GLITTERDUST                 = 10000;
const int SMP_SPELL_GLOBE_OF_INVUNRABILITY        = 10000;
const int SMP_SPELL_GLOBE_OF_INVUNRABILITY_LESSER = 10000;
//const int SMP_SPELL_GLYPH_OF_WARDING            = 10000;
//const int SMP_SPELL_GLYPH_OF_WARDING_GREATER    = 10000;
const int SMP_SPELL_GOODBERRY                   = 10000;
const int SMP_SPELL_GOOD_HOPE                   = 10000;
const int SMP_SPELL_GREASE                      = 10000;
//const int SMP_SPELL_GUARDS_AND_WARDS            = 10000;
const int SMP_SPELL_GUIDANCE                    = 10000;
const int SMP_SPELL_GUIDANCE_ATTACK                 = 10000;
const int SMP_SPELL_GUIDANCE_SAVE                   = 10000;
const int SMP_SPELL_GUIDANCE_SKILL                  = 10000;
const int SMP_SPELL_GUST_OF_WIND                = 10000;

/*HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH*/

//const int SMP_SPELL_HALLOW                      = 10000;
const int SMP_SPELL_HALLUCINATORY_TERRAIN       = 10000;
const int SMP_SPELL_HALT_UNDEAD                 = 10000;
const int SMP_SPELL_HARM                        = 10000;
const int SMP_SPELL_HASTE                       = 10000;
const int SMP_SPELL_HEAL                        = 10000;
const int SMP_SPELL_HEAL_MASS                   = 10000;
const int SMP_SPELL_HEAL_MOUNT                  = 10000;
const int SMP_SPELL_HEAT_METAL                  = 10000;
//const int SMP_SPELL_HELPING_HAND                = 10000;
//const int SMP_SPELL_HEROES_FEAST                = 10000;
const int SMP_SPELL_HEROISM                     = 10000;
const int SMP_SPELL_HEROISM_GREATER             = 10000;
const int SMP_SPELL_HIDE_FROM_ANIMALS           = 10000;
const int SMP_SPELL_HIDE_FROM_UNDEAD            = 10000;
const int SMP_SPELL_HIDEOUS_LAUGHTER            = 10000;
const int SMP_SPELL_HOLD_ANIMAL                 = 10000;
const int SMP_SPELL_HOLD_MONSTER                = 10000;
const int SMP_SPELL_HOLD_MONSTER_MASS           = 10000;
const int SMP_SPELL_HOLD_PERSON                 = 10000;
const int SMP_SPELL_HOLD_PERSON_MASS            = 10000;
//const int SMP_SPELL_HOLD_PORTAL                 = 10000;
const int SMP_SPELL_HOLY_AURA                   = 10000;
const int SMP_SPELL_HOLY_SMITE                  = 10000;
const int SMP_SPELL_HOLY_SWORD                  = 10000;
const int SMP_SPELL_HOLY_WORD                   = 10000;
const int SMP_SPELL_HORRID_WILTING              = 10000;
const int SMP_SPELL_HYPNOTIC_PATTERN            = 10000;
const int SMP_SPELL_HYPNOTISM                   = 10078;

/*IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII*/

const int SMP_SPELL_ICE_STORM                   = 10000;
const int SMP_SPELL_IDENTIFY                    = 10000;
//const int SMP_SPELL_ILLUSORY_SCRIPT             = 10000;
//const int SMP_SPELL_ILLUSORY_WALL               = 10000;
//const int SMP_SPELL_IMBUNE_WITH_SPELL_ABILITY   = 10000;
const int SMP_SPELL_IMPLOSION                   = 10000;
const int SMP_SPELL_IMPRISONMENT                = 10000;
const int SMP_SPELL_INCENDIARY_CLOUD            = 10000;
const int SMP_SPELL_INFLICT_CRITICAL_WOUNDS     = 10000;
const int SMP_SPELL_INFLICT_CRITICAL_WOUNDS_MASS = 10000;
const int SMP_SPELL_INFLICT_LIGHT_WOUNDS        = 10000;
const int SMP_SPELL_INFLICT_LIGHT_WOUNDS_MASS   = 10000;
const int SMP_SPELL_INFLICT_MINOR_WOUNDS        = 10000;
const int SMP_SPELL_INFLICT_MODERATE_WOUNDS     = 10000;
const int SMP_SPELL_INFLICT_MODERATE_WOUNDS_MASS = 10000;
const int SMP_SPELL_INFLICT_SERIOUS_WOUNDS      = 10000;
const int SMP_SPELL_INFLICT_SERIOUS_WOUNDS_MASS = 10000;
const int SMP_SPELL_INSANITY                    = 10000;
const int SMP_SPELL_INSECT_PLAGUE               = 10000;
//const int SMP_SPELL_INSTANT_SUMMONS             = 10000;
const int SMP_SPELL_INVISIBILITY                = 10000;
const int SMP_SPELL_INVISIBILITY_GREATER        = 10000;
//const int SMP_SPELL_INVISIBILITY_MASS           = 10000;
const int SMP_SPELL_INVISIBILITY_PURGE          = 10000;
const int SMP_SPELL_INVISIBILITY_SPHERE         = 10000;
const int SMP_SPELL_IRON_BODY                   = 10000;
//const int SMP_SPELL_IRONWOOD                    = 10000;
const int SMP_SPELL_IRRESISTIBLE_DANCE          = 10800;

/*JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ*/

//const int SMP_SPELL_JUMP                        = 10000;

/*KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK*/

const int SMP_SPELL_KEEN_EDGE                   = 10000;
const int SMP_SPELL_KNOCK                       = 10000;
const int SMP_SPELL_KNOW_DIRECTION              = 10000;

/*LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL*/

//const int SMP_SPELL_LEGEND_LORE                 = 10000;
//const int SMP_SPELL_LEVITATE                    = 10000;
const int SMP_SPELL_LIGHT                       = 10000;
//const int SMP_SPELL_LIGHTNING_BOLT              = 10000;
//const int SMP_SPELL_LIMITED_WISH                = 10000;
const int SMP_SPELL_LIVEOAK                     = 10000;
//const int SMP_SPELL_LOCATE_CREATURE             = 10000;
//const int SMP_SPELL_LOCATE_OBJECT               = 10000;
const int SMP_SPELL_LONGSTRIDER                 = 10000;
const int SMP_SPELL_LULLABY                     = 10000;

/*MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM*/

const int SMP_SPELL_MAGE_ARMOR                  = 10000;
const int SMP_SPELL_MAGE_HAND                   = 10000;
const int SMP_SPELL_MAGES_DISJUNCTION           = 10000;
//const int SMP_SPELL_MAGES_FAITHFUL_HOUND        = 10000;
//const int SMP_SPELL_MAGES_LUCUBRATION           = 10000;
//const int SMP_SPELL_MAGES_MAGNIFICENT_MANSION   = 10000;
//const int SMP_SPELL_MAGES_PRIVATE_SANCTUM       = 10000;
const int SMP_SPELL_MAGES_SWORD                 = 10000;
//const int SMP_SPELL_MAGIC_AURA                  = 10000;
const int SMP_SPELL_MAGIC_CIRCLE_AGAINST_CHAOS  = 10000;
const int SMP_SPELL_MAGIC_CIRCLE_AGAINST_EVIL   = 10000;
const int SMP_SPELL_MAGIC_CIRCLE_AGAINST_GOOD   = 10000;
const int SMP_SPELL_MAGIC_CIRCLE_AGAINST_LAW    = 10000;
const int SMP_SPELL_MAGIC_FANG                  = 10000;
const int SMP_SPELL_MAGIC_FANG_GREATER          = 10000;
const int SMP_SPELL_MAGIC_FANG_GREATER_ALL          = 10000;
const int SMP_SPELL_MAGIC_FANG_GREATER_ONE          = 10000;
//const int SMP_SPELL_MAGIC_JAR                   = 10000;
const int SMP_SPELL_MAGIC_MISSILE               = 10000;
//const int SMP_SPELL_MAGIC_MOUTH                 = 10000;
const int SMP_SPELL_MAGIC_STONE                 = 10000;
const int SMP_SPELL_MAGIC_VESTMENT              = 10000;
const int SMP_SPELL_MAGIC_WEAPON                = 10000;
const int SMP_SPELL_MAGIC_WEAPON_GREATER        = 10000;
//const int SMP_SPELL_MAJOR_CREATION              = 10000;
//const int SMP_SPELL_MAJOR_IMAGE                 = 10000;
//const int SMP_SPELL_MAKE_WHOLE                  = 10000;
const int SMP_SPELL_MARK_OF_JUSTICE             = 10000;
const int SMP_SPELL_MAZE                        = 10000;
const int SMP_SPELL_MELD_INTO_STONE             = 10000;
const int SMP_SPELL_MELFS_ACID_ARROW            = 10000;
//const int SMP_SPELL_MENDING                     = 10000;
//const int SMP_SPELL_MESSAGE                     = 10000;
const int SMP_SPELL_METEOR_SWARM                = 10000;
const int SMP_SPELL_MIND_BLANK                  = 10000;
const int SMP_SPELL_MIND_FOG                    = 10000;
//const int SMP_SPELL_MINOR_CREATION              = 10000;
//const int SMP_SPELL_MINOR_IMAGE                 = 10000;
//const int SMP_SPELL_MIRACLE_EVOCATION           = 10000;
const int SMP_SPELL_MIRAGE_ARCANA               = 10000;
const int SMP_SPELL_MIRROR_IMAGE                = 10000;
//const int SMP_SPELL_MISDIRECTION                = 10000;
const int SMP_SPELL_MISLEAD                     = 10000;
//const int SMP_SPELL_MNEMONIC_ENHANCER           = 10000;
const int SMP_SPELL_MODIFY_MEMORY               = 10000;
const int SMP_SPELL_MOMENT_OF_PRESCIENCE        = 10000;
const int SMP_SPELL_MOUNT                       = 10000;

// XXX : THIS SPELL MIGHT BE TOTALLY REMOVED.
//const int SMP_SPELL_MOVE_EARTH                  = 10000;

/*NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN*/

const int SMP_SPELL_NEUTRALIZE_POISON           = 10000;
//const int SMP_SPELL_NIGHTMARE                   = 10000;
//const int SMP_SPELL_NONDETECTION                = 10000;

/*OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO*/

const int SMP_SPELL_OBSCURE_OBJECT              = 10000;
const int SMP_SPELL_OBSCURING_MIST              = 10000;
const int SMP_SPELL_OPEN_CLOSE                  = 10000;
const int SMP_SPELL_ORDERS_WRATH                = 10000;
const int SMP_SPELL_OVERLAND_FLIGHT             = 10000;
const int SMP_SPELL_OWLS_WISDOM                 = 10000;
const int SMP_SPELL_OWLS_WISDOM_MASS            = 10000;

/*PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP*/

const int SMP_SPELL_PASSWALL                    = 10000;
const int SMP_SPELL_PASS_WITHOUT_TRACE          = 10000;
//const int SMP_SPELL_PERMANENCY                  = 10000;
//const int SMP_SPELL_PERMANENT_IMAGE             = 10000;
//const int SMP_SPELL_PERSISTENT_IMAGE            = 10000;
const int SMP_SPELL_PHANTASMAL_KILLER           = 10000;
//const int SMP_SPELL_PHANTOM_STEED               = 10000;
//const int SMP_SPELL_PHANTOM_TRAP                = 10000;
const int SMP_SPELL_PHASE_DOOR                  = 10000;
//const int SMP_SPELL_PLANAR_ALLY                 = 10000;
//const int SMP_SPELL_PLANAR_ALLY_GREATER         = 10000;
//const int SMP_SPELL_PLANAR_ALLY_LESSER          = 10000;
//const int SMP_SPELL_PLANAR_BINDING              = 10000;
//const int SMP_SPELL_PLANAR_BINDING_GREATER      = 10000;
//const int SMP_SPELL_PLANAR_BINDING_LESSER       = 10000;
//const int SMP_SPELL_PLANE_SHIFT                 = 10000;
const int SMP_SPELL_PLANT_GROWTH                = 10000;
const int SMP_SPELL_POISON                      = 10000;
const int SMP_SPELL_POLAR_RAY                   = 10000;
//const int SMP_SPELL_POLYMORPH                   = 10000;
//const int SMP_SPELL_POLYMORPH_ANY_OBJECT        = 10000;
const int SMP_SPELL_POWER_WORD_BLIND            = 10000;
const int SMP_SPELL_POWER_WORD_KILL             = 10000;
const int SMP_SPELL_POWER_WORD_STUN             = 10000;
const int SMP_SPELL_PRAYER                      = 10000;
const int SMP_SPELL_PRESTIDIGITATION            = 10000;
const int SMP_SPELL_PRESTIDIGITATION_VFX1           = 10001;
const int SMP_SPELL_PRESTIDIGITATION_VFX2           = 10002;
const int SMP_SPELL_PRESTIDIGITATION_VFX3           = 10003;
const int SMP_SPELL_PRESTIDIGITATION_VFX4           = 10004;
const int SMP_SPELL_PRESTIDIGITATION_VFX5           = 10005;
const int SMP_SPELL_PRISMATIC_SPHERE            = 10000;
const int SMP_SPELL_PRISMATIC_SPRAY             = 10000;
const int SMP_SPELL_PRISMATIC_WALL              = 10000;
const int SMP_SPELL_PRODUCE_FLAME               = 10000;
//const int SMP_SPELL_PROGRAMMED_IMAGE            = 10000;
//const int SMP_SPELL_PROJECT_IMAGE               = 10000;
const int SMP_SPELL_PROTECTION_FROM_ARROWS      = 10000;
const int SMP_SPELL_PROTECTION_FROM_CHAOS       = 10000;
const int SMP_SPELL_PROTECTION_FROM_ENERGY      = 10000;
const int SMP_SPELL_PROTECTION_FROM_ENERGY_ACID     = 10001;
const int SMP_SPELL_PROTECTION_FROM_ENERGY_COLD     = 10002;
const int SMP_SPELL_PROTECTION_FROM_ENERGY_ELECTRICAL = 10003;
const int SMP_SPELL_PROTECTION_FROM_ENERGY_FIRE     = 10004;
const int SMP_SPELL_PROTECTION_FROM_ENERGY_SONIC    = 10005;
const int SMP_SPELL_PROTECTION_FROM_EVIL        = 10000;
const int SMP_SPELL_PROTECTION_FROM_GOOD        = 10000;
const int SMP_SPELL_PROTECTION_FROM_LAW         = 10000;
const int SMP_SPELL_PROTECTION_FROM_SPELLS      = 10000;
//const int SMP_SPELL_PRYING_EYES                 = 10000;
//const int SMP_SPELL_PRYING_EYES_GREATER         = 10000;
const int SMP_SPELL_PURIFY_FOOD_AND_DRINK       = 10000;
const int SMP_SPELL_PYROTECHNICS                = 10000;

/*QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ*/

const int SMP_SPELL_QUENCH                      = 10000;

/*RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR*/

const int SMP_SPELL_RAGE                        = 10000;
const int SMP_SPELL_RAINBOW_PATTERN             = 10999;
const int SMP_SPELL_RAISE_DEAD                  = 10000;
const int SMP_SPELL_RAY_OF_ENFEEBLEMENT         = 10000;
const int SMP_SPELL_RAY_OF_EXHAUSTION           = 10000;// Odd, needed to add this in...
const int SMP_SPELL_RAY_OF_FROST                = 10000;
const int SMP_SPELL_READ_MAGIC                  = 10000;
const int SMP_SPELL_REFUGE                      = 10000;
const int SMP_SPELL_REGENERATE                  = 10000;
//const int SMP_SPELL_REINCARNATE                 = 10000;
const int SMP_SPELL_REMOVE_BLINDNESS_DEAFNESS   = 10000;
const int SMP_SPELL_REMOVE_BLINDNESS_DEAFNESS_A     = 10000;// : Blindness
const int SMP_SPELL_REMOVE_BLINDNESS_DEAFNESS_B     = 10000;// : Deafness
const int SMP_SPELL_REMOVE_CURSE                = 10000;
const int SMP_SPELL_REMOVE_DISEASE              = 10000;
const int SMP_SPELL_REMOVE_FEAR                 = 10000;
const int SMP_SPELL_REMOVE_PARALYSIS            = 10000;
//const int SMP_SPELL_REPEL_METAL_OR_STONE        = 10000;
const int SMP_SPELL_REPEL_VIRMIN                = 10000;
//const int SMP_SPELL_REPEL_WOOD                  = 10000;
const int SMP_SPELL_REPULSION                   = 10000;
const int SMP_SPELL_RESILIENT_SPHERE            = 10000;
const int SMP_SPELL_RESISTANCE                  = 10000;
const int SMP_SPELL_RESIST_ENERGY               = 10000;
const int SMP_SPELL_RESIST_ENERGY_ACID              = 10001;
const int SMP_SPELL_RESIST_ENERGY_COLD              = 10002;
const int SMP_SPELL_RESIST_ENERGY_ELECTRICAL        = 10003;
const int SMP_SPELL_RESIST_ENERGY_FIRE              = 10004;
const int SMP_SPELL_RESIST_ENERGY_SONIC             = 10005;
const int SMP_SPELL_RESTORATION                 = 10000;
const int SMP_SPELL_RESTORATION_GREATER         = 10000;
const int SMP_SPELL_RESTORATION_LESSER          = 10000;
const int SMP_SPELL_RESSURECTION                = 10000;
//const int SMP_SPELL_REVERSE_GRAVITY             = 10000;
const int SMP_SPELL_RIGHTEOUS_MIGHT             = 10000;
const int SMP_SPELL_ROPE_TRICK                  = 10000;
const int SMP_SPELL_RUSTING_GRASP               = 10000;
const int SMP_SPELL_RUSTING_GRASP_ARMOR             = 10001;
const int SMP_SPELL_RUSTING_GRASP_WEAPON            = 10002;

/*SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS*/

const int SMP_SPELL_SANCTUARY                   = 10000;
const int SMP_SPELL_SCARE                       = -10012;
const int SMP_SPELL_SCINTILLATING_PATTERN       = 10000;
const int SMP_SPELL_SCORCHING_RAY               = 10000;
//const int SMP_SPELL_SCREEN                      = 10000;
//const int SMP_SPELL_SCRYING                     = 10000;
//const int SMP_SPELL_SCRYING_GREATER             = 10000;
const int SMP_SPELL_SCULPT_SOUND                = 10000;
const int SMP_SPELL_SEARING_LIGHT               = 10000;
//const int SMP_SPELL_SECRET_CHEST                = 10000;
//const int SMP_SPELL_SECRET_PAGE                 = 10000;
//const int SMP_SPELL_SECURE_SHELTER              = 10000;
const int SMP_SPELL_SEE_INVISIBILITY            = 10000;
//const int SMP_SPELL_SEEMING                     = 10000;
//const int SMP_SPELL_SENDING                     = 10000;
//const int SMP_SPELL_SEPIA_SNAKE_SIGIL           = 10000;
//const int SMP_SPELL_SEQUESTER                   = 10000;
//const int SMP_SPELL_SHADES                      = 10000;
//const int SMP_SPELL_SHADOW_CONJURATION          = 10000;
//const int SMP_SPELL_SHADOW_CONJURATION_GREATER  = 10000;
//const int SMP_SPELL_SHADOW_EVOVATION            = 10000;
//const int SMP_SPELL_SHADOW_EVOVATION_GREATER    = 10000;
//const int SMP_SPELL_SHADOW_WALK                 = 10000;
//const int SMP_SPELL_SHAMBLER                    = 10000;
//const int SMP_SPELL_SHAPECHANGE                 = 10000;
const int SMP_SPELL_SHATTER                     = 10000;
const int SMP_SPELL_SHIELD                      = 10000;
const int SMP_SPELL_SHIELD_OF_FAITH             = 10000;
const int SMP_SPELL_SHIELD_OF_LAW               = 10000;
const int SMP_SPELL_SHIELD_OTHER                = 10000;
const int SMP_SPELL_SHILLELAGH                  = 10000;
const int SMP_SPELL_SHOCKING_GRASP              = 10000;
const int SMP_SPELL_SHOUT                       = 10000;
const int SMP_SPELL_SHOUT_GREATER               = 10000;
//const int SMP_SPELL_SHRINK_ITEM                 = 10000;
const int SMP_SPELL_SILENCE                     = 10000;
//const int SMP_SPELL_SILENT_IMAGE                = 10000;
//const int SMP_SPELL_SIMULACRUM                  = 10000;
const int SMP_SPELL_SLAY_LIVING                 = 10000;
const int SMP_SPELL_SLEEP                       = 10000;
const int SMP_SPELL_SLEET_STORM                 = 10000;
const int SMP_SPELL_SLOW                        = 10000;
//const int SMP_SPELL_SNARE                       = 10000;
//const int SMP_SPELL_SOFTEN_EARTH_AND_STONE      = 10000;
const int SMP_SPELL_SOLID_FOG                   = 10000;
const int SMP_SPELL_SONG_OF_DISCORD             = 10000;
//const int SMP_SPELL_SOUL_BIND                   = 10000;
const int SMP_SPELL_SOUND_BURST                 = 10000;
const int SMP_SPELL_SPEAK_WITH_ANIMALS          = 10000;
//const int SMP_SPELL_SPEAK_WITH_DEAD             = 10000;
const int SMP_SPELL_SPEAK_WITH_PLANTS           = 10000;
const int SMP_SPELL_SPECTRAL_HAND               = 10000;
const int SMP_SPELL_SPELL_IMMUNITY              = 10000;
const int SMP_SPELL_SPELL_IMMUNITY_GREATER      = 10000;
const int SMP_SPELL_SPELL_RESISTANCE            = 10000;
//const int SMP_SPELL_SPELLSTAFF                  = 10000;
const int SMP_SPELL_SPELL_TURNING               = 10000;
//const int SMP_SPELL_SPIDER_CLIMB                = 10000;
const int SMP_SPELL_SPIKE_GROWTH                = 10000;
const int SMP_SPELL_SPIKE_STONES                = 10000;
const int SMP_SPELL_SPIRITUAL_WEAPON            = 10000;
const int SMP_SPELL_STATUE                      = 10000;
const int SMP_SPELL_STATUS                      = 10000;
const int SMP_SPELL_STINKING_CLOUD              = 10000;
const int SMP_SPELL_STONE_SHAPE                 = 10000;
const int SMP_SPELL_STONESKIN                   = 10000;
const int SMP_SPELL_STONE_TELL                  = 10000;
const int SMP_SPELL_STONE_TO_FLESH              = 10000;
const int SMP_SPELL_STORM_OF_VENGEANCE          = 10000;
const int SMP_SPELL_SUGGESTION                  = 10099;
const int SMP_SPELL_SUGGESTION_PUT_WEAPON_DOWN      = 10001;
const int SMP_SPELL_SUGGESTION_RUN_FROM_HOSTILE     = 10002;
const int SMP_SPELL_SUGGESTION_MOVE_TOWARDS_ME      = 10003;
const int SMP_SPELL_SUGGESTION_MOVE_AWAY_FROM_ME    = 10004;
const int SMP_SPELL_SUGGESTION_SIT_DOWN             = 10005;
const int SMP_SPELL_SUGGESTION_MASS             = 10006;
const int SMP_SPELL_SUGGESTION_MASS_PUT_WEAPON_DOWN     = 10007;
const int SMP_SPELL_SUGGESTION_MASS_RUN_FROM_HOSTILE    = 10008;
const int SMP_SPELL_SUGGESTION_MASS_MOVE_TOWARDS_ME     = 10009;
const int SMP_SPELL_SUGGESTION_MASS_MOVE_AWAY_FROM_ME   = 10010;
const int SMP_SPELL_SUGGESTION_MASS_SIT_DOWN            = 10011;
const int SMP_SPELL_SUMMON_INSTRUMENT           = 10000;
const int SMP_SPELL_SUMMON_INSTRUMENT_LUTE          = 10001;
const int SMP_SPELL_SUMMON_INSTRUMENT_PIPES         = 10002;
const int SMP_SPELL_SUMMON_INSTRUMENT_LYRE          = 10003;
const int SMP_SPELL_SUMMON_INSTRUMENT_GUITAR        = 10004;
const int SMP_SPELL_SUMMON_INSTRUMENT_TAMBOURINE    = 10005;
const int SMP_SPELL_SUMMON_MONSTER_I            = 10000;
const int SMP_SPELL_SUMMON_MONSTER_I_RANDOM         = 10000;
const int SMP_SPELL_SUMMON_MONSTER_I_CHOICE         = 10000;
const int SMP_SPELL_SUMMON_MONSTER_II           = 10000;
const int SMP_SPELL_SUMMON_MONSTER_II_RANDOM_1      = 10000;
const int SMP_SPELL_SUMMON_MONSTER_II_RANDOM_1D3    = 10000;
const int SMP_SPELL_SUMMON_MONSTER_II_CHOICE_1      = 10000;
const int SMP_SPELL_SUMMON_MONSTER_II_CHOICE_1D3    = 10000;
//const int SMP_SPELL_SUMMON_MONSTER_III          = 10000;
//const int SMP_SPELL_SUMMON_MONSTER_IV           = 10000;
//const int SMP_SPELL_SUMMON_MONSTER_V            = 10000;
//const int SMP_SPELL_SUMMON_MONSTER_VI           = 10000;
//const int SMP_SPELL_SUMMON_MONSTER_VII          = 10000;
//const int SMP_SPELL_SUMMON_MONSTER_VIII         = 10000;
//const int SMP_SPELL_SUMMON_MONSTER_IX           = 10000;
//const int SMP_SPELL_SUMMON_NATURES_ALLY_I       = 10000;
//const int SMP_SPELL_SUMMON_NATURES_ALLY_II      = 10000;
//const int SMP_SPELL_SUMMON_NATURES_ALLY_III     = 10000;
//const int SMP_SPELL_SUMMON_NATURES_ALLY_IV      = 10000;
//const int SMP_SPELL_SUMMON_NATURES_ALLY_V       = 10000;
//const int SMP_SPELL_SUMMON_NATURES_ALLY_VI      = 10000;
//const int SMP_SPELL_SUMMON_NATURES_ALLY_VII     = 10000;
//const int SMP_SPELL_SUMMON_NATURES_ALLY_VIII    = 10000;
//const int SMP_SPELL_SUMMON_NATURES_ALLY_IX      = 10000;
//const int SMP_SPELL_SUMMON_SWARM                = 10000;
const int SMP_SPELL_SUNBEAM                     = 10000;
const int SMP_SPELL_SUNBURST                    = 10000;
const int SMP_SPELL_SYMBOL_OF_DEATH             = 10050;
const int SMP_SPELL_SYMBOL_OF_FEAR              = 10051;
const int SMP_SPELL_SYMBOL_OF_INSANITY          = 10052;
const int SMP_SPELL_SYMBOL_OF_PAIN              = 10053;
const int SMP_SPELL_SYMBOL_OF_PERSUASION        = 10054;
const int SMP_SPELL_SYMBOL_OF_SLEEP             = 10055;
const int SMP_SPELL_SYMBOL_OF_STUNNING          = 10056;
const int SMP_SPELL_SYMBOL_OF_WEAKNESS          = 10057;
//const int SMP_SPELL_SYMPATHETIC_VIBRATION       = 10000;
//const int SMP_SPELL_SYMPATHY                    = 10000;

/*TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT*/

const int SMP_SPELL_TELEKINESIS                 = 10000;
const int SMP_SPELL_TELEKINESIS_SUSTAINED           = 10001;
const int SMP_SPELL_TELEKINESIS_BULLRUSH            = 10002;
const int SMP_SPELL_TELEKINESIS_DISARM              = 10003;
const int SMP_SPELL_TELEKINESIS_KNOCKDOWN           = 10004;
const int SMP_SPELL_TELEKINESIS_VIOLENT_THRUST      = 10005;
// Note: These are used to concentrate, and not avalible normally.
const int SMP_SPELL_TELEKINESIS_CON_SUSTAINED           = 100101;
const int SMP_SPELL_TELEKINESIS_CON_BULLRUSH            = 100102;
const int SMP_SPELL_TELEKINESIS_CON_DISARM              = 100103;
const int SMP_SPELL_TELEKINESIS_CON_KNOCKDOWN           = 100104;
const int SMP_SPELL_TELEKINETIC_SPHERE          = 10000;
const int SMP_SPELL_TELEKINETIC_SPHERE_MOVEMENT = 10000;// Moves the above sphere around
//const int SMP_SPELL_TELEPATHIC_BOND             = 10000;
const int SMP_SPELL_TELEPORT                    = 10000;
//const int SMP_SPELL_TELEPORT_OBJECT             = 10000;
//const int SMP_SPELL_TELEPORT_GREATER            = 10000;
const int SMP_SPELL_TELEPORTATION_CIRCLE        = 10000;
const int SMP_SPELL_TEMPORAL_STASIS             = 10000;
const int SMP_SPELL_TIME_STOP                   = 10000;
const int SMP_SPELL_TINY_HUT                    = 10000;
//const int SMP_SPELL_TONGUES                     = 10000;
const int SMP_SPELL_TOUCH_OF_FATIGUE            = 10000;
const int SMP_SPELL_TOUCH_OF_IDIOCY             = 10000;
//const int SMP_SPELL_TRANSFORMATION              = 10000;
//const int SMP_SPELL_TRANSMUTE_METAL_TO_WOOD     = 10000;
//const int SMP_SPELL_TRANSMUTE_MUD_TO_ROCK       = 10000;
//const int SMP_SPELL_TRANSMUTE_ROCK_TO_MUD       = 10000;
//const int SMP_SPELL_TRANSPORT_VIA_PLANTS        = 10000;
//const int SMP_SPELL_TRAP_THE_SOUL               = 10000;
//const int SMP_SPELL_TREE_SHAPE                  = 10000;
//const int SMP_SPELL_TREE_STRIDE                 = 10000;
//const int SMP_SPELL_TRUE_RESURRECTION           = 10000;
const int SMP_SPELL_TRUE_SEEING                 = 10000;
//const int SMP_SPELL_TRUE_STRIKE                 = 10000;

/*UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU*/

//const int SMP_SPELL_UNDEATH_TO_DEATH            = 10000;
//const int SMP_SPELL_UNDETECTABLE_ALIGNMENT      = 10000;
//const int SMP_SPELL_UNHALLOW                    = 10000;
const int SMP_SPELL_UNHOLY_AURA                 = 10000;
//const int SMP_SPELL_UNHOLY_BLIGHT               = 10000;
//const int SMP_SPELL_UNSEEN_SERVANT              = 10000;

/*VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*/

//const int SMP_SPELL_VAMPIRIC_TOUCH              = 10000;
//const int SMP_SPELL_VEIL                        = 10000;
//const int SMP_SPELL_VENTRILOQUISM               = 10000;
const int SMP_SPELL_VIRTUE                      = 10000;
//const int SMP_SPELL_VISION                      = 10000;

/*WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW*/

const int SMP_SPELL_WAIL_OF_THE_BANSHEE         = 10000;
//const int SMP_SPELL_WALL_OF_FIRE                = 10000;
//const int SMP_SPELL_WALL_OF_FORCE               = 10000;
//const int SMP_SPELL_WALL_OF_ICE                 = 10000;
//const int SMP_SPELL_WALL_OF_IRON                = 10000;
//const int SMP_SPELL_WALL_OF_STONE               = 10000;
const int SMP_SPELL_WALL_OF_THORNS              = 10000;
const int SMP_SPELL_WARP_WOOD                   = 10000;
//const int SMP_SPELL_WATER_BREATHING             = 10000;
//const int SMP_SPELL_WATER_WALK                  = 10000;
const int SMP_SPELL_WAVES_OF_EXHAUSTION         = 10000;
const int SMP_SPELL_WAVES_OF_FATIGUE            = 10000;
const int SMP_SPELL_WEB                         = 10000;
const int SMP_SPELL_WEIRD                       = 10000;
const int SMP_SPELL_WHIRLWIND                   = 10000;
const int SMP_SPELL_WHISPERING_WIND             = 10000;
const int SMP_SPELL_WIND_WALK                   = 10000;
const int SMP_SPELL_WIND_WALL                   = 10000;
const int SMP_SPELL_WISH                        = 10000;
const int SMP_SPELL_WOOD_SHAPE                  = 10000;
const int SMP_SPELL_WOOD_SHAPE_CLUB                 = 10001;
const int SMP_SPELL_WOOD_SHAPE_STAFF                = 10002;
const int SMP_SPELL_WOOD_SHAPE_BOX                  = 10003;
const int SMP_SPELL_WOOD_SHAPE_4                    = 10004;
const int SMP_SPELL_WOOD_SHAPE_5                    = 10005;
const int SMP_SPELL_WORD_OF_CHAOS               = 10000;
//const int SMP_SPELL_WORD_OF_RECALL              = 10000;

/*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*/

//None

/*YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY*/

//None

/*ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ*/

//const int SMP_SPELL_ZONE_OF_SILENCE             = 10000;
const int SMP_SPELL_ZONE_OF_TRUTH               = 10000;

/*OTHER*/

// Here are all the domain spells. They are in new 2da entries.
// Each domain spell has a new entry. This will inflate the 2da a bit, but NOT
// complicate much at all. They are easily tracked down here, the approprate names
// ETC.

// AIR DOMAIN
// Granted Powers: Turn or destroy earth creatures as a good cleric turns
// undead. Rebuke, command, or bolster air creatures as an evil cleric rebukes
// undead. Use these abilities a total number of times per day equal to 3 + your
// Charisma modifier. This granted power is a supernatural ability.
// * Need to change to "Used as your turning ability"
const int SMP_SPELL_DOMAIN_AIR_OBSCURING_MIST               = 30001;// 1 Obscuring Mist: Fog surrounds you.
const int SMP_SPELL_DOMAIN_AIR_WIND_WALL                    = 30002;// 2 Wind Wall: Deflects arrows, smaller creatures, and gases.
const int SMP_SPELL_DOMAIN_AIR_GASEOUS_FORM                 = 30003;// 3 Gaseous Form: Subject becomes insubstantial and can fly slowly.
const int SMP_SPELL_DOMAIN_AIR_AIR_WALK                     = 30004;// 4 Air Walk: Subject treads on air as if solid (climb at 45-degree angle).
const int SMP_SPELL_DOMAIN_AIR_CONTROL_WINDS                = 30005;// 5 Control Winds: Change wind direction and speed.
const int SMP_SPELL_DOMAIN_AIR_CHAIN_LIGHTNING              = 30006;// 6 Chain Lightning: 1d6/level damage; 1 secondary bolt/level each deals half damage.
const int SMP_SPELL_DOMAIN_AIR_CONTROL_WEATHER              = 30007;// 7 Control Weather: Changes weather in local area.
const int SMP_SPELL_DOMAIN_AIR_WHIRLWIND                    = 30008;// 8 Whirlwind: Cyclone deals damage and can pick up creatures.
const int SMP_SPELL_DOMAIN_AIR_ELEMENTAL_SWARM              = 30009;// 9 Elemental Swarm*: Summons multiple elementals.  * Cast as an air spell only
// * Jass note: Can probably do all of these

// ANIMAL DOMAIN
// Granted Powers: You can use speak with animals once per day as a spell-like
// ability.
// Add Knowledge (nature) to your list of cleric class skills.
// * Cannot do the nature knowledge thing.
const int SMP_SPELL_DOMAIN_ANIMAL_CALM_ANIMALS              = 30011;// 1 Calm Animals: Calms (2d4 + level) HD of animals.
const int SMP_SPELL_DOMAIN_ANIMAL_HOLD_ANIMAL               = 30012;// 2 Hold Animal: Paralyzes one animal for 1 round/level.
const int SMP_SPELL_DOMAIN_ANIMAL_DOMINATE_ANIMAL           = 30013;// 3 Dominate Animal: Subject animal obeys silent mental commands.
const int SMP_SPELL_DOMAIN_ANIMAL_SUMMON_NATURES_ALLY_IV    = 30014;// 4 Summon Nature’s Ally IV*: Calls creature to fight.  * Can only summon animals.
const int SMP_SPELL_DOMAIN_ANIMAL_COMMUNE_WITH_NATURE       = 30015;// 5 Commune with Nature: Learn about terrain for 1 mile/level.
const int SMP_SPELL_DOMAIN_ANIMAL_ANTILIFE_SHELL            = 30016;// 6 Antilife Shell: 10-ft. field hedges out living creatures.
const int SMP_SPELL_DOMAIN_ANIMAL_ANIMAL_SHAPES             = 30017;// 7 Animal Shapes: One ally/level polymorphs into chosen animal.
const int SMP_SPELL_DOMAIN_ANIMAL_SUMMON_NATURES_ALLY_VII   = 30018;// 8 Summon Nature’s Ally VIII*: Calls creature to fight.  * Can only summon animals.
const int SMP_SPELL_DOMAIN_ANIMAL_SHAPECHANGE               = 30019;// 9 Shapechange F: Transforms you into any creature, and change forms once per round.
// * Jass note: Can replace any with Summon Natures Ally.

// CHAOS DOMAIN
// Granted Power: You cast chaos spells at +1 caster level.
const int SMP_SPELL_DOMAIN_CHAOS_PROTECTION_FROM_LAW        = 30021;// 1 Protection from Law: +2 to AC and saves, counter mind control, hedge out elementals and outsiders.
const int SMP_SPELL_DOMAIN_CHAOS_SHATTER                    = 30022;// 2 Shatter: Sonic vibration damages objects or crystalline creatures.
const int SMP_SPELL_DOMAIN_CHAOS_MAGIC_CIRCLE_AGAINST_LAW   = 30023;// 3 Magic Circle against Law: As protection spells, but 10-ft. radius and 10 min./level.
const int SMP_SPELL_DOMAIN_CHAOS_CHAOS_HAMMER               = 30024;// 4 Chaos Hammer: Damages and staggers lawful creatures.
const int SMP_SPELL_DOMAIN_CHAOS_DISPEL_LAW                 = 30025;// 5 Dispel Law: +4 bonus against attacks by lawful creatures.
const int SMP_SPELL_DOMAIN_CHAOS_ANIMATE_OBJECTS            = 30026;// 6 Animate Objects: Objects attack your foes.
const int SMP_SPELL_DOMAIN_CHAOS_WORD_OF_CHAOS              = 30027;// 7 Word of Chaos: Kills, confuses, stuns, or deafens nonchaotic subjects.
const int SMP_SPELL_DOMAIN_CHAOS_CLOAK_OF_CHAOS             = 30028;// 8 Cloak of Chaos F: +4 to AC, +4 resistance, SR 25 against lawful spells.
const int SMP_SPELL_DOMAIN_CHAOS_SUMMON_MONSTER_IX          = 30029;// 9 Summon Monster IX*: Calls extraplanar creature to fight for you. * Cast as a chaos spell only.
// * Jass note: All of these will be in.

// DEATH DOMAIN
// Granted Power: You may use a death touch once per day. Your death touch is
// a supernatural ability that produces a death effect. You must succeed on a
// melee touch attack against a living creature (using the rules for touch
// spells). When you touch, roll 1d6 per cleric level you possess. If the total
// at least equals the creature’s current hit points, it dies (no save).
// * Can do.
const int SMP_SPELL_DOMAIN_DEATH_CAUSE_FEAR                 = 30031;// 1 Cause Fear: One creature of 5 HD or less flees for 1d4 rounds.
const int SMP_SPELL_DOMAIN_DEATH_DEATH_KNELL                = 30032;// 2 Death Knell: Kill dying creature and gain 1d8 temporary hp, +2 to Str, and +1 caster level.
const int SMP_SPELL_DOMAIN_DEATH_ANIMATE_DEAD               = 30033;// 3 Animate Dead M: Creates undead skeletons and zombies.
const int SMP_SPELL_DOMAIN_DEATH_DEATH_WARD                 = 30034;// 4 Death Ward: Grants immunity to death spells and negative energy effects.
const int SMP_SPELL_DOMAIN_DEATH_SLAY_LIVING                = 30035;// 5 Slay Living: Touch attack kills subject.
const int SMP_SPELL_DOMAIN_DEATH_CREATE_UNDEAD              = 30036;// 6 Create Undead M: Create ghouls, ghasts, mummies, or mohrgs.
const int SMP_SPELL_DOMAIN_DEATH_DESTRUCTION                = 30037;// 7 Destruction F: Kills subject and destroys remains.
const int SMP_SPELL_DOMAIN_DEATH_CREATE_GREATER_UNDEAD      = 30038;// 8 Create Greater Undead M: Create shadows, wraiths, spectres, r devourers.
const int SMP_SPELL_DOMAIN_DEATH_WAIL_OF_THE_BANSHEE        = 30039;// 9 Wail of the Banshee: Kills one creature/level.

// DESTRUCTION DOMAIN
// Granted Power: You gain the smite power, the supernatural ability to make
// a single melee attack with a +4 bonus on attack rolls and a bonus on damage
// rolls equal to your cleric level (if you hit). You must declare the smite
// before making the attack. This ability is usable once per day.
// * Can do, as an "attack" animation via. the feats use, and a bonus for a round of attacks
const int SMP_SPELL_DOMAIN_DESTRUCTION_INFLICT_LIGHT_WOUNDS = 30041;// 1 Inflict Light Wounds: Touch attack, 1d8 damage +1/level (max +5).
const int SMP_SPELL_DOMAIN_DESTRUCTION_SHATTER              = 30042;// 2 Shatter: Sonic vibration damages objects or crystalline creatures.
const int SMP_SPELL_DOMAIN_DESTRUCTION_CONTAGION            = 30043;// 3 Contagion: Infects subject with chosen disease.
const int SMP_SPELL_DOMAIN_DESTRUCTION_INFLICT_CRITICAL_WOUNDS = 30044;// 4 Inflict Critical Wounds: Touch attack, 4d8 damage +1/level (max +20).
const int SMP_SPELL_DOMAIN_DESTRUCTION_INFLICT_LIGHT_WOUNDS_MASS = 30045;// 5 Inflict Light Wounds, Mass: Deals 1d8 damage +1/level to any creatures.
const int SMP_SPELL_DOMAIN_DESTRUCTION_HARM                 = 30046;// 6 Harm: Deals 10 points/level damage to target.
const int SMP_SPELL_DOMAIN_DESTRUCTION_DISINTEGRATE         = 30047;// 7 Disintegrate: Makes one creature or object vanish.
const int SMP_SPELL_DOMAIN_DESTRUCTION_EARTHQUAKE           = 30048;// 8 Earthquake: Intense tremor shakes 5-ft./level radius.
const int SMP_SPELL_DOMAIN_DESTRUCTION_IMPLOSION            = 30049;// 9 Implosion: Kills one creature/round.

// EARTH DOMAIN
// Granted Power: Turn or destroy air creatures as a good cleric turns undead.
// Rebuke, command, or bolster earth creatures as an evil cleric rebukes undead.
// Use these abilities a total number of times per day equal to 3 + your
// Charisma modifier. This granted power is a supernatural ability.
// * Need to change to "Used as your turning ability"
const int SMP_SPELL_DOMAIN_EARTH_MAGIC_STONE                = 30051;// 1 Magic Stone: Three stones become +1 projectiles, 1d6 +1 damage.
const int SMP_SPELL_DOMAIN_EARTH_SOFTEN_EARTH_AND_STONE     = 30052;// 2 Soften Earth and Stone: Turns stone to clay or dirt to sand or mud.
const int SMP_SPELL_DOMAIN_EARTH_STONE_SHAPE                = 30053;// 3 Stone Shape: Sculpts stone into any shape.
const int SMP_SPELL_DOMAIN_EARTH_SPIKE_STONES               = 30054;// 4 Spike Stones: Creatures in area take 1d8 damage, may be slowed.
const int SMP_SPELL_DOMAIN_EARTH_WALL_OF_STONE              = 30055;// 5 Wall of Stone: Creates a stone wall that can be shaped.
const int SMP_SPELL_DOMAIN_EARTH_STONESKIN                  = 30056;// 6 Stoneskin M: Ignore 10 points of damage per attack.
const int SMP_SPELL_DOMAIN_EARTH_EARTHQUAKE                 = 30057;// 7 Earthquake: Intense tremor shakes 5-ft./level radius.
const int SMP_SPELL_DOMAIN_EARTH_IRON_BODY                  = 30058;// 8 Iron Body: Your body becomes living iron.
const int SMP_SPELL_DOMAIN_EARTH_ELEMENTAL_SWARM            = 30059;// 9 Elemental Swarm*: Summons multiple elementals.  * Cast as an earth spell only.

// EVIL DOMAIN
// Granted Power: You cast evil spells at +1 caster level.
const int SMP_SPELL_DOMAIN_EVIL_PROTECTION_FROM_GOOD        = 30061;// 1 Protection from Good: +2 to AC and saves, counter mind control, hedge out elementals and outsiders.
const int SMP_SPELL_DOMAIN_EVIL_DESECRATE                   = 30062;// 2 Desecrate M: Fills area with negative energy, making undead stronger.
const int SMP_SPELL_DOMAIN_EVIL_MAGIC_CIRCLE_AGAINST_GOOD   = 30063;// 3 Magic Circle against Good: As protection spells, but 10-ft. radius and 10 min./level.
const int SMP_SPELL_DOMAIN_EVIL_UNHOLY_BLIGHT               = 30064;// 4 Unholy Blight: Damages and sickens good creatures.
const int SMP_SPELL_DOMAIN_EVIL_DISPEL_GOOD                 = 30065;// 5 Dispel Good: +4 bonus against attacks by good creatures.
const int SMP_SPELL_DOMAIN_EVIL_CREATE_UNDEAD               = 30066;// 6 Create Undead M: Create ghouls, ghasts, mummies, or mohrgs.
const int SMP_SPELL_DOMAIN_EVIL_BLASPHEMY                   = 30067;// 7 Blasphemy: Kills, paralyzes, weakens, or dazes nonevil subjects.
const int SMP_SPELL_DOMAIN_EVIL_UNHOLY_AURA                 = 30068;// 8 Unholy Aura F: +4 to AC, +4 resistance, SR 25 against good spells.
const int SMP_SPELL_DOMAIN_EVIL_SUMMON_MONSTER_IX           = 30069;// 9 Summon Monster IX*: Calls extraplanar creature to fight for you.  * Cast as an evil spell only.

// FIRE DOMAIN
// Granted Power: Turn or destroy water creatures as a good cleric turns undead.
// Rebuke, command, or bolster fire creatures as an evil cleric rebukes undead.
// Use these abilities a total number of times per day equal to 3 + your Charisma
// modifier. This granted power is a supernatural ability.
// * Need to change to "Used as your turning ability"
const int SMP_SPELL_DOMAIN_FIRE_BURNING_HANDS               = 30071;// 1 Burning Hands: 1d4/level fire damage (max 5d4).
const int SMP_SPELL_DOMAIN_FIRE_PRODUCE_FLAME               = 30072;// 2 Produce Flame: 1d6 damage +1/ level, touch or thrown.
const int SMP_SPELL_DOMAIN_FIRE_RESIST_ENERGY               = 30073;// 3 Resist Energy*: Ignores 10 (or more) points of damage/attack from specified energy type.  * Resist cold or fire only.
const int SMP_SPELL_DOMAIN_FIRE_WALL_OF_FIRE                = 30074;// 4 Wall of Fire: Deals 2d4 fire damage out to 10 ft. and 1d4 out to 20 ft. Passing through wall deals 2d6 damage +1/level.
const int SMP_SPELL_DOMAIN_FIRE_FIRE_SHIELD                 = 30075;// 5 Fire Shield: Creatures attacking you take fire damage; you’re protected from heat or cold.
const int SMP_SPELL_DOMAIN_FIRE_FIRE_SEEDS                  = 30076;// 6 Fire Seeds: Acorns and berries become grenades and bombs.
const int SMP_SPELL_DOMAIN_FIRE_FIRE_STORM                  = 30077;// 7 Fire Storm: Deals 1d6/level fire damage.
const int SMP_SPELL_DOMAIN_FIRE_INCENDIARY_CLOUD            = 30078;// 8 Incendiary Cloud: Cloud deals 4d6 fire damage/round.
const int SMP_SPELL_DOMAIN_FIRE_ELEMENTAL_SWARM             = 30079;// 9 Elemental Swarm**: Summons multiple elementals.  ** Cast as a fire spell only.

// GOOD DOMAIN
// Granted Power: You cast good spells at +1 caster level.
const int SMP_SPELL_DOMAIN_GOOD_PROTECTION_FROM_EVIL        = 30081;// 1 Protection from Evil: +2 to AC and saves, counter mind control, hedge out elementals and outsiders.
const int SMP_SPELL_DOMAIN_GOOD_AID                         = 30082;// 2 Aid: +1 on attack rolls, +1 on saves against fear, 1d8 temporary hp +1/level (max +10).
const int SMP_SPELL_DOMAIN_GOOD_MAGIC_CIRCLE_AGAINST_EVIL   = 30083;// 3 Magic Circle against Evil: As protection spells, but 10-ft. radius and 10 min./level.
const int SMP_SPELL_DOMAIN_GOOD_HOLY_SMITE                  = 30084;// 4 Holy Smite: Damages and blinds evil creatures.
const int SMP_SPELL_DOMAIN_GOOD_DISPEL_EVIL                 = 30085;// 5 Dispel Evil: +4 bonus against attacks by evil creatures.
const int SMP_SPELL_DOMAIN_GOOD_BLADE_BARRIER               = 30086;// 6 Blade Barrier: Wall of blades deals 1d6/level damage.
const int SMP_SPELL_DOMAIN_GOOD_HOLY_WORD                   = 30087;// 7 Holy Word F: Kills, paralyzes, slows, or deafens nongood subjects.
const int SMP_SPELL_DOMAIN_GOOD_HOLY_AURA                   = 30088;// 8 Holy Aura: +4 to AC, +4 resistance, and SR 25 against evil spells.
const int SMP_SPELL_DOMAIN_GOOD_SUMMON_MONSTER_IX           = 30089;// 9 Summon Monster IX*: Calls extraplanar creature to fight for you.   * Cast as a good spell only.

// HEALING DOMAIN
// Granted Power: You cast healing spells at +1 caster level.
const int SMP_SPELL_DOMAIN_HEALING_CURE_LIGHT_WOUNDS        = 30091;// 1 Cure Light Wounds: Cures 1d8 damage +1/level (max +5).
const int SMP_SPELL_DOMAIN_HEALING_CURE_MODERATE_WOUNDS     = 30092;// 2 Cure Moderate Wounds: Cures 2d8 damage +1/level (max +10).
const int SMP_SPELL_DOMAIN_HEALING_CURE_SERIOUS_WOUNDS      = 30093;// 3 Cure Serious Wounds: Cures 3d8 damage +1/level (max +15).
const int SMP_SPELL_DOMAIN_HEALING_CURE_CRITICAL_WOUNDS     = 30094;// 4 Cure Critical Wounds: Cures 4d8 damage +1/level (max +20).
const int SMP_SPELL_DOMAIN_HEALING_CURE_LIGHT_WOUNDS_MASS   = 30095;// 5 Cure Light Wounds, Mass: Cures 1d8 damage +1/level (max +25) for many creatures.
const int SMP_SPELL_DOMAIN_HEALING_HEAL                     = 30096;// 6 Heal: Cures 10 points/level of damage, all diseases and mental conditions.
const int SMP_SPELL_DOMAIN_HEALING_REGENERATE               = 30097;// 7 Regenerate: Subject’s severed limbs grow back, cures 4d8 damage +1/level (max +35).
const int SMP_SPELL_DOMAIN_HEALING_CURE_CRITICAL_WOUNDS_MASS = 30098;// 8 Cure Critical Wounds, Mass: Cures 4d8 damage +1/level (max +40) for many creatures.
const int SMP_SPELL_DOMAIN_HEALING_HEAL_MASS                = 30099;// 9 Heal, Mass: As heal, but with several subjects.

// KNOWLEDGE DOMAIN
// Granted Power: Add all Knowledge skills to your list of cleric class skills.
// You cast divination spells at +1 caster level.
// * Cannot add Knowledge skills to class list (it is already after all)
const int SMP_SPELL_DOMAIN_KNOWLEDGE_DETECT_SECRET_DOOS     = 30101;// 1 Detect Secret Doors: Reveals hidden doors within 60 ft.
const int SMP_SPELL_DOMAIN_KNOWLEDGE_DETECT_THOUGHTS        = 30102;// 2 Detect Thoughts: Allows “listening” to surface thoughts.
const int SMP_SPELL_DOMAIN_KNOWLEDGE_CLAIRAUDIENCE_CLAIRVOYANCE = 30103;// 3 Clairaudience/Clairvoyance: Hear or see at a distance for 1 min./level.
const int SMP_SPELL_DOMAIN_KNOWLEDGE_DIVINATION             = 30104;// 4 Divination M: Provides useful advice for specific proposed actions.
const int SMP_SPELL_DOMAIN_KNOWLEDGE_TRUE_SEEING            = 30105;// 5 True Seeing M: Lets you see all things as they really are.
const int SMP_SPELL_DOMAIN_KNOWLEDGE_FIND_THE_PATH          = 30106;// 6 Find the Path: Shows most direct way to a location.
const int SMP_SPELL_DOMAIN_KNOWLEDGE_LEGEND_LORE            = 30107;// 7 Legend Lore M F: Lets you learn tales about a person, place, or thing.
const int SMP_SPELL_DOMAIN_KNOWLEDGE_DISCERN_LOCATION       = 30108;// 8 Discern Location: Reveals exact location of creature or object.
const int SMP_SPELL_DOMAIN_KNOWLEDGE_FORESIGHT              = 30109;// 9 Foresight: “Sixth sense” warns of impending danger.

// LAW DOMAIN
// Granted Power: You cast law spells at +1 caster level.
const int SMP_SPELL_DOMAIN_LAW_PROTECTION_FROM_CHAOS        = 30111;// 1 Protection from Chaos: +2 to AC and saves, counter mind control, hedge out elementals and outsiders.
const int SMP_SPELL_DOMAIN_LAW_CALM_EMOTIONS                = 30112;// 2 Calm Emotions: Calms creatures, negating emotion effects.
const int SMP_SPELL_DOMAIN_LAW_MAGIC_CIRCLE_AGAINST_CHAOS   = 30113;// 3 Magic Circle against Chaos: As protection spells, but 10-ft. radius and 10 min./level.
const int SMP_SPELL_DOMAIN_LAW_ORDERS_WRATH                 = 30114;// 4 Order’s Wrath: Damages and dazes chaotic creatures.
const int SMP_SPELL_DOMAIN_LAW_DISPEL_CHAOS                 = 30115;// 5 Dispel Chaos: +4 bonus against attacks by chaotic creatures.
const int SMP_SPELL_DOMAIN_LAW_HOLD_MONSTER                 = 30116;// 6 Hold Monster: As hold person, but any creature.
const int SMP_SPELL_DOMAIN_LAW_DICTUM                       = 30117;// 7 Dictum: Kills, paralyzes, slows, or deafens nonlawful subjects.
const int SMP_SPELL_DOMAIN_LAW_SHIELD_OF_LAW                = 30118;// 8 Shield of Law F: +4 to AC, +4 resistance, and SR 25 against chaotic spells.
const int SMP_SPELL_DOMAIN_LAW_SUMMON_MONSTER_IX            = 30119;// 9 Summon Monster IX*: Calls extraplanar creature to fight for you.  * Cast as a law spell only.

// LUCK DOMAIN
// Granted Power: You gain the power of good fortune, which is usable once per
// day. This extraordinary ability allows you to reroll one roll that you have
// just made before the DM declares whether the roll results in success or
// failure. You must take the result of the reroll, even if it’s worse than
// the original roll.
// * Maybe the ability to add to thier saves, or something, for a limited time.
const int SMP_SPELL_DOMAIN_LUCK_ENTROPIC_SHIELD             = 30121;// 1 Entropic Shield: Ranged attacks against you have 20% miss chance.
const int SMP_SPELL_DOMAIN_LUCK_AID                         = 30122;// 2 Aid: +1 on attack rolls, +1 against fear, 1d8 temporary hp +1/level (max +10).
const int SMP_SPELL_DOMAIN_LUCK_PROTECTION_FROM_ENERGY      = 30123;// 3 Protection from Energy: Absorb 12 points/level of damage from one kind of energy.
const int SMP_SPELL_DOMAIN_LUCK_FREEDOM_OF_MOVEMENT         = 30124;// 4 Freedom of Movement: Subject moves normally despite impediments.
const int SMP_SPELL_DOMAIN_LUCK_BREAK_ENCHANTMENT           = 30125;// 5 Break Enchantment: Frees subjects from enchantments, alterations, curses, and petrification.
const int SMP_SPELL_DOMAIN_LUCK_MISLEAD                     = 30126;// 6 Mislead: Turns you invisible and creates illusory double.
const int SMP_SPELL_DOMAIN_LUCK_SPELL_TURNING               = 30127;// 7 Spell Turning: Reflect 1d4+6 spell levels back at caster.
const int SMP_SPELL_DOMAIN_LUCK_MOMENT_OF_PRESCIENCE        = 30128;// 8 Moment of Prescience: You gain insight bonus on single attack roll, check, or save.
const int SMP_SPELL_DOMAIN_LUCK_MIRACLE                     = 30129;// 9 Miracle X: Requests a deity’s intercession.

// MAGIC DOMAIN
// Granted Power: Use scrolls, wands, and other devices with spell completion
// or spell trigger activation as a wizard of one-half your cleric level
// (at least 1st level). For the purpose of using a scroll or other magic
// device, if you are also a wizard, actual wizard levels and these effective
// wizard levels stack.
// * Cannot do this, I don't think. Could do the stacking part, heh...which would
//   be benificial to a level 1 mage/X cleric using mage items
const int SMP_SPELL_DOMAIN_MAGIC_MAGIC_AURA                 = 30131;// 1 Magic Aura: Alters object’s magic aura.
const int SMP_SPELL_DOMAIN_MAGIC_IDENTIFY                   = 30132;// 2 Identify: Determines properties of magic item.
const int SMP_SPELL_DOMAIN_MAGIC_DISPEL_MAGIC               = 30133;// 3 Dispel Magic: Cancels magical spells and effects.
const int SMP_SPELL_DOMAIN_MAGIC_IMBUNE_WITH_SPELL_ABILITY  = 30134;// 4 Imbue with Spell Ability: Transfer spells to subject.
const int SMP_SPELL_DOMAIN_MAGIC_SPELL_RESISTANCE           = 30135;// 5 Spell Resistance: Subject gains SR 12 + level.
const int SMP_SPELL_DOMAIN_MAGIC_ANTIMAGIC_FIELD            = 30136;// 6 Antimagic Field: Negates magic within 10 ft.
const int SMP_SPELL_DOMAIN_MAGIC_SPELL_TURNING              = 30137;// 7 Spell Turning: Reflect 1d4+6 spell levels back at caster.
const int SMP_SPELL_DOMAIN_MAGIC_PROTECTION_FROM_SPELLS     = 30138;// 8 Protection from Spells M F: Confers +8 resistance bonus.
const int SMP_SPELL_DOMAIN_MAGIC_MAGES_DISJUNCTION          = 30139;// 9 Mage’s Disjunction: Dispels magic, disenchants magic items.

// PLANT DOMAIN
// Granted Powers: Rebuke or command plant creatures as an evil cleric rebukes
// or commands undead. Use this ability a total number of times per day equal
// to 3 + your Charisma modifier. This granted power is a supernatural ability.
// Add Knowledge (nature) to your list of cleric class skills.
// * Need to change to "Used as your turning ability"
// * Cannot add knowledge power (we have it already, lore)
const int SMP_SPELL_DOMAIN_PLANT_ENTANGLE                   = 30141;// 1 Entangle: Plants entangle everyone in 40-ft.-radius.
const int SMP_SPELL_DOMAIN_PLANT_BARKSKIN                   = 30142;// 2 Barkskin: Grants +2 (or higher) enhancement to natural armor.
const int SMP_SPELL_DOMAIN_PLANT_PLANT_GROWTH               = 30143;// 3 Plant Growth: Grows vegetation, improves crops.
const int SMP_SPELL_DOMAIN_PLANT_COMMAND_PLANTS             = 30144;// 4 Command Plants: Sway the actions of one or more plant creatures.
const int SMP_SPELL_DOMAIN_PLANT_WALL_OF_THORNS             = 30145;// 5 Wall of Thorns: Thorns damage anyone who tries to pass.
const int SMP_SPELL_DOMAIN_PLANT_REPEL_WOOD                 = 30146;// 6 Repel Wood: Pushes away wooden objects.
const int SMP_SPELL_DOMAIN_PLANT_ANIMATE_PLANTS             = 30147;// 7 Animate Plants: One or more trees animate and fight for you.
const int SMP_SPELL_DOMAIN_PLANT_CONTROL_PLANTS             = 30148;// 8 Control Plants: Control actions of one or more plant creatures.
const int SMP_SPELL_DOMAIN_PLANT_SHAMBLER                   = 30149;// 9 Shambler: Summons 1d4+2 shambling mounds to fight for you.

// PROTECTION DOMAIN
// Granted Power: You can generate a protective ward as a supernatural ability.
// Grant someone you touch a resistance bonus equal to your cleric level on his
// or her next saving throw. Activating this power is a standard action. The
// protective ward is an abjuration effect with a duration of 1 hour that is
// usable once per day.
// * Make the saving throw only against the first offensive spell, then OK it.
const int SMP_SPELL_DOMAIN_PROTECTION_SANCTUARY             = 30151;// 1 Sanctuary: Opponents can’t attack you, and you can’t attack.
const int SMP_SPELL_DOMAIN_PROTECTION_SHIELD_OTHER          = 30152;// 2 Shield Other F: You take half of subject’s damage.
const int SMP_SPELL_DOMAIN_PROTECTION_PROTECTION_FROM_ENERGY = 30153;// 3 Protection from Energy: Absorb 12 points/level of damage from one kind of energy.
const int SMP_SPELL_DOMAIN_PROTECTION_SPELL_IMMUNITY        = 30154;// 4 Spell Immunity: Subject is immune to one spell per four levels.
const int SMP_SPELL_DOMAIN_PROTECTION_SPELL_RESISTANCE      = 30155;// 5 Spell Resistance: Subject gains SR 12 + level.
const int SMP_SPELL_DOMAIN_PROTECTION_ANTIMAGIC_FIELD       = 30156;// 6 Antimagic Field: Negates magic within 10 ft.
const int SMP_SPELL_DOMAIN_PROTECTION_REPULSION             = 30157;// 7 Repulsion: Creatures can’t approach you.
const int SMP_SPELL_DOMAIN_PROTECTION_MIND_BLANK            = 30158;// 8 Mind Blank: Subject is immune to mental/emotional magic and scrying.
const int SMP_SPELL_DOMAIN_PROTECTION_PRISMATIC_SPHERE      = 30159;// 9 Prismatic Sphere: As prismatic wall, but surrounds on all sides.

// STRENGTH DOMAIN
// Granted Power: You can perform a feat of strength as a supernatural ability.
// You gain an enhancement bonus to Strength equal to your cleric level.
// Activating the power is a free action, the power lasts 1 round, and it is
// usable once per day.
// * Either make it so the feat takes 0 time to use, and add ActionAttack(), or
//   make it 9 seconds long.
const int SMP_SPELL_DOMAIN_STRENGTH_ENLARGE_PERSON          = 30161;// 1 Enlarge Person: Humanoid creature doubles in size.
const int SMP_SPELL_DOMAIN_STRENGTH_BULLS_STRENGTH          = 30162;// 2 Bull’s Strength: Subject gains +4 to Str for 1 min./level.
const int SMP_SPELL_DOMAIN_STRENGTH_MAGIC_VESTMENT          = 30163;// 3 Magic Vestment: Armor or shield gains +1 enhancement per four levels.
const int SMP_SPELL_DOMAIN_STRENGTH_SPELL_IMMUNITY          = 30164;// 4 Spell Immunity: Subject is immune to one spell per four levels.
const int SMP_SPELL_DOMAIN_STRENGTH_RIGHTEOUS_MIGHT         = 30165;// 5 Righteous Might: Your size increases, and you gain combat bonuses.
const int SMP_SPELL_DOMAIN_STRENGTH_STONESKIN               = 30166;// 6 Stoneskin M: Ignore 10 points of damage per attack.
const int SMP_SPELL_DOMAIN_STRENGTH_GRASPING_HAND           = 30167;// 7 Grasping Hand: Large hand provides cover, pushes, or grapples.
const int SMP_SPELL_DOMAIN_STRENGTH_CLENCHED_FIST           = 30168;// 8 Clenched Fist: Large hand provides cover, pushes, or attacks your foes.
const int SMP_SPELL_DOMAIN_STRENGTH_CRUSHING_HAND           = 30169;// 9 Crushing Hand: Large hand provides cover, pushes, or crushes your foes.

// SUN DOMAIN
// Granted Power: Once per day, you can perform a greater turning against
// undead in place of a regular turning. The greater turning is like a normal
// turning except that the undead creatures that would be turned are destroyed
// instead.
// * Easily done, add a new feat for it (As normal for domains) and decrement
//   the turning feat by 1 per use, useable once/day, and has a similar script to the turning feat
const int SMP_SPELL_DOMAIN_SUN_ENDURE_ELEMENTS              = 30171;// 1 Endure Elements: Exist comfortably in hot or cold environments.
const int SMP_SPELL_DOMAIN_SUN_HEAT_METAL                   = 30172;// 2 Heat Metal: Make metal so hot it damages those who touch it.
const int SMP_SPELL_DOMAIN_SUN_SEARING_LIGHT                = 30173;// 3 Searing Light: Ray deals 1d8/two levels, more against undead.
const int SMP_SPELL_DOMAIN_SUN_FIRE_SHIELD                  = 30174;// 4 Fire Shield: Creatures attacking you take fire damage; you’re protected from heat or cold.
const int SMP_SPELL_DOMAIN_SUN_FLAME_STRIKE                 = 30175;// 5 Flame Strike: Smite foes with divine fire (1d6/level damage).
const int SMP_SPELL_DOMAIN_SUN_FIRE_SEEDS                   = 30176;// 6 Fire Seeds: Acorns and berries become grenades and bombs.
const int SMP_SPELL_DOMAIN_SUN_SUNBEAM                      = 30177;// 7 Sunbeam: Beam blinds and deals 4d6 damage.
const int SMP_SPELL_DOMAIN_SUN_SUNBURST                     = 30178;// 8 Sunburst: Blinds all within 10 ft., deals 6d6 damage.
const int SMP_SPELL_DOMAIN_SUN_PRISMATIC_SPHERE             = 30179;// 9 Prismatic Sphere: As prismatic wall, but surrounds on all sides.

// TRAVEL DOMAIN
// Granted Powers: For a total time per day of 1 round per cleric level you
// possess, you can act normally regardless of magical effects that impede
// movement as if you were affected by the spell freedom of movement. This
// effect occurs automatically as soon as it applies, lasts until it runs out
// or is no longer needed, and can operate multiple times per day (up to the
// total daily limit of rounds).
// This granted power is a supernatural ability.
// Add Survival to your list of cleric class skills.
// * Cannot add survival to the list of clerical skills, and make the domain power
//   an actual version of Freedom of Movement would work fine.
const int SMP_SPELL_DOMAIN_TRAVEL_LONGSTRIDER               = 30181;// 1 Longstrider: Increases your speed.
const int SMP_SPELL_DOMAIN_TRAVEL_LOCATE_OBJECT             = 30182;// 2 Locate Object: Senses direction toward object (specific or type).
const int SMP_SPELL_DOMAIN_TRAVEL_FLY                       = 30183;// 3 Fly: Subject flies at speed of 60 ft.
const int SMP_SPELL_DOMAIN_TRAVEL_DIMENSION_DOOR            = 30184;// 4 Dimension Door: Teleports you short distance.
const int SMP_SPELL_DOMAIN_TRAVEL_TELEPORT                  = 30185;// 5 Teleport: Instantly transports you as far as 100 miles/level.
const int SMP_SPELL_DOMAIN_TRAVEL_FIND_THE_PATH             = 30186;// 6 Find the Path: Shows most direct way to a location.
const int SMP_SPELL_DOMAIN_TRAVEL_TELEPORT_GREATER          = 30187;// 7 Teleport, Greater: As teleport, but no range limit and no off-target arrival.
const int SMP_SPELL_DOMAIN_TRAVEL_PHASE_DOOR                = 30188;// 8 Phase Door: Creates an invisible passage through wood or stone.
const int SMP_SPELL_DOMAIN_TRAVEL_ASTRAL_PROJECTION         = 30189;// 9 Astral Projection M: Projects you and companions onto Astral Plane.

// TRICKERY DOMAIN
// Granted Power: Add Bluff, Disguise, and Hide to your list of cleric class skills.
// * Cannot do this, I think, but maybe a power like Biowares, which adds some to
//   these skills (for example, 1 per 3 levels, for 1 round/cleric level)
const int SMP_SPELL_DOMAIN_TRICKERY_DISGUISE_SELF           = 30191;// 1 Disguise Self: Disguise own appearance.
const int SMP_SPELL_DOMAIN_TRICKERY_INVISIBILITY            = 30192;// 2 Invisibility: Subject invisible 1 min./level or until it attacks.
const int SMP_SPELL_DOMAIN_TRICKERY_NONDETECTION            = 30193;// 3 Nondetection M: Hides subject from divination, scrying.
const int SMP_SPELL_DOMAIN_TRICKERY_CONFUSION               = 30194;// 4 Confusion: Subjects behave oddly for 1 round/level.
const int SMP_SPELL_DOMAIN_TRICKERY_FALSE_VISION            = 30195;// 5 False Vision M: Fools scrying with an illusion.
const int SMP_SPELL_DOMAIN_TRICKERY_MISLEAD                 = 30196;// 6 Mislead: Turns you invisible and creates illusory double.
const int SMP_SPELL_DOMAIN_TRICKERY_SCREEN                  = 30197;// 7 Screen: Illusion hides area from vision, scrying.
const int SMP_SPELL_DOMAIN_TRICKERY_POLYMORPH_ANY_OBJECT    = 30198;// 8 Polymorph Any Object: Changes any subject into anything else.
const int SMP_SPELL_DOMAIN_TRICKERY_TIME_STOP               = 30199;// 9 Time Stop: You act freely for 1d4+1 rounds.

// WAR DOMAIN
// Granted Power: Free Martial Weapon Proficiency with deity’s favored weapon
// (if necessary) and Weapon Focus with the deity’s favored weapon.
// * Cannot do this, I think, unless I just make it, well, no, cannot really do it.
//   Best suggestion: Ability to imbune the power of thier weapon with +2 damage
//   permamently, until it leaves thier hands.
const int SMP_SPELL_DOMAIN_WAR_MAGIC_WEAPON                 = 30201;// 1 Magic Weapon: Weapon gains +1 bonus.
const int SMP_SPELL_DOMAIN_WAR_SPIRITUAL_WEAPON             = 30202;// 2 Spiritual Weapon: Magical weapon attacks on its own.
const int SMP_SPELL_DOMAIN_WAR_MAGIC_VESTMENT               = 30203;// 3 Magic Vestment: Armor or shield gains +1 enhancement per four levels.
const int SMP_SPELL_DOMAIN_WAR_DIVINE_POWER                 = 30204;// 4 Divine Power: You gain attack bonus, +6 to Str, and 1 hp/level.
const int SMP_SPELL_DOMAIN_WAR_FLAME_STRIKE                 = 30205;// 5 Flame Strike: Smite foes with divine fire (1d6/level damage).
const int SMP_SPELL_DOMAIN_WAR_BLADE_BARRIER                = 30206;// 6 Blade Barrier: Wall of blades deals 1d6/level damage.
const int SMP_SPELL_DOMAIN_WAR_POWER_WORD_BLIND             = 30207;// 7 Power Word Blind: Blinds creature with 200 hp or less.
const int SMP_SPELL_DOMAIN_WAR_POWER_WORD_STUN              = 30208;// 8 Power Word Stun: Stuns creature with 150 hp or less.
const int SMP_SPELL_DOMAIN_WAR_POWER_WORD_KILL              = 30209;// 9 Power Word Kill: Kills creature with 100 hp or less.

// WATER DOMAIN
// Granted Power: Turn or destroy fire creatures as a good cleric turns undead.
// Rebuke, command, or bolster water creatures as an evil cleric rebukes undead.
// Use these abilities a total number of times per day equal to 3 + your
// Charisma modifier. This granted power is a supernatural ability.
// * Need to change to "Used as your turning ability"
const int SMP_SPELL_DOMAIN_WATER_OBSCURING_MIST             = 30211;// 1 Obscuring Mist: Fog surrounds you.
const int SMP_SPELL_DOMAIN_WATER_FOG_CLOUD                  = 30212;// 2 Fog Cloud: Fog obscures vision.
const int SMP_SPELL_DOMAIN_WATER_WATER_BREATHING            = 30213;// 3 Water Breathing: Subjects can breathe underwater.
const int SMP_SPELL_DOMAIN_WATER_CONTROL_WATER              = 30214;// 4 Control Water: Raises or lowers bodies of water.
const int SMP_SPELL_DOMAIN_WATER_ICE_STORM                  = 30215;// 5 Ice Storm: Hail deals 5d6 damage in cylinder 40 ft. across.
const int SMP_SPELL_DOMAIN_WATER_CONE_OF_COLD               = 30216;// 6 Cone of Cold: 1d6/level cold damage.
const int SMP_SPELL_DOMAIN_WATER_ACID_FOG                   = 30217;// 7 Acid Fog: Fog deals acid damage.
const int SMP_SPELL_DOMAIN_WATER_HORRID_WILTING             = 30218;// 8 Horrid Wilting: Deals 1d6/level damage within 30 ft.
const int SMP_SPELL_DOMAIN_WATER_ELEMENTAL_SWARM            = 30219;// 9 Elemental Swarm*: Summons multiple elementals.   * Cast as a water spell only.


// OTHERS:

const int SMP_SPELL_ABSOLUTE_IMMUNITY           = 10000;
const int SMP_SPELL_ADVENTURERS_LUCK            = 10000;
const int SMP_SPELL_ALL_WILL_BE_DUST            = 10000;
const int SMP_SPELL_ALL_WILL_BE_DUST_ROUND2         = 10001;
const int SMP_SPELL_ALL_WILL_BE_DUST_ROUND3         = 10002;
const int SMP_SPELL_APPRAISAL                   = 10000;
const int SMP_SPELL_BATTLECALM                  = 10000;
const int SMP_SPELL_BODY_OF_ICE                 = 10000;
const int SMP_SPELL_CALL_CHAOS                  = 10000;
const int SMP_SPELL_CHILL_OF_THE_VOID           = 10000;
const int SMP_SPELL_CLEAVE_HEALTH               = 10000;
const int SMP_SPELL_CORROSIVE_BLAST             = 10000;
const int SMP_SPELL_CRIPPLE_UNDEAD              = 10000;
const int SMP_SPELL_DIRGE_OF_DISCORD            = 10000;
const int SMP_SPELL_DISTRACT                    = 10000;
const int SMP_SPELL_DRAGONBLAST                 = 10000;
const int SMP_SPELL_ELEMENTAL_ARMOR             = 10000;
const int SMP_SPELL_ELEMENTAL_ARMOR_AIR             = 10001;
const int SMP_SPELL_ELEMENTAL_ARMOR_EARTH           = 10002;
const int SMP_SPELL_ELEMENTAL_ARMOR_FIRE            = 10003;
const int SMP_SPELL_ELEMENTAL_ARMOR_WATER           = 10004;
const int SMP_SPELL_ENERGY_FIELD                = 10000;
const int SMP_SPELL_ETHEREAL_SHOCK              = 10000;
const int SMP_SPELL_EXTERMINATE                 = 10000;
const int SMP_SPELL_FAMILIAR_TRANSPOSITION      = 10000;
const int SMP_SPELL_FICTIVE_ROPE                = 10000;
const int SMP_SPELL_FIGHT_THEME                 = 10000;
const int SMP_SPELL_FORCE_ARMOR                 = 10000;
const int SMP_SPELL_FORCE_MISSILES              = 10000;
const int SMP_SPELL_FORTIFY_GOLEM               = 10000;
const int SMP_SPELL_GOLEM_CRUSHER               = 10000;
const int SMP_SPELL_GUARDIAN_MANTLE             = 10000;
const int SMP_SPELL_GUARDIAN_MANTLE_GREATER     = 10000;
const int SMP_SPELL_HEAL_ANIMAL_COMPANION       = 10000;
const int SMP_SPELL_JADED_CYNICISM              = 10000;
const int SMP_SPELL_MAGE_ARMOR_LESSER           = 10000;
const int SMP_SPELL_POWER_WORD_FALL             = 10000;
const int SMP_SPELL_RAY_OF_CLUMSINESS           = 10000;
const int SMP_SPELL_RAY_OF_DESPAIR              = 10000;
const int SMP_SPELL_RAY_OF_FORCE                = 10000;
const int SMP_SPELL_RAY_OF_WITHERING            = 10000;
const int SMP_SPELL_RECOVERY                    = 10000;
const int SMP_SPELL_RENEWAL                     = 10000;
const int SMP_SPELL_SAVING_GRACE                = 10000;
const int SMP_SPELL_SEAL_MAGIC                  = 10000;
const int SMP_SPELL_SHIELD_LESSER               = 10000;
const int SMP_SPELL_SLOW_TARGET                 = 10000;
const int SMP_SPELL_SMOOTH_TALK                 = 10000;
const int SMP_SPELL_SPARK_SHOCK                 = 10000;
const int SMP_SPELL_SPELL_CURSE                 = 10000;
const int SMP_SPELL_SPELL_CURSE_GREATER         = 10000;
const int SMP_SPELL_SPELLGUARD                  = 10000;
const int SMP_SPELL_TRANSMUTE_BLOOD_TO_WATER    = 10000;
const int SMP_SPELL_TRUE_DODGE                  = 10000;
const int SMP_SPELL_UNERRING_ACCURACY           = 10000;
const int SMP_SPELL_VAL_FLARE                   = 10000;
const int SMP_SPELL_VITAE_GRENADE               = 10000;
const int SMP_SPELL_WARDING_WHIP                = 10000;
const int SMP_SPELL_WAVE_OF_EXALTATION          = 10000;
const int SMP_SPELL_WHATEVER                    = 10000;
const int SMP_SPELL_WIZARD_SIGHT                = 10000;
const int SMP_SPELL_WOLFSKIN                    = 10000;

/*END*/

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
