/*
sp_obscobj

Obscure Object

Abjuration
Level: Brd 1, Clr 3, Sor/Wiz 2 
Components: V, S, M/DF 
Casting Time: 1 standard action 
Range: Touch 
Target: One object touched
Duration: 8 hours (D) 
Saving Throw: Will negates (object) 
Spell Resistance: Yes (object)

This spell hides an object from location by divination (scrying) effects, such as the 
scrying spell or a crystal ball. Such an attempt automatically fails (if the divination 
is targeted on the object) or fails to perceive the object (if the divination is targeted 
on a nearby location, object, or person).

Arcane Material Component: A piece of chameleon skin.

Stratovarius
*/

#include "prc_sp_func"

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nSpellID = PRCGetSpellId();
    PRCSetSchool(GetSpellSchool(nSpellID));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eEffect = EffectLinkEffects(EffectSkillIncrease(SKILL_HEAL, 1), EffectSkillDecrease(SKILL_HEAL, 1));
    //VFX for start & end of the effect
    eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
    //get duration
    float fDuration = HoursToSeconds(8);
    if(PRCGetMetaMagicFeat() & METAMAGIC_EXTEND)
        fDuration *= 2.0;
    //apply the effect
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration);

    PRCSetSchool();
}