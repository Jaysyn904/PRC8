//::///////////////////////////////////////////////
//:: Family Domain Power
//:: prc_domain_famly.nss
//::///////////////////////////////////////////////
/*
    Grants +4 AC to a number of creatures = to Cha for 1 round per level
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 19.12.2005
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_inc_domain"

void main()
{
    object oPC = OBJECT_SELF;

    // Used by the uses per day check code for bonus domains
    if (!DecrementDomainUses(PRC_DOMAIN_FAMILY, oPC)) return;

    effect eLink = EffectLinkEffects(EffectACIncrease(4), EffectVisualEffect(VFX_DUR_GLOBE_MINOR));
           eLink = SupernaturalEffect(eLink);
    float fDur = RoundsToSeconds(GetHitDice(oPC));
    // Already used up the minimum one target to affect the caster
    int nExtraTargets = GetAbilityModifier(ABILITY_CHARISMA, oPC) - 1;

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);

    if(nExtraTargets > 0)
    {
        location lTarget = GetLocation(oPC);

        //Cycle through the targets within the spell shape until you run out of targets.
        object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oAreaTarget) && nExtraTargets > 0)
        {
            // Only affect friends, and don't affect yourself again
            if(GetIsFriend(oAreaTarget, oPC) && oAreaTarget != oPC)
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oAreaTarget, fDur);
                // Use up a target slot only if we actually did something to it
                nExtraTargets -= 1;
            }

            //Select the next target within the spell shape.
            oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }// end while - Target loop
    }// end if - The power has other targets besides the primary one
}