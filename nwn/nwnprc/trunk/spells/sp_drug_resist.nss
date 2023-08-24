//::///////////////////////////////////////////////
//:: Name      Drug Resistance
//:: FileName  sp_drug_resist.nss
//:://////////////////////////////////////////////
/**@file Drug Resistance
Enchantment
Level: Clr 1, Sor/Wiz 1
Components: V, M
Casting Time: 1 action
Range: Touch
Target: One living creature
Duration: 1 hour/level
Saving Throw: Fortitude negates (harmless)
Spell Resistance: Yes (harmless)

The creature touched is immune to the possibility
of addiction to drugs. He still experiences the
negative and positive effects of drugs during the
spell's duration. This spell does not free the
target from the effects of an addiction already
incurred. If the spell ends before the effects of
a drug wear off, the normal chance for addiction
applies.

Material Component: Three drops of pure water.

Author:    Tenjac
Created:   04/28/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    float fDur = HoursToSeconds(nCasterLvl);
    effect eMarker = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Spellhook
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);

    if (PRCGetIsAliveCreature(oTarget)) SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMarker, oTarget, fDur);

    PRCSetSchool();
}




