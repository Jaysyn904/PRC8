//::///////////////////////////////////////////////
//:: Pulse Whirlwind
//:: NW_S1_PulsWind
//:: Copyright (c) 2001 Bioware Corp.
//::///////////////////////////////////////////////
/*
    All those that fail a save of DC 14 are knocked
    down by the elemental whirlwind.

     * made this make the knockdown last 2 rounds instead of 1
     * it will now also do d3(hitdice/2) damage
*/
//::///////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//::///////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    //Declare major variables
    effect eDown = EffectKnockdown();
    effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_WIND);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
    int nDamage = GetHitDice(OBJECT_SELF) /2;
    effect eDam;
    //Get first target in spell area
    while(GetIsObjectValid(oTarget))
    {
        eDam = PRCEffectDamage(oTarget, d3(nDamage), DAMAGE_TYPE_SLASHING);
		
		if(!GetIsReactionTypeFriendly(oTarget) && oTarget != OBJECT_SELF)
        {
            //Make a saving throw check
            if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, 14))
            {
                //Apply the VFX impact and effects

                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDown, oTarget, RoundsToSeconds(2));
                DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam,oTarget));
            }
            //Get next target in spell area
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
    }
}
