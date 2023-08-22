//::///////////////////////////////////////////////
//:: Name      Divine Spirit
//:: FileName  tob_ft_divspirit.nss
//:://////////////////////////////////////////////
/** While in a Devoted Spirit stance, you can expend 
a turn or rebuke undead attempt as an Immediate action 
to heal yourself a number ol hit points equal to 3 + 
your Charisma Modifier (minimum 1 point),

Author:    Stratovarius
Created:   23.9.2018
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "tob_inc_tobfunc"

void main()
{
    object oInitiator = OBJECT_SELF;
    int nDisc = GetDisciplineByManeuver(GetHasActiveStance(oInitiator));
    //make sure there's TU uses left
    if (!GetHasFeat(FEAT_TURN_UNDEAD, oInitiator))
    {
        FloatingTextStringOnCreature("You are out of Turn Undead uses for the day.", oInitiator, FALSE);
        return;
    }
    else if (nDisc == DISCIPLINE_DEVOTED_SPIRIT)
    {
        //use up one
        DecrementRemainingFeatUses(oInitiator, FEAT_TURN_UNDEAD);
        effect eHeal = EffectHeal(GetAbilityModifier(ABILITY_CHARISMA, oInitiator) + 3); // That's it
        effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oInitiator);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oInitiator); 
    }    
        
}

