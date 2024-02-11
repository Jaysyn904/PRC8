//::///////////////////////////////////////////////
//:: Name      Dragon Ally
//:: FileName  sp_drgn_ally.nss
//:://////////////////////////////////////////////
/**@file Dragon Ally
Conjuration (Summoning)
Level: Sor/Wiz 7
Components: V, XP
Casting Time: 1 round
Range: Special (see text)
Effect: One dragon ally (see text)
Duration: 1 minute. + 1 turn/level (Original had no specific duration)
Saving Throw: None
Spell Resistance: No

This spell summons a juvenile red dragon to perform a short task for you.  
The dragon will arrive a minute after hearing the summons.

Special: Sorcerers cast this spell at +1 caster level.

XP Cost: 250

Author:    Fox
Created:   11/16/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    object oPC = OBJECT_SELF;
    object oArea = GetArea(oPC);

    location lLoc = PRCGetSpellTargetLocation();
    int nCasterLevel = PRCGetCasterLevel(oPC);
    if(GetLevelByClass(CLASS_TYPE_SORCERER, oPC)) nCasterLevel += 1;
    float fDur = TurnsToSeconds(nCasterLevel);
    if(PRCGetMetaMagicFeat() & METAMAGIC_EXTEND)
       fDur *= 2; //Duration is +100%
    int nXP = GetXP(oPC);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMONDRAGON), lLoc);

    MultisummonPreSummon();
    string sSummon = "prc_drgnally";
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature(sSummon), lLoc, fDur);
    DelayCommand(0.5, AugmentSummonedCreature(sSummon));

    //only pay the cost if cast sucessfully
    SetXP(oPC, nXP - 250);

    PRCSetSchool();
}


