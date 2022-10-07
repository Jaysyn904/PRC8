/*
    Celebrant of Sharess dominates a creature under the effect of fascinate
*/

#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
	DecrementRemainingFeatUses(oPC, FEAT_CELEBRANT_SHARESS_FASCINATE);
	DecrementRemainingFeatUses(oPC, FEAT_CELEBRANT_SHARESS_CONFUSE);    
    object oTarget = PRCGetSpellTargetObject();
    int nClass = GetLevelByClass(CLASS_TYPE_CELEBRANT_SHARESS, oPC);
    int nCha = GetAbilityModifier(ABILITY_CHARISMA, oPC);

    int nDC = 10 + nClass + nCha;
    effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
    effect eConfuse = EffectCutsceneDominated();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eMind, eConfuse);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = SupernaturalEffect(eLink);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oPC, PRCGetSpellId()));
    if(GetHasSpellEffect(SPELL_SHARESS_FASCINATE, oTarget))
    {
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nClass));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
}