//::///////////////////////////////////////////////
//:: [Stunning Shout]
//:: [prc_s_shoutstun.nss]
//:://////////////////////////////////////////////
//::
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Dec 21, 2003
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    //Declare major variables
    int nDuration = 2;
    int nWis = GetAbilityModifier(ABILITY_WISDOM);
    int nDC = 15 + nWis;

    if(GetHasFeat(FEAT_FREE_KI_2, OBJECT_SELF))
        nDC += nWis;
    if(GetHasFeat(FEAT_FREE_KI_3, OBJECT_SELF))
        nDC += nWis;
    if(GetHasFeat(FEAT_FREE_KI_4, OBJECT_SELF))
        nDC += nWis;

    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    effect eGaze = EffectStunned();
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
    effect eVisDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);

    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if(!GetIsReactionTypeFriendly(oTarget) && oTarget != OBJECT_SELF)
        {
            //Determine effect delay
            float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            if(!/*WillSave*/PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGaze, oTarget, 12.0f));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisDur, oTarget, 12.0f));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    }
}
