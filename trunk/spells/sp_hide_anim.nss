//::///////////////////////////////////////////////
//:: Name      Hide from Animals
//:: FileName  sp_hide_anim.nss
//:://////////////////////////////////////////////
/** @file Hide from Animals
Abjuration
Level:            Drd 1, Rgr 1,
                  Justice of Weald and Woe 1
Components:       S, DF
Casting Time:     1 standard action
Range:            Touch
Targets:          One creature touched/level
Duration:         10 min./level (D)
Saving Throw:     Will negates (harmless)
Spell Resistance: Yes

Animals cannot see, hear, or smell the
warded creatures. Even extraordinary or
supernatural sensory capabilities, such as
blindsense, blindsight, scent, and tremorsense,
cannot detect or locate warded creatures.
Animals simply act as though the
warded creatures are not there. Warded
creatures could stand before the hungriest
of lions and not be molested or even
noticed. If a warded character touches an
animal or attacks any creature, even with a
spell, the spell ends for all recipients.

Author:    Tenjac
Created:   8/14/08
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

    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_HIDE_FROM_ANIMALS, FALSE));

    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
           eInvis = VersusRacialTypeEffect(eInvis, RACIAL_TYPE_ANIMAL);
    effect eVis   = EffectVisualEffect(VFX_IMP_HEAD_ODD);

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, fDur, TRUE, SPELL_HIDE_FROM_ANIMALS, nCasterLvl, oCaster);
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
