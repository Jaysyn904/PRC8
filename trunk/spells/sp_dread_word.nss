//::///////////////////////////////////////////////
//:: Name      Dread Word
//:: FileName  sp_dread_word.nss
//:://////////////////////////////////////////////
/**@file Dread Word
Evocation [Evil]
Level: Demonologist 3, Sor/Wiz 3
Components: V
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One creature of good alignment
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

The caster speaks a single unique word of pure malevolence;
a powerful utterance from the Dark Speech. The word is so
foul that it harms the very soul of one that hears it. The
utterance of a dread word causes one subject within range
to take 1d3 points of Charisma drain. The power of this
spell protects the caster from the damaging effects of
both hearing and knowing the word.

To attempt to speak this unique word without using this spell
means instant death (and no effect, because the caster dies
before she gets the entire word out).

Author:    Tenjac
Created:   3/26/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    // Run the spellhook.
    if (!X2PreSpellCastCode()) return;

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nDam = d3(1);
    int nDC = PRCGetSaveDC(oTarget, oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCasterLvl = PRCGetCasterLevel(oPC);

    if (nMetaMagic & METAMAGIC_MAXIMIZE)
    {
        nDam = 3;
    }

    if (nMetaMagic & METAMAGIC_EMPOWER)
    {
        nDam += (nDam/2);
    }

    if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
    {
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL, oPC, 1.0))
        {
            effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

            //Apply 1d3 Cha DRAIN
            ApplyAbilityDamage(oTarget, ABILITY_CHARISMA, nDam, DURATION_TYPE_PERMANENT, TRUE);
        }
    }
    //SPEvilShift(oPC);
    PRCSetSchool();
}
