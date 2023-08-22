/*:://////////////////////////////////////////////
//:: Name Spell Polymorph Constants
//:: FileName SMP_inc_polycont
//:://////////////////////////////////////////////
    This holds the polymorph constants, for polymorph.2da file.

    It also holds information about what each polymorph does or is used for.

    Oh, and check SMP_INC_APPCONST
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_APPCONST"

/*
    // These are default, Bioware polymorphs and will be left undedited.
int POLYMORPH_TYPE_WEREWOLF              = 0;
int POLYMORPH_TYPE_WERERAT               = 1;
int POLYMORPH_TYPE_WERECAT               = 2;
int POLYMORPH_TYPE_GIANT_SPIDER          = 3;
int POLYMORPH_TYPE_TROLL                 = 4;
int POLYMORPH_TYPE_UMBER_HULK            = 5;
int POLYMORPH_TYPE_PIXIE                 = 6;
int POLYMORPH_TYPE_ZOMBIE                = 7;
int POLYMORPH_TYPE_RED_DRAGON            = 8;
int POLYMORPH_TYPE_FIRE_GIANT            = 9;
int POLYMORPH_TYPE_BALOR                 = 10;
int POLYMORPH_TYPE_DEATH_SLAAD           = 11;
int POLYMORPH_TYPE_IRON_GOLEM            = 12;
int POLYMORPH_TYPE_HUGE_FIRE_ELEMENTAL   = 13;
int POLYMORPH_TYPE_HUGE_WATER_ELEMENTAL  = 14;
int POLYMORPH_TYPE_HUGE_EARTH_ELEMENTAL  = 15;
int POLYMORPH_TYPE_HUGE_AIR_ELEMENTAL    = 16;
int POLYMORPH_TYPE_ELDER_FIRE_ELEMENTAL  = 17;
int POLYMORPH_TYPE_ELDER_WATER_ELEMENTAL = 18;
int POLYMORPH_TYPE_ELDER_EARTH_ELEMENTAL = 19;
int POLYMORPH_TYPE_ELDER_AIR_ELEMENTAL   = 20;
int POLYMORPH_TYPE_BROWN_BEAR            = 21;
int POLYMORPH_TYPE_PANTHER               = 22;
int POLYMORPH_TYPE_WOLF                  = 23;
int POLYMORPH_TYPE_BOAR                  = 24;
int POLYMORPH_TYPE_BADGER                = 25;
int POLYMORPH_TYPE_PENGUIN               = 26;
int POLYMORPH_TYPE_COW                   = 27;
int POLYMORPH_TYPE_DOOM_KNIGHT           = 28;
int POLYMORPH_TYPE_YUANTI                = 29;
int POLYMORPH_TYPE_IMP                   = 30;
int POLYMORPH_TYPE_QUASIT                = 31;
int POLYMORPH_TYPE_SUCCUBUS              = 32;
int POLYMORPH_TYPE_DIRE_BROWN_BEAR       = 33;
int POLYMORPH_TYPE_DIRE_PANTHER          = 34;
int POLYMORPH_TYPE_DIRE_WOLF             = 35;
int POLYMORPH_TYPE_DIRE_BOAR             = 36;
int POLYMORPH_TYPE_DIRE_BADGER           = 37;
int POLYMORPH_TYPE_CELESTIAL_AVENGER     = 38;
int POLYMORPH_TYPE_VROCK                 = 39;
int POLYMORPH_TYPE_CHICKEN               = 40;
int POLYMORPH_TYPE_FROST_GIANT_MALE      = 41;
int POLYMORPH_TYPE_FROST_GIANT_FEMALE    = 42;
int POLYMORPH_TYPE_HEURODIS              = 43;
int POLYMORPH_TYPE_JNAH_GIANT_MALE       = 44;
int POLYMORPH_TYPE_JNAH_GIANT_FEMAL      = 45;
int POLYMORPH_TYPE_WYRMLING_WHITE        = 52;
int POLYMORPH_TYPE_WYRMLING_BLUE         = 53;
int POLYMORPH_TYPE_WYRMLING_RED          = 54;
int POLYMORPH_TYPE_WYRMLING_GREEN        = 55;
int POLYMORPH_TYPE_WYRMLING_BLACK        = 56;
int POLYMORPH_TYPE_GOLEM_AUTOMATON       = 57;
int POLYMORPH_TYPE_MANTICORE             = 58;
int POLYMORPH_TYPE_MALE_DROW             = 59;
int POLYMORPH_TYPE_HARPY                 = 60;
int POLYMORPH_TYPE_BASILISK              = 61;
int POLYMORPH_TYPE_DRIDER                = 62;
int POLYMORPH_TYPE_BEHOLDER              = 63;
int POLYMORPH_TYPE_MEDUSA                = 64;
int POLYMORPH_TYPE_GARGOYLE              = 65;
int POLYMORPH_TYPE_MINOTAUR              = 66;
int POLYMORPH_TYPE_SUPER_CHICKEN         = 67;
int POLYMORPH_TYPE_MINDFLAYER            = 68;
int POLYMORPH_TYPE_DIRETIGER             = 69;
int POLYMORPH_TYPE_FEMALE_DROW           = 70;
int POLYMORPH_TYPE_ANCIENT_BLUE_DRAGON   = 71;
int POLYMORPH_TYPE_ANCIENT_RED_DRAGON    = 72;
int POLYMORPH_TYPE_ANCIENT_GREEN_DRAGON  = 73;
int POLYMORPH_TYPE_VAMPIRE_MALE          = 74;
int POLYMORPH_TYPE_RISEN_LORD            = 75;
int POLYMORPH_TYPE_SPECTRE               = 76;
int POLYMORPH_TYPE_VAMPIRE_FEMALE        = 77;
int POLYMORPH_TYPE_NULL_HUMAN            = 78;
*/
    // Ones that are missing constant names
const int SMP_POLYMORPH_TYPE_MIMIC              = 79;
const int SMP_POLYMORPH_TYPE_BOY                = 80;
const int SMP_POLYMORPH_TYPE_GIRL               = 81;
const int SMP_POLYMORPH_TYPE_LIZARDFOLK         = 82;
const int SMP_POLYMORPH_TYPE_KOBOLD_ASSASSIN    = 83;
const int SMP_POLYMORPH_TYPE_WISP               = 84;
const int SMP_POLYMORPH_TYPE_AZER_BOSS_MALE     = 85;
const int SMP_POLYMORPH_TYPE_AZER_BOSS_FEMALE   = 86;
const int SMP_POLYMORPH_TYPE_DEATHSLAAD         = 87;
const int SMP_POLYMORPH_TYPE_RAKSHASA_MALE      = 88;
const int SMP_POLYMORPH_TYPE_RAKSHASA_FEMALE    = 89;
const int SMP_POLYMORPH_TYPE_IRON_GOLEM         = 90;
const int SMP_POLYMORPH_TYPE_STONE_GOLEM        = 91;
const int SMP_POLYMORPH_TYPE_DEMONFLESH_GOLEM   = 92;
const int SMP_POLYMORPH_TYPE_MITHRAL_GOLEM      = 93;
const int SMP_POLYMORPH_TYPE_MORPH_EARTH_ELEMENTAL  = 94;
const int SMP_POLYMORPH_TYPE_BOAT               = 95;
const int SMP_POLYMORPH_TYPE_MINOTAUR_EPIC      = 96;
const int SMP_POLYMORPH_TYPE_HARPY_EPIC         = 97;
const int SMP_POLYMORPH_TYPE_GARGOYLE_EPIC      = 98;
const int SMP_POLYMORPH_TYPE_BASILISK_EPIC      = 99;
const int SMP_POLYMORPH_TYPE_DRIDER_EPIC        = 100;
const int SMP_POLYMORPH_TYPE_MANTICORE_EPIC     = 101;
const int SMP_POLYMORPH_TYPE_WINTER_WOLF        = 102;
const int SMP_POLYMORPH_TYPE_KOBOLD_ASSASSIN_EPIC   = 103;
const int SMP_POLYMORPH_TYPE_LIZARDFOLK_EPIC    = 104;
const int SMP_POLYMORPH_TYPE_MALE_DROW_EPIC     = 105;
const int SMP_POLYMORPH_TYPE_FEMALE_DROW_EPIC   = 106;

// END BIOWARE POLYMORPHS.


// In order of appearance.2da mostly. Includes ones above (with right stats, hopefully).
const int SMP_POLYMORPH_TYPE_DWARF                  = 51;
const int SMP_POLYMORPH_TYPE_ELF                    = 52;


// Gaseous form spell. A gaseous form, of course. Grey/black kinda thing.
const int SMP_POLYMORPH_TYPE_GASEOUS_FORM           = 0;

// Wind Walk spell. A while cloud.
const int SMP_POLYMORPH_TYPE_WIND_WALK              = 0;

// Polymorph constants.
const int SMP_POLYMORPH_HUMAN                       = 107;
const int SMP_POLYMORPH_ELF                         = 107;
const int SMP_POLYMORPH_HALF_ORC                    = 107;
const int SMP_POLYMORPH_HALFLING                    = 107;
const int SMP_POLYMORPHF_GNOME                      = 107;
const int SMP_POLYMORPH_TYPE_DEER                   = 107;





// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
