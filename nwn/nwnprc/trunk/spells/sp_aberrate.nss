//::///////////////////////////////////////////////
//:: Name      Aberrate
//:: FileName  sp_aberrate.nss
//:://////////////////////////////////////////////
/**@file Aberrate
Transmutation [Evil]
Level: Sor/Wiz 1
Components: V, S, Fiend
Casting Time: 1 action
Range: Touch
Target: One living creature
Duration: 10 minutes/level
Saving Throw: Fortitude negates
Spell Resistance: Yes

The caster transforms one creature into an aberration.
The subject's form twists and mutates into a hideous
mockery of itself. The subject's type changes to
aberration, and it gains a +1 natural armor bonus to
AC (due to the toughening and twisting of the flesh)
for every four levels the caster has, up to a maximum
of +5.

Author:    Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "prc_sp_func"
#include "prc_add_spell_dc"

int DoSpell(object oCaster, object oTarget, int nCasterLvl, int nEvent)
{
    object oSkin = GetPCSkin(oTarget);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDC = PRCGetSaveDC(oTarget, oCaster);
    float fDur = (600.0f * nCasterLvl);
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDur = fDur * 2;
    int bFriendly = TRUE;
    if(oCaster == oTarget) bFriendly = FALSE;

    //Signal spell firing
    PRCSignalSpellEvent(oTarget, bFriendly, SPELL_ABERRATE, oCaster);

    //if friendly
    if(GetIsReactionTypeFriendly(oTarget, oCaster) ||
    //or failed SR check
    (!PRCDoResistSpell(oCaster, oTarget, nCasterLvl + SPGetPenetr())) && PRCGetIsAliveCreature(oTarget))
    {
        //if friendly
        if(GetIsReactionTypeFriendly(oTarget, oCaster) ||
        //or failed save
        (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL)))
        {
            int nBonus = 1;

            if(nCasterLvl > 7) nBonus = 2;

            if(nCasterLvl > 11) nBonus = 3;

            if(nCasterLvl > 15) nBonus = 4;

            if(nCasterLvl > 19) nBonus = 5;

            itemproperty ipRace = PRCItemPropertyBonusFeat(FEAT_ABERRATION);
            effect eArmor = EffectACIncrease(nBonus, AC_NATURAL_BONUS);
            effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);

            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ipRace, oSkin, fDur);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eArmor, oTarget, fDur, TRUE, SPELL_ABERRATE, nCasterLvl, oCaster);
        }
    }
    //SPEvilShift(oCaster);

    return TRUE;// return TRUE if spell charges should be decremented
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
        {
            //holding the charge, casting spell on self
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
