//::///////////////////////////////////////////////
//:: Name      Lolth's Boon
//:: FileName  prc_ft_lolthboon.nss
//:://////////////////////////////////////////////
/** You can spend two rebuke undead attempts as a 
standard action to unleash a 60-foot-radius burst 
of divine energy. Each vermin in the area gains 
temporary hit points equal to its HD, as well as 
a +2 profane bonus on melee damage rolls. These 
effects last for 5 rounds.

Author:    Stratovarius
Created:   13.11.2018
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget    = PRCGetSpellTargetObject();

    //make sure there's TU uses left
    if (!GetHasFeat(FEAT_TURN_UNDEAD, oPC))
    {
        FloatingTextStringOnCreature("You are out of Turn Undead uses for the day.", oPC, FALSE);
        return;
    }
    DecrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD); // Burn one
    if (!GetHasFeat(FEAT_TURN_UNDEAD, oPC))
    {
        FloatingTextStringOnCreature("You do not have enough Turn Undead uses.", oPC, FALSE);
        IncrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD);
        return;
    }
    DecrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD); // Burn two

    //Cycle through the targets within the spell shape until you run out of targets.
    object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oAreaTarget))
    {
        if (GetRacialType(oAreaTarget) == RACIAL_TYPE_VERMIN)
        {   
            effect eLink = EffectLinkEffects(EffectTemporaryHitpoints(GetHitDice(oAreaTarget)), EffectDamageIncrease(DAMAGE_BONUS_2));
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oAreaTarget, 30.0);
        }
    
        //Select the next target within the spell shape.
        oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE);
        // end while - Target loop
    }
}

