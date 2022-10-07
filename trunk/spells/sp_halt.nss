//::///////////////////////////////////////////////
//:: Name      Halt
//:: FileName  sp_halt.nss
//:://////////////////////////////////////////////
/**@file Halt
Transmutation
Level: Bard 3, beguilder 3, duskblade 3, sorcerer/wizard 3
Components: V
Casting Time: 1 immediate action
Range: Close
Target: One creature
Duration: 1 round
Saving Throw: Will negates
Spell Resistance: Yes

The subject creature's feet (or whatever pass for
its feet) become momentarily stuck to the floor.
The creature must stop moving, and cannot move
farter in its current turn.  This spell has no
effect on creatures that are not touching the
ground (such as flying creatures), and the subject
can still use a standard action to move by means of
teleporation magic.

**/

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nDC = PRCGetSaveDC(oTarget, oPC);
    float fDur = RoundsToSeconds(1);

    PRCSignalSpellEvent(oTarget,TRUE, SPELL_HALT, oPC);

    if(nMetaMagic & METAMAGIC_EXTEND)
    {
        fDur += fDur;
    }

    if (!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
    {
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
        {
            effect eHalt = EffectCutsceneImmobilize();

            //if(!flying)
            {
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHalt, oTarget, fDur);
            }
        }
    }

    PRCSetSchool();
}










