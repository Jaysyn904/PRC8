//::///////////////////////////////////////////////
//:: Cruelest Cut
//:: prc_rava_cut
//::
//:://////////////////////////////////////////////
/*
    Target takes Constitution damage of 1d4 for 5 rds
    plus 1 round for every ravager level
*/
//:://////////////////////////////////////////////
//:: Created By: aser
//:: Created On: Feb/21/04
//:: Updated by Oni5115 9/23/2004 to use new combat engine
//:: Updated by Strat   12/11/2006 to make it work.
//:://////////////////////////////////////////////

#include "prc_inc_combat"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    effect eDummy = EffectVisualEffect(VFX_IMP_DISEASE_S);
    effect eDam   = EffectAbilityDecrease(ABILITY_CONSTITUTION, d4(1));
    eDummy = EffectLinkEffects(eDummy, eDam);
    
    
    PerformAttackRound(oTarget, oPC, eDam, 9999.0, 0, 0, 0, FALSE, "Cruelest Cut Hit", "Cruelest Cut Miss");
    
    if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    {
    	if (DEBUG) DoDebug("prc_rava_cut: PRCCombat_StruckByAttack is True");
    	ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, d4(1), DURATION_TYPE_PERMANENT, TRUE);
    }
   
}
