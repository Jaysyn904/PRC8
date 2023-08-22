/*:://////////////////////////////////////////////
//:: Spell Name     Crafter's Blessing
//:: Spell FileName sp_craftbless.nss
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
Crafter's Blessing

Transmutation
Level: Clr 1, Wit 1
Components: V, S, M/DF
Casting Time: 1 minute
Range: Touch
Target: Creature touched
Duration: 1 week
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

The creature you touch gains good fortune and skill
in crafts, gaining a +10 competence bonus on Craft
checks for a week's worth of work. The subject's
work will generally be faster and of better quality
than normal. It will at least be competent, although
an unskilled crafter will still not easily produce
masterworks.

Arcane material component: A few wood shavings and
a small piece of metal.

//:://////////////////////////////////////////////
//:: Created By: xwarren
//::////////////////////////////////////////////*/

#include "prc_sp_func"

int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    if(GetHasSpellEffect(SPELL_CRAFTERS_CURSE, oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CRAFTERS_BLESSING, FALSE));

        //remove crafter's curse and apply visual
        PRCRemoveEffectsFromSpell(oTarget, SPELL_CRAFTERS_CURSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REMOVE_CONDITION), oTarget);
        return TRUE;
    }

    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eLink, eVis;
    int nDuration = 168;//one week (or should it be a tenday?)
    //check meta magic for extend
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = nDuration * 2;
    }

    eLink = EffectSkillIncrease(SKILL_CRAFT_ARMOR, 10);
    eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_CRAFT_TRAP, 10), eLink);
    eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_CRAFT_WEAPON, 10), eLink);
    eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_CRAFT_ALCHEMY, 10), eLink);
    eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_CRAFT_POISON, 10), eLink);
    eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_CRAFT_GENERAL, 10), eLink);
    eLink = SupernaturalEffect(eLink);
    eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CRAFTERS_BLESSING, FALSE));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration),TRUE,-1,nCasterLevel);

    return TRUE;    //return TRUE if spell charges should be decremented
}


void main()
{
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
    if (!X2PreSpellCastCode()) return;
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}