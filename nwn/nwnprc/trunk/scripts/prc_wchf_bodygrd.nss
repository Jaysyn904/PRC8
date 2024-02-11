//::///////////////////////////////////////////////
//:: Foe Hunter
//:://////////////////////////////////////////////
/*
    Warchief devoted bodyguards
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Mar 17, 2004
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;

    int iDamageTaken = GetTotalDamageDealt();
    int nCheck = FALSE;

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oPC), TRUE);
    while(GetIsObjectValid(oTarget) && !nCheck)
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oPC) && oTarget != oPC)
        {
            // This is the damage being shifted from the Warchief to an ally
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamageTaken), oTarget);
            nCheck = TRUE;
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oPC), TRUE);
    }

    if(nCheck)
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(iDamageTaken), oPC);
}