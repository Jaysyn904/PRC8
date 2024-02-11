//::///////////////////////////////////////////////
//:: Wild Surge
//:: prc_wild_surge
//::///////////////////////////////////////////////
/** @file
    Turns Wild Surge to a setting determined by
    SpellID.

    @author Ornedan
    @date   Created - 2005.11.28
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"

const int SPELLID_WILD_SURGE_1  = 2380;
const int SPELLID_WILD_SURGE_11 = 2390;

void main()
{
    object oPC     = OBJECT_SELF;
    int nSpellID   = GetSpellId();
    int nWilderLvl = GetLevelByClass(CLASS_TYPE_WILDER, oPC);
    int nWildSurge = nSpellID - SPELLID_WILD_SURGE_1 + 1;
    int nMaxSurge;
    if(nWilderLvl < 3)
        nMaxSurge = 1;
    else
        nMaxSurge = ((nWilderLvl + 1) / 4) + 1;

    if(DEBUG) if(nWildSurge < 1 || nWildSurge > 11) DoDebug("prc_wild_surge: ERROR: Unsupported spellID: " + IntToString(nSpellID));

    if(nWildSurge <= nMaxSurge)
    {
        if(!GetLocalInt(oPC, PRC_OVERCHANNEL))
        {
            SetLocalInt(oPC, PRC_WILD_SURGE, nWildSurge);
            FloatingTextStringOnCreature(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID))), oPC, FALSE);
        }
        else
            FloatingTextStrRefOnCreature(16824026, oPC, FALSE); // "You cannot have Wild Surge and Overchannel active at the same time"
    }
    else
        FloatingTextStrRefOnCreature(16824027, oPC, FALSE); // "Your Wilder level is not high enough to use this level of Wild Surge"
}
