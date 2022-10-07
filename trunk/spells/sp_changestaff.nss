//::///////////////////////////////////////////////
//:: Name      Changestaff
//:: FileName  sp_changestaff.nss
//:://////////////////////////////////////////////
/*
Transmutation
Level: Druid 7
Components: V, S
Casting Time: 1 round
Range: Short
Effect: One treant
Duration: 1 hour/level
Saving Throw: None
Spell Resistance: No

This spell summons a treant to defend you

Author:    Strat
Created:   07/24/19
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    object oPC = OBJECT_SELF;
    object oArea = GetArea(oPC);

    location lLoc = PRCGetSpellTargetLocation();
    int nCasterLevel = PRCGetCasterLevel(oPC);
    float fDur = HoursToSeconds(nCasterLevel);
    if(PRCGetMetaMagicFeat() & METAMAGIC_EXTEND)
       fDur *= 2; //Duration is +100%
    int nXP = GetXP(oPC);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_NATURES_ALLY_1), lLoc);

    MultisummonPreSummon();
    string sSummon = "prc_sum_treant";
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature(sSummon), lLoc, fDur);
    DelayCommand(0.5, AugmentSummonedCreature(sSummon));

    PRCSetSchool();
}


