//::///////////////////////////////////////////////
//:: Name      Touch of Juiblex
//:: FileName  sp_tch_Juiblex.nss
//:://////////////////////////////////////////////
/**@file Touch of Juiblex
Transmutation [Evil]
Level: Corrupt 3
Components: V, S, Corrupt
Casting Time: 1 action
Range: Touch
Target: Creature touched
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

The subject turns into green slime over the course of
4 rounds. If a remove curse, polymorph other, heal,
greater restoration, limited wish, miracle, or wish
spell is cast during the 4 rounds of transformation,
the subject is restored to normal but still takes 3d6
points of damage.

Corruption Cost: 1d6 points of Strength damage.

Author:    Tenjac
Created:   2/19/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"
void CountdownToSlime(object oTarget, int nCounter)
{
    if(nCounter > 0)
    {
        nCounter--;
        DelayCommand(6.0f, CountdownToSlime(oTarget, nCounter));
    }
    else
    {
        location lLoc = GetLocation(oTarget);

        //kill target
                            DeathlessFrenzyCheck(oTarget);
        effect eDeath = EffectDeath();
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);

        CreateObject(OBJECT_TYPE_CREATURE, "nw_ochrejellymed", lLoc);
    }
}

void main()
{
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    // Run the spellhook.
    if (!X2PreSpellCastCode()) return;

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nDC = PRCGetSaveDC(oTarget, oPC);
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nCounter = 4;

    PRCSignalSpellEvent(oTarget, TRUE, SPELL_TOUCH_OF_JUIBLEX, oPC);

    //Spell Resistance
    if (!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()) && PRCGetIsAliveCreature(oTarget))
    {
        //Save
        if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
        {
            //It's the final countdown
            CountdownToSlime(oTarget, nCounter);
        }
    }

    //Alignment shift
    //SPEvilShift(oPC);

    //Corruption cost
    int nCost = d6(1);
    DoCorruptionCost(oPC, ABILITY_STRENGTH, nCost, 0);

    //Corrupt spells get mandatory 10 pt evil adjustment, regardless of switch
    AdjustAlignment(oPC, ALIGNMENT_EVIL, 10, FALSE);

    PRCSetSchool();
}



