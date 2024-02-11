//::///////////////////////////////////////////////
//:: Name      Hide from Undead
//:: FileName  sp_hide_anim.nss
//:://////////////////////////////////////////////
/** @file Hide from Undead
Abjuration
Level: Clr 1, Dn 1
Components: V, S, DF
Casting Time: 1 standard action
Range: Touch
Targets: One creature touched/level
Duration: 10 min./level (D)
Saving Throw: Will negates (harmless)
Spell Resistance: Yes

Undead cannot see, hear, or smell the
warded creatures. Even extraordinary or
supernatural sensory capabilities, such as
blindsense, blindsight, scent, and tremorsense,
cannot detect or locate warded creatures.
If a warded creature attempts to turn or
command undead, touches an undead creature,
or attacks any creature (even with a spell),
the spell ends for all recipients.

Author:    Stratovarius
Created:   5/17/09
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_sp_func"

int DoSpell(object oCaster, object oTarget, int nCasterLvl)
{
    float fDur = (nCasterLvl * 600.0);
    int nMetaMagic = PRCGetMetaMagicFeat();
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDur *= 2;

    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_HIDE_FROM_UNDEAD, FALSE));

    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
           eInvis = VersusRacialTypeEffect(eInvis, RACIAL_TYPE_UNDEAD);
    effect eVis   = EffectVisualEffect(VFX_IMP_HEAD_ODD);

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, fDur, TRUE, SPELL_HIDE_FROM_UNDEAD, nCasterLvl, oCaster);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    return TRUE;// return TRUE if spell charges should be decremented
}

void main()
{
    if (!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_ABJURATION);
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {
            //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, nCasterLevel);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel))
            DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}
