/*
    Haunting Melody
*/

#include "prc_inc_spells"

void main()
{
    if (!GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85587,OBJECT_SELF); // no more bardsong uses left
        return;
    }

    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);

    if (PRCGetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }

    //Declare major variables
    object oPC = OBJECT_SELF;
    int nDuration = GetSkillRank(SKILL_PERFORM, oPC);
    int nDC = 10 + GetLevelByClass(CLASS_TYPE_BARD)/2 + GetAbilityModifier(ABILITY_CHARISMA, oPC);

    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), GetLocation(OBJECT_SELF));

    while(GetIsObjectValid(oTarget))
    {
        // * GZ Oct 2003: If we are silenced, we can not benefit from bard song
        if (!PRCGetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !PRCGetHasEffect(EFFECT_TYPE_DEAF,oTarget))
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
                {
                    //Apply the VFX impact and effects
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectShaken(), oTarget, RoundsToSeconds(nDuration));
                }
            }
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), GetLocation(OBJECT_SELF));
    }
}
