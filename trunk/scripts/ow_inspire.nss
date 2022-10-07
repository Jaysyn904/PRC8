//::///////////////////////////////////////////////
//:: Orc Warlord
//:://////////////////////////////////////////////
/*
    Inspire Courage - +2 saves vs. fear and charm and +1 to attack and damage for allies for 5 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:://////////////////////////////////////////////
#include "prc_alterations"
void main()
{

    if (PRCGetHasEffect(EFFECT_TYPE_SILENCE, OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }
    
    effect eAttack = EffectAttackIncrease(1);
    effect eDamage = EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_BLUDGEONING);
    effect eSaveFear = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_FEAR);
    effect eSaveCharm = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_MIND_SPELLS);

    effect eLink = EffectLinkEffects(eAttack, eDamage);
    eLink = EffectLinkEffects(eLink, eSaveFear);
    eLink = EffectLinkEffects(eLink, eSaveCharm);
    
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