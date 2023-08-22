//::///////////////////////////////////////////////
//:: Name      Magic Insight
//:: FileName  inv_dra_maginst.nss
//::///////////////////////////////////////////////
/*

Least Invocation
2nd Level Spell

Over the next two rounds, the caster gains a bonus
of 10 +1 per caster level to their Lore skill.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(!PreInvocationCastCode()) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    int CasterLvl = GetInvokerLevel(oCaster, GetInvokingClass());
    int nBonus = 10 + CasterLvl;
    effect eLore = EffectSkillIncrease(SKILL_LORE, nBonus);
    effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eVis, eDur);
           eLink = EffectLinkEffects(eLink, eLore);

    //Make sure the spell has not already been applied
    if(!GetHasSpellEffect(SPELL_IDENTIFY, oCaster)
    || !GetHasSpellEffect(SPELL_LEGEND_LORE, oCaster)
    || !GetHasSpellEffect(INVOKE_MAGIC_INSIGHT, oCaster))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oCaster, EventSpellCastAt(oCaster, INVOKE_MAGIC_INSIGHT, FALSE));

        //Apply linked and VFX effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, RoundsToSeconds(2), TRUE, -1, CasterLvl);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
    }
}

