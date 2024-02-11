//::///////////////////////////////////////////////
//:: Suel Archanamach Dispelling Strike
//:: prc_suel_disstrk.nss
//::///////////////////////////////////////////////
/*
    Performs an attack round with a dispel on the first strike
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 7.4.2006
//:://////////////////////////////////////////////

#include "inc_dispel"
#include "prc_inc_combat"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_BREACH);
    effect eImpact = EffectVisualEffect(VFX_FNF_DISPEL_GREATER);
    effect eDummy;
    // The d20 is rolled in the script, this is the effective dispel caster level
    int nDispel = GetLevelByClass(CLASS_TYPE_SUEL_ARCHANAMACH, oPC) + 6;

    PerformAttackRound(oTarget, oPC, eDummy, 0.0, 0, 0, DAMAGE_TYPE_MAGICAL, FALSE, "Dispelling Strike Hit", "Dispelling Strike Miss");
    
    if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    {
	spellsDispelMagicMod(oTarget, nDispel, eVis, eImpact);
    }    
}
