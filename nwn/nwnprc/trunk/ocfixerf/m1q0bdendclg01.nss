// Added compatibility for PRC base classes
#include "prc_class_const"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int bCondition = !GetIsObjectValid(oPC)
                    && GetLocalInt(OBJECT_SELF, "Generic_Surrender") == 1
                    && (GetLevelByClass(CLASS_TYPE_ANTI_PALADIN, oPC)
                    || GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC)
                    || GetLevelByClass(CLASS_TYPE_BARD, oPC)
                    || GetLevelByClass(CLASS_TYPE_BOWMAN, oPC)
                    || GetLevelByClass(CLASS_TYPE_BRAWLER, oPC)
                    || GetLevelByClass(CLASS_TYPE_CRUSADER, oPC)
                    || GetLevelByClass(CLASS_TYPE_CW_SAMURAI, oPC)
                    || GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN, oPC)
                    || GetLevelByClass(CLASS_TYPE_DUSKBLADE, oPC)
                    || GetLevelByClass(CLASS_TYPE_FIGHTER, oPC)
                    || GetLevelByClass(CLASS_TYPE_HEXBLADE, oPC)
                    || GetLevelByClass(CLASS_TYPE_KNIGHT, oPC)
                    || GetLevelByClass(CLASS_TYPE_MARSHAL, oPC)
                    || GetLevelByClass(CLASS_TYPE_MONK, oPC)
                    || GetLevelByClass(CLASS_TYPE_NOBLE, oPC)
                    || GetLevelByClass(CLASS_TYPE_PALADIN, oPC)
                    || GetLevelByClass(CLASS_TYPE_PSYWAR, oPC)
                    || GetLevelByClass(CLASS_TYPE_RANGER, oPC)
                    || GetLevelByClass(CLASS_TYPE_SAMURAI, oPC)
                    || GetLevelByClass(CLASS_TYPE_SCOUT, oPC)
                    || GetLevelByClass(CLASS_TYPE_SOHEI, oPC)
                    || GetLevelByClass(CLASS_TYPE_SOULKNIFE, oPC)
                    || GetLevelByClass(CLASS_TYPE_SWASHBUCKLER, oPC)
                    || GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC)
                    || GetLevelByClass(CLASS_TYPE_TRUENAMER, oPC)
                    || GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER, oPC)
                    || GetLevelByClass(CLASS_TYPE_WARBLADE, oPC)
					|| GetLevelByClass(CLASS_TYPE_TOTEMIST, oPC)
					|| GetLevelByClass(CLASS_TYPE_SOULBORN, oPC)
					|| GetLevelByClass(CLASS_TYPE_INCARNATE, oPC)
					|| GetLevelByClass(CLASS_TYPE_FACTOTUM, oPC)
					|| GetLevelByClass(CLASS_TYPE_BINDER, oPC));
    return bCondition;
}