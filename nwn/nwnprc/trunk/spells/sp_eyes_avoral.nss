//::///////////////////////////////////////////////
//:: Name      Eyes of the Avoral
//:: FileName  sp_eyes_avoral.nss
//:://////////////////////////////////////////////
/**@file Eyes of the Avoral
Transmutation
Level: Clr 1, Drd 1, Rgr 1, Sor/Wiz 1
Components: S
Casting Time: 1 standard action
Range: Touch
Target: One creature
Duration: 10 minutes/level
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

The subject gains an avoral's sharp eyesight,
receiving a +8 racial bonus on Spot checks for
the duration of the spell.

Author:    Tenjac
Created:   7/3/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;

        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nMetaMagic = PRCGetMetaMagicFeat();
        float fDur = (nCasterLvl * 600.0);

        if(nMetaMagic & METAMAGIC_EXTEND)
        {
                fDur += fDur;
        }

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_SPOT, 8), oTarget, fDur);

        PRCSetSchool();
}