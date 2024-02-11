//::///////////////////////////////////////////////
//:: Name      Sorrow
//:: FileName  sp_sorrow.nss
//:://////////////////////////////////////////////
/**@file Sorrow
Enchantment [Evil, Mind-Affecting]
Level: Brd 1, Clr 1
Components: V, S, M
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One living creature
Duration: 1 round/level
Saving Throw: Will negates
Spell Resistance: Yes

Grief and sadness overcome the subject. She takes
a -3 morale penalty on all attack rolls, saving
throws, ability checks, and skill checks.

Material Component: A tear.

Author:    Tenjac
Created:   05/02/06
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
    float fDur = RoundsToSeconds(nCasterLvl);
    effect eVis = EffectVisualEffect(VFX_DUR_GLOW_BLUE);

    //spellhook
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);

        PRCSignalSpellEvent(oTarget,TRUE, SPELL_SORROW, oPC);

    if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()) && PRCGetIsAliveCreature(oTarget))
    {
        //Save
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
        {
            effect eLink = EffectAttackDecrease(3, ATTACK_BONUS_MISC);
                   eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, 3, SAVING_THROW_TYPE_ALL));
                   eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, 3));
                   eLink = EffectLinkEffects(eLink, eVis);
                   //Can't do ability without modifying the ability score itself; skipping

            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget);
        }
    }

    //SPEvilShift(oPC);
    PRCSetSchool();
}
