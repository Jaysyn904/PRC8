//::///////////////////////////////////////////////
//:: Name      Profane Agony
//:: FileName  prc_ft_prfnagony.nss
//:://////////////////////////////////////////////
/** You can spend three turn or rebuke undead 
attempts to teleport to any point up to 30 feet 
away within line of sight. This effect functions 
as dimension door, except that you can't bring 
along other creatures.

Author:    Stratovarius
Created:   13.11.2018
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oInitiator = OBJECT_SELF;
    object oTarget    = PRCGetSpellTargetObject();

    //make sure there's TU uses left
    if (!GetHasFeat(FEAT_TURN_UNDEAD, oInitiator))
    {
        FloatingTextStringOnCreature("You are out of Turn Undead uses for the day.", oInitiator, FALSE);
        return;
    }
    
    DecrementRemainingFeatUses(oInitiator, FEAT_TURN_UNDEAD); // Burn one

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectSickened()), oTarget, 6.0);
    int nDC = 10 + GetHitDice(oInitiator)/2 + GetAbilityModifier(ABILITY_CHARISMA, oInitiator);
        
    if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DIVINE, oInitiator))
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(3), DAMAGE_TYPE_DIVINE), oTarget);
}

