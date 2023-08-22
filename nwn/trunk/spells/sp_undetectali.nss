/*
Undetectable alignment
Abjuration
Level: Brd 2, Clr 2, Pal 2
Components: V, S
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One creature or object
Duration: 24 hours
Saving Throw: Will negates (object)
Spell Resistance: Yes (object)
Conceals the alignment of an object or a creature from all forms of divination.


*/

#include "prc_inc_spells"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);


    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = PRCGetSpellTargetObject();
    //VFX alone cant be gotten later, so incrase & decrases a minor skill by 1 point
    effect eEffect = EffectLinkEffects(EffectSkillIncrease(SKILL_HEAL, 1), EffectSkillDecrease(SKILL_HEAL, 1));
    //VFX for start & end of the effect
    eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
    //get duration
    float fDuration = HoursToSeconds(24);
    if(PRCGetMetaMagicFeat() & METAMAGIC_EXTEND)
        fDuration *= 2.0;
    //apply the effect
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}