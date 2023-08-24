//::///////////////////////////////////////////////
//:: Name      Song of Festering Death
//:: FileName  sp_fester_death.nss
//:://////////////////////////////////////////////
/**@file Song of Festering Death
Evocation [Evil]
Level: Brd 2
Components: V
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One living creature
Duration: Concentration
Saving Throw: Fortitude negates
Spell Resistance: Yes

The caster sings a wailing ululation, requiring a
successful Perform (singing) check (DC 20). If the
Perform check succeeds and the target fails a
Fortitude saving throw, the subject's flesh
bubbles and festers into pestilent blobs, dealing
the subject 2d6 points of damage each round. If the
subject dies, she bursts with a sickening pop as
steamy gore spills onto the ground.

Author:    Tenjac
Created:   3/26/05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"
void FesterLoop(object oTarget, int nConc, int nHP, object oPC)
{
    if (nConc == FALSE)
    {
        return;
    }

    int nDam = d6(2);
    nDam += SpellDamagePerDice(oPC, 2);
    nHP = GetCurrentHitPoints(oTarget);
    effect eDam = PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL);

    if(nDam > nHP)
    {
        //esplode!
                            DeathlessFrenzyCheck(oTarget);
        effect eDeath = EffectDeath(TRUE, TRUE);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
    }
    else
    {
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    }

    //Loop
    DelayCommand(6.0f, FesterLoop(oTarget, nConc, nHP, oPC));

}


void main()
{
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    // Run the spellhook.
    if (!X2PreSpellCastCode()) return;

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nConc = TRUE;
    int nDC = PRCGetSaveDC(oTarget, oPC);
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nHP = GetCurrentHitPoints(oTarget);

    //Check for skill
    if(GetIsSkillSuccessful(oPC, SKILL_PERFORM, 20) && PRCGetIsAliveCreature(oTarget))
    {
        //Spell Resist
        if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
        {
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL, oPC, 1.0))
            {
                FesterLoop(oTarget, nConc, nHP, oPC);
            }
        }
    }

    //SPEvilShift(oPC);
    PRCSetSchool();
}
