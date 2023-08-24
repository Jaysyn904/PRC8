/**
 * @file
 * Extra Summons for Alienist
 *
 */

#include "prc_inc_spells"

void main()
{
    object oCaster = OBJECT_SELF;
    int nMaxSlot = GetSpellslotLevel(GetPrimaryArcaneClass(oCaster), oCaster);
    int nSpell;
    if (nMaxSlot == 9) nSpell = SPELL_SUMMON_CREATURE_IX;
    else if (nMaxSlot == 8) nSpell = SPELL_SUMMON_CREATURE_VIII;
    else if (nMaxSlot == 7) nSpell = SPELL_SUMMON_CREATURE_VII;
    else if (nMaxSlot == 6) nSpell = SPELL_SUMMON_CREATURE_VI;
    else if (nMaxSlot == 5) nSpell = SPELL_SUMMON_CREATURE_V;
    else if (nMaxSlot == 4) nSpell = SPELL_SUMMON_CREATURE_IV;
    else if (nMaxSlot == 3) nSpell = SPELL_SUMMON_CREATURE_III;
    else if (nMaxSlot == 2) nSpell = SPELL_SUMMON_CREATURE_II;
    else if (nMaxSlot == 1) nSpell = SPELL_SUMMON_CREATURE_I;
    
    DoRacialSLA(nSpell);    
}
        