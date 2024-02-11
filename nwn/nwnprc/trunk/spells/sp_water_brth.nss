//::///////////////////////////////////////////////
//:: Name      Water Breathing
//:: FileName  sp_water_brth.nss
//:://////////////////////////////////////////////
/** @file Water Breathing
Transmutation
Level: Clr 3, Drd 3, Sor/Wiz 3
Components: V, S, M/DF
Casting Time: 1 standard action
Range: Touch
Target: You and every allied creature within a 10 foot radius
Duration: 2 hours/level
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

You and your allies can breathe water freely. The spell does not make creatures unable to breathe air.

Author:    Tenjac
Created:   8/14/08
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_sp_func"

int DoSpell(object oCaster, object oTarget, int nCasterLevel)
{
    location lCaster = GetLocation(oCaster);
    float fDur = HoursToSeconds(nCasterLevel) * 2;
    int nMetaMagic = PRCGetMetaMagicFeat();
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDur *= 2;

    effect eVis = EffectVisualEffect(VFX_IMP_DEATH_WARD);
    effect eWater = EffectSpellImmunity(SPELL_DROWN);
    effect eWater2 = EffectSpellImmunity(SPELL_MASS_DROWN);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eWater, eWater2);
           eLink = EffectLinkEffects(eLink, eDur);

    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lCaster, FALSE, OBJECT_TYPE_CREATURE);

    while(GetIsObjectValid(oTarget))
    {
        if(GetIsReactionTypeFriendly(oTarget, oCaster))
        {
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_WATER_BREATHING, FALSE));

            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur, TRUE, SPELL_WATER_BREATHING, nCasterLevel);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lCaster, FALSE, OBJECT_TYPE_CREATURE);
    }
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