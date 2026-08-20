//::///////////////////////////////////////////////
//:: Name      Glibness
//:: FileName  sp_glibness.nss
//:://////////////////////////////////////////////
/**@file Glibness
Transmutation
Level:        Brd 3
Components:   S
Casting Time: 1 standard action
Range:        Personal
Target:       You
Duration:     10 min./level (D)

Your speech becomes fluent and more believable. You
gain a +30 bonus on Bluff checks made to convince
another of the truth of your words. (This bonus
doesn’t apply to other uses of the Bluff skill, such
as feinting in combat, creating a diversion to hide,
or communicating a hidden message via innuendo.)

If a magical effect is used against you that would
detect your lies or force you to speak the truth the
user of the effect must succeed on a caster level
check (1d20 + caster level) against a DC of 15 + your
caster level to succeed. Failure means the effect
does not detect your lies or force you to speak only
the truth.

Author:   Flaming_Sword
Created:  Oct 4, 2006
Modified: Oct 4, 2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"

void main()
{
    if (!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDuration = 600.0 * nCasterLevel;
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;

    effect eSkill = EffectSkillIncrease(SKILL_BLUFF, 30);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eLink = EffectLinkEffects(eSkill, eCessate);

    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_GLIBNESS, FALSE));

    PRCRemoveEffectsFromSpell(oTarget, SPELL_GLIBNESS);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, -1, nCasterLevel);

    PRCSetSchool();
}