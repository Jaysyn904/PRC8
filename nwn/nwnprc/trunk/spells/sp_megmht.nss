/*
    sp_megmht

    Mangle of Egregious Might - +4 bonus to stats, attacks,
    saves, AC for 10 min / level.

    By: ???
    Created: ???
    Modified: Jul 2, 2006
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
    PRCSignalSpellEvent(oTarget, FALSE);
    // Boost stats, AC, attacks, stats, and saves by 4, and add the buff visual effect.
    // Shouldn't stack with itself. ~ Lock.
    if (!GetHasSpellEffect(SPELL_MANTLE_OF_EGREG_MIGHT, oTarget))
    {
        effect eList = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
        eList = EffectLinkEffects(eList, EffectAbilityIncrease(ABILITY_DEXTERITY, 4));
        eList = EffectLinkEffects(eList, EffectAbilityIncrease(ABILITY_CONSTITUTION, 4));
        eList = EffectLinkEffects(eList, EffectAbilityIncrease(ABILITY_INTELLIGENCE, 4));
        eList = EffectLinkEffects(eList, EffectAbilityIncrease(ABILITY_WISDOM, 4));
        eList = EffectLinkEffects(eList, EffectAbilityIncrease(ABILITY_CHARISMA, 4));
        eList = EffectLinkEffects(eList, EffectACIncrease(4));
        eList = EffectLinkEffects(eList, EffectAttackIncrease(4));
        eList = EffectLinkEffects(eList, EffectSavingThrowIncrease(SAVING_THROW_ALL, 4));
        eList = EffectLinkEffects(eList, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        //SetLocalInt(oTarget, "EgragiousM", 2); Does not seem to be used anywhere else - Ornedan
        // Get duration, 10 min / level unless extended.
        float fDuration = PRCGetMetaMagicDuration(TenMinutesToSeconds(nCasterLevel));
        // Build the list of fancy visual effects to apply when the spell goes off.
        effect eVisList = EffectLinkEffects(EffectVisualEffect(VFX_IMP_AC_BONUS), EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE));
        // Apply effects and VFX to target
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eList, oTarget, fDuration,TRUE,-1,nCasterLevel);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisList, oTarget);
    }

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