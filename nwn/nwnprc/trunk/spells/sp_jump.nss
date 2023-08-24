//::///////////////////////////////////////////////
//:: Name      Jump
//:: FileName  sp_jump.nss
//:://////////////////////////////////////////////
/*
Transmutation
Level:            Drd 1, Rgr 1, Sor/Wiz 1
Components:       V, S, M
Casting Time:     1 standard action
Range:            Touch
Target:           Creature touched
Duration:         1 min./level (D)
Saving Throw:     Will negates (harmless)
Spell Resistance: Yes

The subject gets a +10 enhancement bonus on Jump
checks. The enhancement bonus increases to +20 at
caster level 5th, and to +30 (the maximum) at
caster level 9th.

Material Component: A grasshopper’s hind leg,
which you break when the spell is cast.

By: Flaming_Sword
Created: Sept 27, 2006
Modified: Sept 27, 2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_sp_func"

int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDuration = TurnsToSeconds(nCasterLevel);
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;
    int nBonus = nCasterLevel >= 9 ? 30 : nCasterLevel >= 5 ? 20 : 10;

    PRCSignalSpellEvent(oTarget, FALSE, SPELL_SPELL_JUMP, oCaster);

    effect eBonus = EffectSkillIncrease(SKILL_JUMP, nBonus);
    effect eDur   = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink  = EffectLinkEffects(eBonus, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, SPELL_SPELL_JUMP, nCasterLevel);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    if (!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
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