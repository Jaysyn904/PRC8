//::///////////////////////////////////////////////
//:: Aura of Fear
//:: prc_rava_fear
//:://////////////////////////////////////////////
/*
    A save penalty is given to all creatures
    around the ravager for 3 rounds + character level.
*/

#include "prc_alterations"
#include "x2_inc_spellhook"
#include "prc_class_const"

void main()
{
    //Declare major variables
    object oTarget;

    int iLevel = GetLevelByClass(CLASS_TYPE_RAVAGER,OBJECT_SELF) + 3;

    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL,2,SAVING_THROW_TYPE_ALL);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eExplode = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    effect eLink = EffectLinkEffects(eSave, eDur);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplode, OBJECT_SELF);

    float fSize;

       if(GetLevelByClass(CLASS_TYPE_RAVAGER,OBJECT_SELF) >= 8)
       {
        fSize = RADIUS_SIZE_GARGANTUAN;
       }
       else if(GetLevelByClass(CLASS_TYPE_RAVAGER,OBJECT_SELF) >= 5)
       {
        fSize = RADIUS_SIZE_HUGE;
       }
       else if(GetLevelByClass(CLASS_TYPE_RAVAGER,OBJECT_SELF) >= 2)
       {
        fSize = RADIUS_SIZE_LARGE;
       }

    //Determine enemies in the radius around the ravager
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fSize, GetLocation(OBJECT_SELF));
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(iLevel));
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fSize, GetLocation(OBJECT_SELF));
    }

}