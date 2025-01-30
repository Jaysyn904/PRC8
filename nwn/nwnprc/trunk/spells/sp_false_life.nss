//::///////////////////////////////////////////////
//:: Name      False Life
//:: FileName  sp_false_life.nss
//:://////////////////////////////////////////////
/**@file False Life
Necromancy
Level: Sor/Wiz 2, Hexblade 2
Components: V, S, M
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 hour/level or until discharged; see text

You harness the power of unlife to grant yourself a
limited ability to avoid death. While this spell is
in effect, you gain temporary hit points equal to 
1d10 +1 per caster level (maximum +10).

Material Component: A small amount of alcohol or 
distilled spirits, which you use to trace certain 
sigils on your body during casting. These sigils 
cannot be seen once the alcohol or spirits evaporate.

**/

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    object oPC = OBJECT_SELF;
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDur = HoursToSeconds(nCasterLvl);
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDur *= 2;

    int nBonus = d10(1) + (PRCMin(10, nCasterLvl));
    if(nMetaMagic & METAMAGIC_MAXIMIZE)
        nBonus = 10 + (PRCMin(10, nCasterLvl));
    if(nMetaMagic & METAMAGIC_EMPOWER)
        nBonus += (nBonus/2);

    PRCRemoveEffectsFromSpell(oPC, SPELL_FALSE_LIFE);

    PRCSignalSpellEvent(oPC, FALSE, SPELL_FALSE_LIFE, oPC);

    effect eHP = EffectTemporaryHitpoints(nBonus);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eHP, eDur);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_EVIL);

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur, TRUE, SPELL_FALSE_LIFE, nCasterLvl, oPC);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

    PRCSetSchool();
}
