//::///////////////////////////////////////////////
//:: Name      Longstrider
//:: FileName  sp_longstrdr.nss
//:://////////////////////////////////////////////
/** @file Longstrider
Transmutation
Level: Drd 1, Rgr 1
Components: V, S
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 hour/level 

This spell increases your base land speed by 10 feet.

Author:    Tenjac
Created:   8/14/08
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    object oPC = OBJECT_SELF;
    int nCasterLvl = PRCGetCasterLevel(oPC);
    float fDur = HoursToSeconds(nCasterLvl);
    if(PRCGetMetaMagicFeat() & METAMAGIC_EXTEND)
        fDur *= 2;

    effect eSpeed = EffectLinkEffects(EffectMovementSpeedIncrease(33),
                    EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_LONGSTRIDER, FALSE));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LONGSTRIDER), oPC);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpeed, oPC, fDur, TRUE, SPELL_LONGSTRIDER, nCasterLvl);

    PRCSetSchool();
}