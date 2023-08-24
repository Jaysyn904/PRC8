//::///////////////////////////////////////////////
//:: Sanctified Mind Disrupting Blow
//:: psi_smnd_disblow.nss
//::///////////////////////////////////////////////
/*
    Performs an attack round with a chance on the first
    attack to force a save that stops them from using 
    psionics for 1d4 rounds.
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 17.2.2006
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    effect eDummy = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    int nDC = 10 + GetLevelByClass(CLASS_TYPE_SANCTIFIED_MIND, oPC) + GetAbilityModifier(ABILITY_WISDOM, oPC);

    PerformAttackRound(oTarget, oPC, eDummy, 0.0, 0, 0, DAMAGE_TYPE_MAGICAL, FALSE, "Disrupting Strike Hit", "Disrupting Strike Miss");
    
    if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    {
        // Fort Save vs DC of 10 + Class level + Wis Mod
	if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
        {
                // Target cannot use psionics or psi-likes for 1d4 rounds
        	SetLocalInt(oTarget, "DisruptingStrike_PsionicsFail", TRUE);
        	DelayCommand(RoundsToSeconds(d4()), DeleteLocalInt(oTarget, "DisruptingStrike_PsionicsFail"));
        }
    }    
}
