//::///////////////////////////////////////////////
//:: Noble
//:://////////////////////////////////////////////
/*
    Inspire Greatness - +2d6 temp hp, +2 saves and +2 to attack for allies for 5 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:://////////////////////////////////////////////
#include "prc_alterations"
void main()
{

    if (PRCGetHasEffect(EFFECT_TYPE_SILENCE, OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }
    
    effect eAttack = EffectAttackIncrease(2);
    effect eHP = EffectTemporaryHitpoints(d6(2));
    effect eSaveFort = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);

    effect eLink = EffectLinkEffects(eAttack, eHP);
    eLink = EffectLinkEffects(eLink, eSaveFort);
    
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE, FALSE);
    
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));

    while(GetIsObjectValid(oTarget) )
    {
         // Does not gain benefit if silenced or deaf
         if (!PRCGetHasEffect(EFFECT_TYPE_SILENCE, oTarget) && !PRCGetHasEffect(EFFECT_TYPE_DEAF, oTarget))
         {              
              if(GetIsFriend(oTarget) )
              {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(5));   
              }
         }
         oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}