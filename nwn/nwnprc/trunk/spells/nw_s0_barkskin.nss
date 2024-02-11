//::///////////////////////////////////////////////
//:: Barkskin
//:: nw_s0_barkskin.nss
//::///////////////////////////////////////////////
/*
Transmutation
Level:            Drd 2, Rgr 2, Plant 2
Components:       V, S, DF
Casting Time:     1 standard action
Range:            Touch
Target:           Living creature touched
Duration:         10 min./level
Saving Throw:     None
Spell Resistance: Yes (harmless)

Barkskin toughens a creature’s skin. The effect
grants a +2 enhancement bonus to the creature’s
existing natural armor bonus. This enhancement
bonus increases by 1 for every three caster levels
above 3rd, to a maximum of +5 at caster level 12th.

The enhancement bonus provided by barkskin stacks
with the target’s natural armor bonus, but not with
other enhancement bonuses to natural armor. A
creature without natural armor has an effective
natural armor bonus of +0.
*/
//:://////////////////////////////////////////////
//:: By: Preston Watamaniuk
//:: Created: Feb 21, 2001
//:: Modified: Jun 12, 2006
//:://////////////////////////////////////////////

#include "prc_sp_func"

int DoSpell(object oCaster, object oTarget, int nCasterLevel)
{
    if(!PRCGetIsAliveCreature(oTarget))
    {
        FloatingTextStringOnCreature("Selected target is not a living creature.", oCaster, FALSE);
        return FALSE;
    }

    float fDuration = TurnsToSeconds(nCasterLevel) * 10;
    //Enter Metamagic conditions
    int nMetaMagic = PRCGetMetaMagicFeat();
    if(nMetaMagic & METAMAGIC_EXTEND) //Duration is +100%
        fDuration *= 2;

    //Determine AC Bonus based Level.
    int nBonus = (nCasterLevel / 3) + 1;
    if(nBonus > 5)
        nBonus = 5;

    //Make sure the Armor Bonus is of type Natural
    effect eLink = EffectACIncrease(nBonus, AC_NATURAL_BONUS);
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROT_BARKSKIN));
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    effect eHead = EffectVisualEffect(VFX_IMP_HEAD_NATURE);

    //Signal spell cast at event
    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BARKSKIN, FALSE));

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, SPELL_BARKSKIN, nCasterLevel);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHead, oTarget);

    return TRUE; //return TRUE if spell charges should be decremented
}

void main()
{
    if (!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel();
    int nEvent = GetLocalInt(OBJECT_SELF, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(OBJECT_SELF, PRC_SPELL_HOLD) && OBJECT_SELF == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(OBJECT_SELF, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(OBJECT_SELF, oTarget, nCasterLevel);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(OBJECT_SELF, oTarget, nCasterLevel))
                DecrementSpellCharges(OBJECT_SELF);
        }
    }
    PRCSetSchool();
}