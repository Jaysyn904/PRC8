/*
    Purple Dragon Knight's Inspire Courage.
*/

#include "prc_inc_spells"

void main()
{
    if (PRCGetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }

    //Declare major variables
    int nDuration = 10; //+ nChr;
    
    effect eAttack = EffectAttackIncrease(1);
    effect eDamage = EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_BLUDGEONING);
    effect eLink = EffectLinkEffects(eAttack, eDamage);   
    
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS);
    eLink = EffectLinkEffects(eLink, eSave);
    eLink = ExtraordinaryEffect(eLink);

    effect eVis = EffectVisualEffect(VFX_DUR_BARD_SONG);

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));

    while(GetIsObjectValid(oTarget))
    {
             // * GZ Oct 2003: If we are silenced, we can not benefit from bard song
             if (!PRCGetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !PRCGetHasEffect(EFFECT_TYPE_DEAF,oTarget))
             {
                if(oTarget == OBJECT_SELF)
                {
                    effect eLinkBard = EffectLinkEffects(eLink, eVis);
                    eLinkBard = ExtraordinaryEffect(eLinkBard);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkBard, oTarget, RoundsToSeconds(nDuration));

                }
                else if(GetIsFriend(oTarget))
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                }
            }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}
