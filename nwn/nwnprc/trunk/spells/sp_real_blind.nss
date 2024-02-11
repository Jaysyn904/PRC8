//::///////////////////////////////////////////////
//:: Name      Reality Blind
//:: FileName  sp_real_blind.nss
//:://////////////////////////////////////////////
/**@file Reality Blind
Illusion (Phantasm) [Evil, Mind­Affecting]
Level: Sor/Wiz 3
Components: V, S, M
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One creature
Duration: Concentration (see below)
Saving Throw: Will negates
Spell Resistance: Yes

This spell overwhelms the target with hallucinations,
causing him to be blinded and stunned if he fails
the save. The subject can attempt a new saving throw
each round to end the spell.

Even after the subject succeeds at the save or the
caster stops concentrating, the subject is plagued
with nightmares every night. The nightmares prevent
the subject from benefiting from natural healing.
These nightmares continue until the caster dies or
the subject succeeds at a Will saving throw, attempted
once per night. This nightmare effect is treated as a
curse and thus cannot be dispelled. It is subject to
remove curse, however.

Material Component: A 2-inch diameter multicolored
disk of paper or ribbon.

Author:    Tenjac
Created:   6/6/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
void BlindLoop(object oTarget, object oPC);

#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()

{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ILLUSION);

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oPC);

    PRCSignalSpellEvent(oTarget,TRUE, SPELL_REALITY_BLIND, oPC);

    if(!PRCDoResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
        {
        //Loop
        BlindLoop(oTarget, oPC);
    }
    PRCSetSchool();
    //SPEvilShift(oPC);
}


void BlindLoop(object oTarget, object oPC)
{
    int nDC = PRCGetSaveDC(oTarget, oPC);

    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_EVIL)) //&& Conc check successful
    {
        effect eBlind = EffectLinkEffects(EffectBlindness(), EffectStunned());
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, 6.0f);

        //Schedule next round
        DelayCommand(6.0f, BlindLoop(oTarget, oPC));
    }

    else
    {
        //Non healing code
        SetLocalInt(oPC, "PRC_NoNaturalHeal", 1);
    }
}






