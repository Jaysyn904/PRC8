/*
    sp_heroism

    Consolidation of Heroism, Greater Heroism

    By: Flaming_Sword
    Created: Jul 1, 2006
    Modified: Jul 1, 2006

    Fixed typo
*/

#include "prc_sp_func"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nSpellID = PRCGetSpellId();
    PRCSignalSpellEvent(oTarget, FALSE);
    int bGreater = (nSpellID == SPELL_GREATER_HEROISM);
    if(bGreater && GetHasSpellEffect(SPELL_HEROISM, oTarget))
    {
        PRCRemoveSpellEffects(SPELL_HEROISM, oCaster, oTarget);
    }
    else if(!bGreater && GetHasSpellEffect(SPELL_GREATER_HEROISM, oTarget))
    {
        FloatingTextStringOnCreature("Target already has Greater Heroism Effect!", oCaster);
        return TRUE;
    }
    float fDuration = PRCGetMetaMagicDuration(TenMinutesToSeconds(nCasterLevel));
    int nBonus = (bGreater) ? 4 : 2;
    // Create the chain of buffs to apply, including the vfx.
    effect eBuff = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus, SAVING_THROW_TYPE_ALL);
    eBuff = EffectLinkEffects (eBuff, EffectAttackIncrease(nBonus, ATTACK_BONUS_MISC));
    eBuff = EffectLinkEffects (eBuff, EffectSkillIncrease(SKILL_ALL_SKILLS, nBonus));
    if(bGreater)
        eBuff = EffectLinkEffects (eBuff, EffectImmunity(IMMUNITY_TYPE_FEAR));
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration,TRUE,-1,nCasterLevel);
    //improperly removing gheroism when temp hp expire; fix by unlinking temp hp from other effect ~ Lockindal
    if(bGreater)
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(nCasterLevel > 20 ? 20 : nCasterLevel), oTarget, fDuration,TRUE,-1,nCasterLevel);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION), oTarget);

    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
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