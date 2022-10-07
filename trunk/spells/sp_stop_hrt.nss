//::///////////////////////////////////////////////
//:: Name      Stop Heart
//:: FileName  sp_stop_hrt.nss
//:://////////////////////////////////////////////
/**@file Stop Heart
Necromancy [Evil]
Level: Asn 4, Clr 4, Sor/Wiz 5
Components: S, Drug
Casting Time: 1 action
Range: Touch
Area: One living humanoid or animal
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

Channeling hatred and spite, the caster calls upon
dark power to give the subject a massive heart
attack. The subject suddenly drops to -8 hit points,
then -9 hit points at the end of this round. If
someone immediately makes a successful Heal check
(DC 15) or somehow gives the subject more hit points,
she stabilizes. Otherwise, at the end of the next
round, the subject reaches -10 hit points and dies.

Drug Component: Baccaran.

Author:    Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void Deathloop(object oTarget, int nHP, int nCounter)
{
    //if the target's HP has increased, break loop
    if(GetCurrentHitPoints(oTarget) > nHP)
    {
        nCounter = 0;
    }

    effect eDam;

    if(nCounter > 0)
    {
        //Round 1
        if(nCounter == 3)
        {
            eDam = PRCEffectDamage(oTarget, (nHP - 2), DAMAGE_TYPE_MAGICAL);
        }

        //Round 2
        if(nCounter == 2)
        {
            eDam = PRCEffectDamage(oTarget, (nHP -1), DAMAGE_TYPE_MAGICAL);
        }

        //Round 3 - should have drank that healing potion
        if (nCounter == 1)
        {
            DeathlessFrenzyCheck(oTarget);
            eDam = EffectDeath();
        }

        //Apply appropriate effect
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);

        //Reset nHP
        nHP = GetCurrentHitPoints(oTarget);

        nCounter--;

        DelayCommand(6.0f, Deathloop(oTarget, nHP, nCounter));
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nHP = GetCurrentHitPoints(oTarget);
    int nDC = PRCGetSaveDC(oTarget, oPC);
    int nCounter = 2;
    int nCasterLvl = PRCGetCasterLevel(oPC);

    //Spellhook
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    //must be under effect of baccaran
    if(GetHasSpellEffect(SPELL_BACCARAN, oPC))
    {
        //Spell Resistance
        if(!PRCDoResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()) && PRCGetIsAliveCreature(oTarget))
        {
            //Fort save
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
            {
                //They should be unable to act via PnP
                effect ePar = EffectCutsceneParalyze();
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePar, oTarget, 19.0f);

                //Sucker...
                Deathloop(oTarget, nHP, nCounter);
            }
        }
    }


    //SPEvilShift(oPC);
    PRCSetSchool();
}
