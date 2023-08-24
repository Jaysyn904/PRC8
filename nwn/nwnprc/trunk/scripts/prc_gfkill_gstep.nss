//::///////////////////////////////////////////////
//:: Ghost Step (Invisibility)
//:: prc_gfkill_gstep.nss
//:://////////////////////////////////////////////
/*
    Target creature becomes invisible
*/
//:://////////////////////////////////////////////
//:: Created By: Stefan Johnson
//:: Created On: December 1, 2005
//:://////////////////////////////////////////////

#include "inc_utility"

void main()
{
    object oCaster = OBJECT_SELF;

    if(PRCGetHasEffect(EFFECT_TYPE_CHARMED, oCaster)
    || PRCGetHasEffect(EFFECT_TYPE_CONFUSED, oCaster)
    || PRCGetHasEffect(EFFECT_TYPE_CUTSCENE_PARALYZE, oCaster)
    || PRCGetHasEffect(EFFECT_TYPE_CUTSCENEIMMOBILIZE, oCaster)
    || PRCGetHasEffect(EFFECT_TYPE_DAZED, oCaster)
    || PRCGetHasEffect(EFFECT_TYPE_DOMINATED, oCaster)
    || PRCGetHasEffect(EFFECT_TYPE_FRIGHTENED, oCaster)
    || PRCGetHasEffect(EFFECT_TYPE_PARALYZE, oCaster)
    || PRCGetHasEffect(EFFECT_TYPE_PETRIFY, oCaster)
    || PRCGetHasEffect(EFFECT_TYPE_SLEEP, oCaster)
    || PRCGetHasEffect(EFFECT_TYPE_STUNNED, oCaster))
    {
        IncrementRemainingFeatUses(oCaster, FEAT_GFKILL_GHOST_STEP);
        return;
    }

    effect eEffect;
    if(GetLevelByClass(CLASS_TYPE_GHOST_FACED_KILLER, oCaster) > 5)
        eEffect = EffectEthereal();
    else
        eEffect = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oCaster, RoundsToSeconds(1));
}