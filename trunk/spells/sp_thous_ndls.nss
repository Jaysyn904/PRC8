//::///////////////////////////////////////////////
//:: Name      Thousand Needles
//:: FileName  sp_thous_ndls.nss
//:://////////////////////////////////////////////
/**@file Thousand Needles
Conjuration (Creation) [Evil]
Level: Pain 5, Clr 6
Components: V, S, M
Casting Time: 1 action
Range: Medium (100 ft. + 10 ft./levels)
Target: One living creature
Duration: 1 minute/level
Saving Throw: Fortitude partial
Spell Resistance: Yes

A thousand needles surround the subject and pierce
his flesh, worming through armor or any type of
protection, although creatures with damage reduction
are immune to this spell. The subject takes 2d6
points of damage immediately and takes a -4
circumstance penalty on attack rolls, saving throws,
skill checks, and ability checks for the rest of the
spell's duration. A successful Fortitude save reduces
damage to half and negates the circumstance penalty.

Material Component: A handful of needles all of
which have drawn blood.

Author:    Tenjac
Created:   5/18/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
    //spellhook
    if(!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_COM_BLOOD_SPARK_LARGE);
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nPenalty = 4;
    int nDC = PRCGetSaveDC(oTarget, oPC);
    int nDam = d6(2);
    float fDur = (60.0f * nCasterLvl);

    PRCSignalSpellEvent(oTarget,TRUE, SPELL_THOUSAND_NEEDLES, oPC);

    if (!PRCDoResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()) && PRCGetIsAliveCreature(oTarget))
        {
        //metamagic
        if(nMetaMagic & METAMAGIC_EXTEND)
        {
            fDur = (fDur * 2);
        }

        if(nMetaMagic & METAMAGIC_MAXIMIZE)
        {
            nDam = 12;
        }

        if(nMetaMagic & METAMAGIC_EMPOWER)
        {
            nDam += (nDam/2);
        }
		nDam += SpellDamagePerDice(oPC, 2);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

        //Save
        if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
        {
            nDam = nDam/2;

            if (GetHasMettle(oTarget, SAVING_THROW_FORT))
            // This script does nothing if it has Mettle, bail
                return;
        }

        else
        {
            if(!PRCGetHasEffect(EFFECT_TYPE_DAMAGE_REDUCTION, oTarget))
            {
                effect eLink = EffectAttackDecrease(nPenalty, ATTACK_BONUS_MISC);
                eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, nPenalty, SAVING_THROW_TYPE_ALL));
                eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, nPenalty));

                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
            }
        }

        //Apply damage
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);
    }

    //SPEvilShift(oPC);
    PRCSetSchool();
}





