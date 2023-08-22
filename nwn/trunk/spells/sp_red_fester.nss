//::///////////////////////////////////////////////
//:: Name: Red Fester
//:: Filename: sp_red_fester.nss
//::///////////////////////////////////////////////
/**Red Fester
Necromancy [Evil]
Level: Corrupt 3
Components: V, S, Corrupt
Casting Time: 1 action
Range: Touch
Target: Creature touched
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

The subject's skin turns red and blisters. The
blisters quickly turn into oozing wounds. Furthermore,
the subject's sense of self becomes strangely clouded,
diminishing her self-esteem. The subject takes 1d6
points of Strength damage and 1d4 points of Charisma
damage.

Corruption Cost: 1d6 points of Strength damage.

@author Written By: Tenjac
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "inc_abil_damage"
#include "prc_add_spell_dc"
void main()
{
    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    // Run the spellhook.
    if (!X2PreSpellCastCode()) return;

    //define vars
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel();
    int nMetaMagic = PRCGetMetaMagicFeat();
        int nPenetr = nCasterLvl + SPGetPenetr();

    //signal cast
    PRCSignalSpellEvent(oTarget, TRUE, SPELL_RED_FESTER, oPC);

    //Spell Resist
    if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr))
    {
        //Fort save
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget,oPC)))
        {
            //1d6 STR
            ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, d6(1), DURATION_TYPE_PERMANENT, FALSE, 0.0f, FALSE, oPC);

            //1d4 CHA
            ApplyAbilityDamage(oTarget, ABILITY_CHARISMA, d4(1), DURATION_TYPE_PERMANENT, FALSE, 0.0f, FALSE, oPC);
        }
    }

    //Corruption cost 1d6 STR
    int nCost = d6(1);
    DoCorruptionCost(oPC, ABILITY_STRENGTH, nCost, 0);

    //Corrupt spells get mandatory 10 pt evil adjustment, regardless of switch
    AdjustAlignment(oPC, ALIGNMENT_EVIL, 10, FALSE);

    //SPEvilShift(oPC);
    PRCSetSchool();
}