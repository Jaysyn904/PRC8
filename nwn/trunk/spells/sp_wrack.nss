//::///////////////////////////////////////////////
//:: Name      Wrack
//:: FileName  sp_wrack.nss
//:://////////////////////////////////////////////
/**@file Wrack
Necromancy [Evil]
Level: Clr 3, Mortal Hunter 3, Pain 3, Sor/Wiz 4
Components: V, S
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Area: One humanoid creature
Duration: 1 round/level
Saving Throw: Fortitude negates
Spell Resistance: Yes

The subject is wracked with such pain that he doubles
over and collapses. His face and hands blister and
drip fluid, and his eyes cloud with blood, rendering
him blind. For the duration of the spell the subject
is considered helpless and cannot take actions. The
subject's sight returns when the spell's duration
expires.

Even after the spell ends, the subject is still
visibly shaken and takes a -2 penalty on attack rolls,
saves, and checks for 3d10 minutes.

Author:    Tenjac
Created:   5/10/06
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
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDC = PRCGetSaveDC(oTarget, oPC);
    float fDur = (6.0f * nCasterLvl);
    effect eBlind = EffectBlindness();
    int nPenalty = 2;

    //Spellhook
    if(!X2PreSpellCastCode()) return;
    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    if(nMetaMagic & METAMAGIC_EXTEND)
    {
        fDur = (fDur * 2);
    }

    if(nMetaMagic & METAMAGIC_EMPOWER)
    {
        nPenalty += (nPenalty/2);
    }

    //Check Spell Resistance
    if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
    {
        //Will save
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
        {
            //Blind
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, fDur);

            //Clear all actions
            AssignCommand(oTarget, ClearAllActions());

            //Animation
            AssignCommand(oTarget, PlayAnimation(ANIMATION_LOOPING_SPASM, 6.0f));
            DelayCommand(6.0f,AssignCommand(oTarget, PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, (fDur - 6.0f))));

            //Make them sit and wait.
            DelayCommand(6.2,SetCommandable(FALSE, oTarget));

            //Restore Control
            DelayCommand((fDur - 6.2), SetCommandable(TRUE, oTarget));

            //After spell end
            effect eLink = EffectAttackDecrease(nPenalty, ATTACK_BONUS_MISC);
                   eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, nPenalty, SAVING_THROW_TYPE_ALL));
                   eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, nPenalty));

            DelayCommand(fDur, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, (d10(3) * 60.0f)));
        }
    }

    //SPEvilShift(oPC);
    PRCSetSchool();
}

