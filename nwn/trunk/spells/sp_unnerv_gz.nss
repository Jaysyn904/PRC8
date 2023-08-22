//::///////////////////////////////////////////////
//:: Name      Unnerving Gaze
//:: FileName  sp_unnerv_gaze.nss
//:://////////////////////////////////////////////
/**@file Unnerving Gaze
Illusion (Phantasm)
Level: Demonologist 1, Mortal Hunter 1, Sor/Wiz 0
Components: V, S
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One humanoid creature
Duration: 1 round/level
Saving Throw: Will negates
Spell Resistance: Yes

The caster makes his face resemble one of the
opponent's departed loved ones or bitter enemies.
The subject takes a -1 morale penalty on attack
rolls for the duration of the spell.

Author:    Tenjac
Created:   5/12/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nDC = PRCGetSaveDC(oTarget, oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDur = RoundsToSeconds(nCasterLvl);

    //spellhook
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ILLUSION);

    if(nMetaMagic & METAMAGIC_EXTEND)
    {
        fDur += fDur;
    }

    if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
    {
        //Will save
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackDecrease(1, ATTACK_BONUS_MISC), oTarget, fDur);
        }
    }

    PRCSetSchool();
}
