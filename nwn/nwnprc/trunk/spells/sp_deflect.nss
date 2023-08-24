//::///////////////////////////////////////////////
//:: Name     Lesser Deflect
//:: FileName  sp_deflect.nss
//:://////////////////////////////////////////////
/**@file Lesser Deflect
Abjuration [Force]
Level: Duskblade 1, sorcerer/wizard 1
Components: V
Casting Time: 1 immediate action
Range: Personal
Duration: 1 round or until discharged

You project a field of ivisible force, creating a
short-lived protective barrier.  You gain a 
deflection bonus to your AC against a single attack;
this bonus is equal to +1 per three caster levels
(maximum +5).

**/

//::///////////////////////////////////////////////
//:: Name     Deflect
//:: FileName  sp_deflect.nss
//:://////////////////////////////////////////////
/**@file Deflect
Abjuration [Force]
Level: Duskblade 2, sorcerer/wizard 2
Components: V
Casting Time: 1 immediate action
Range: Personal
Duration: 1 round or until discharged


You project a field of ivisible force, creating a
short-lived protective barrier.  You gain a 
deflection bonus to your AC against a single attack;
this bonus is equal to 1/2 your caster level 
(round down).

**/

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ABJURATION);

    object oPC = OBJECT_SELF;
    float fDur = RoundsToSeconds(1);
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nSpell = PRCGetSpellId();
    int nBonus = nSpell == SPELL_DEFLECT ? nCasterLvl/2:
                 min(5, (nCasterLvl/3));

    PRCSignalSpellEvent(oPC, FALSE, nSpell, oPC);

    if(nMetaMagic & METAMAGIC_EXTEND)
        fDur *= 2;

    effect eBonus = EffectACIncrease(AC_DEFLECTION_BONUS, nBonus);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, fDur);

    PRCSetSchool();
}