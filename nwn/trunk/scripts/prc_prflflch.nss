//////////////////////////////////////////////////
// Profane Life Leech
// prc_prflflch.nss
//////////////////////////////////////////////////
/** @file Profane Lifeleech [Divine]

Prerequisite: Ability to rebuke undead.

Benefit: As a standard action, you can spend two of your rebuke attempts to deal
1d6 points of damage to all living creatures within a 30-foot burst. You are healed of
an amount of damage equal to the total amount of hit points that you drain from 
affected creatures, but this healing does not allow you to exceed your full normal
hit point total.

Special: This feat deals no damage to constructs or undead.
*/
///////////////////////////////////////////////////////////////////////////////////
// Author: Tenjac
// Created: 4/22/08
///////////////////////////////////////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    location lLoc = GetLocation(oPC);

    //Rebuke check
    if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL && !GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oPC))
    {
        SendMessageToPC(oPC, "You must be able to Rebuke Undead to use this feat.");
        return;
    }

    //If they have zero left, uncermoniously boot them without incrementing
    if(!GetHasFeat(FEAT_TURN_UNDEAD, oPC))
    {
        SendMessageToPC(oPC, "You do not have enough uses of Rebuke Undead left.");
        return;
    }

    DecrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD);

    //Check for a remaining use
    if(GetHasFeat(FEAT_TURN_UNDEAD, oPC))
    {
        //burn the other use required
        DecrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD);

        //VFX
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWKILL), lLoc);

        int nDam;
        float fRange = FeetToMeters(30.0);

        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRange, lLoc, FALSE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oTarget))
        {
            if(oTarget != oPC)
            {
                if(PRCGetIsAliveCreature(oTarget) && !GetIsReactionTypeFriendly(oTarget))
                {
                    nDam = d6(1);

                    //Damage
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_DIVINE), oTarget);

                    //Heal
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nDam), oPC);
                }
            }
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRange, lLoc, FALSE, OBJECT_TYPE_CREATURE);
        }
    }
    else
    {
        IncrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD);
        SendMessageToPC(oPC, "You do not have enough uses of Rebuke Undead left.");
    }
}