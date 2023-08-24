/*:://////////////////////////////////////////////
//:: Script Name Negative Energy Plane - Major - Heartbeat
//:: Script FileName PHS_OT_NegPlnMaj
//:://////////////////////////////////////////////
//:: File Notes
//:://////////////////////////////////////////////
    Major Negative Energy Plane. Very unlucky if you end up here!

    Description:

    Negative-Dominant: Planes with this trait are vast, empty reaches that suck
    the life out of travelers who cross them. They tend to be lonely, haunted
    planes, drained of color and filled with winds bearing the soft moans of
    those who died within them. As with positive-dominant planes,
    negative-dominant planes can be either minor or major. On minor
    negative-dominant planes, living creatures take 1d6 points of damage per
    round. At 0 hit points or lower, they crumble into ash.

    Major negative-dominant planes are even more severe. Each round, those
    within must make a DC 25 Fortitude save or gain a negative level. A
    creature whose negative levels equal its current levels or Hit Dice is
    slain, becoming a wraith. The death ward spell protects a traveler from
    the damage and energy drain of a negative-dominant plane.

    Basically:
    - Deals a negative level (delayed just in case of it not reacting correctly
      to stacking) on a failed DC25 fortitude save, eachround.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Loop all objects in the area. DMs excepted.
    object oTarget = GetFirstObjectInArea(OBJECT_SELF);

    if(!GetIsObjectValid(oTarget)) return;

    // Delcare effects - Negative Level
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eNeg = EffectNegativeLevel(1);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = SupernaturalEffect(EffectLinkEffects(eNeg, eDur));
    float fDuration;

    // Loop all objects in the area. DMs excepted.
    while(GetIsObjectValid(oTarget))
    {
        // Is it a creature? (Not a DM)
        if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE &&
           PHS_CanCreatureBeDestroyed(oTarget))
        {
            // Are they dead? If yes, ignore.
            if(!GetIsDead(oTarget))
            {
                // Immune to negative levels?
                if(!PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_NEGATIVE_LEVEL))
                {
                    // DC 25 fortitude save for a permanent negative level.
                    if(!PHS_NotSpellSavingThrow(SAVING_THROW_FORT, oTarget, 25, SAVING_THROW_TYPE_NEGATIVE))
                    {
                        // Fortitude save: Death
                        SendMessageToPC(oTarget, "You gain a negative level due to being on the negative plane.");

                        // Apply the negative level.
                        DelayCommand(0.1, PHS_ApplyPermanentAndVFX(oTarget, eVis, eLink));
                    }
                }
            }
        }
        // Get next object
        oTarget = GetNextObjectInArea(OBJECT_SELF);
    }
}
