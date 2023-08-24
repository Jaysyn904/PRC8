/*
    sp_nondetection

    Abjuration
    Level: Rgr 4, Sor/Wiz 3, Trickery 3
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature or object touched
    Duration: 1 hour/level
    Saving Throw: Will negates (harmless, object)
    Spell Resistance: Yes (harmless, object)
    The warded creature or object becomes difficult to detect by divination spells such as clairaudience/clairvoyance, locate object, and detect spells. Nondetection also prevents location by such magic items as crystal balls. If a divination is attempted against the warded creature or item, the caster of the divination must succeed on a caster level check (1d20 + caster level) against a DC of 11 + the caster level of the spellcaster who cast nondetection. If you cast nondetection on yourself or on an item currently in your possession, the DC is 15 + your caster level.
    If cast on a creature, nondetection wards the creature’s gear as well as the creature itself.
    Material Component: A pinch of diamond dust worth 50 gp.

    By: Flaming_Sword
    Created: Oct 1, 2006
    Modified: Oct 5, 2006
*/

#include "prc_sp_func"

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(SPELL_SCHOOL_ABJURATION);
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eEffect = EffectLinkEffects(EffectSkillIncrease(SKILL_HEAL, 1), EffectSkillDecrease(SKILL_HEAL, 1));
    //VFX for start & end of the effect
    eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
    //get duration
    float fDuration = HoursToSeconds(nCasterLevel);
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2.0;
    //apply the effect
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration);

    PRCSetSchool();
}