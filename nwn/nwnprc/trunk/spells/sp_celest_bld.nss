//::///////////////////////////////////////////////
//:: Name      Celestial blood
//:: FileName  sp_celest_bld.nss
//:://////////////////////////////////////////////
/**@file Celestial Blood
Abjuration [Good]
Level: Apostle of peace 6, Clr 6, Pleasure 6
Components: V, S, M
Casting Time: 1 round
Range: Touch
Target: Non-evil creature touched
Duration: 1 minute/level
Saving Throw: None
Spell Resistance: Yes (harmless)

You channel holy power to grant the subject some of
the protection enjoyed by celestial creatures. The
subject gains resistance 10 to acid, cold, and
electricity, a +4 bonus on saving throws against
poison, and damage reduction 10/evil.

Material Component: A vial of holy water, with
which you anoint the subject's head.

Author:    Tenjac
Created:   6/16/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_sp_func"

int DoSpell(object oCaster, object oTarget, int nCasterLevel)
{
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDur = TurnsToSeconds(nCasterLevel);
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDur *= 2;

    if(GetAlignmentGoodEvil(oTarget) != ALIGNMENT_EVIL)
    {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CELESTIAL_BLOOD, FALSE));

        effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);

        effect eLink = EffectDamageResistance(DAMAGE_TYPE_ACID, 10, 0);
               eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_COLD, 10, 0));
               eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 10, 0));
               eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_POISON));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

               //Can't do DR 10/evil
               eLink = EffectLinkEffects(eLink, EffectDamageReduction(10, DAMAGE_POWER_PLUS_TWO));

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur, TRUE, SPELL_CELESTIAL_BLOOD, nCasterLevel, oCaster);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
    //SPGoodShift(oCaster);

    return TRUE;
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