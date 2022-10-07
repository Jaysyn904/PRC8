/*:://////////////////////////////////////////////
//:: Spell Name     Crafter's Curse
//:: Spell FileName sp_craftcurse.nss
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
Crafter's Curse

Transmutation
Level: Clr 1, Wit 1
Components: V, S, M/DF
Casting Time: 1 minute
Range: Touch
Target: Creature touched
Duration: 1 week
Saving Throw: Will negates
Spell Resistance: Yes

You place a curse on one creature that causes it to
suffer misfortune and lapses in use of any Craft
skill. The subject suffers a -10 competence penalty
on any Craft check and checks that fail by 10 or
more may result in serious consequences, such as
destruction of all raw materials being worked on,
loss of work, or even injury. A casting of bless,
crafter's blessing, remove curse, or break
enchantment will remove the crafter's curse.

Arcane material component: A piece of rotten wood
and a rusty or bent piece of metal.

//:://////////////////////////////////////////////
//:: Created By: xwarren
//::////////////////////////////////////////////*/

#include "prc_sp_func"

int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

    if(GetHasSpellEffect(SPELL_CRAFTERS_BLESSING, oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CRAFTERS_CURSE));

        //remove crafter's blessing and apply visual
        PRCRemoveEffectsFromSpell(oTarget, SPELL_CRAFTERS_BLESSING);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        return TRUE;
    }

    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eLink;
    int nDuration = 168;//one week (or should it be a tenday?)
    //check meta magic for extend
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = nDuration * 2;
    }

    eLink = EffectSkillDecrease(SKILL_CRAFT_ARMOR, 10);
    eLink = EffectLinkEffects(EffectSkillDecrease(SKILL_CRAFT_TRAP, 10), eLink);
    eLink = EffectLinkEffects(EffectSkillDecrease(SKILL_CRAFT_WEAPON, 10), eLink);
    eLink = EffectLinkEffects(EffectSkillDecrease(SKILL_CRAFT_ALCHEMY, 10), eLink);
    eLink = EffectLinkEffects(EffectSkillDecrease(SKILL_CRAFT_POISON, 10), eLink);
    eLink = EffectLinkEffects(EffectSkillDecrease(SKILL_CRAFT_GENERAL, 10), eLink);
    eLink = SupernaturalEffect(eLink);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CRAFTERS_CURSE));

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