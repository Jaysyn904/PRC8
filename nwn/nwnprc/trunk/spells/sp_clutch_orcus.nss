//::///////////////////////////////////////////////
//:: Name      Clutch of Orcus
//:: FileName  sp_clutch_orcus.nss
//:://////////////////////////////////////////////
/**@file Clutch of Orcus
Necromancy [Evil]
Level: Clr 3
Components: V, S
Casting Time: 1 action
Range: Medium (100 ft. + 10 ft./level)
Target: One humanoid
Duration: Concentration (see text)
Saving Throw: Fortitude  negates (see text)
Spell Resistance: Yes

The caster creates a magical force that grips the
subject's heart (or similar vital organ) and
begins crushing it. The victim is paralyzed
(as if having a heart attack) and takes 1d3 points
of damage per round.

Each round, the caster must concentrate to
maintain the spell. In addition, a conscious
victim gains a new saving throw each round to stop
the spell. If the victim dies as a result of this
spell, his chest ruptures and bursts, and his
smoking heart appears in the caster's hand.

Author:    Tenjac
Created:   3/28/05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"


void EFConcentrationHB(object oPC, object oTarget)
{
    if(GetBreakConcentrationCheck(oPC) > 0)
    {
        //FloatingTextStringOnCreature("Crafting: Concentration lost!", oPC);
        //DeleteLocalInt(oPC, PRC_CRAFT_HB);
        //return;
        SetLocalInt(oPC, "EFConcBroken", 1);
    }
    else
        DelayCommand(6.0f, EFConcentrationHB(oPC, oTarget));
}


void CrushLoop(object oTarget, object oPC, int bEndSpell, int nDC)
{

    //Conc check
    if(GetLocalInt(oPC, "EFConcBroken") == 1)
    {
        bEndSpell = TRUE;
    }

    //if makes save, abort
    if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
    {
        bEndSpell = TRUE;
    }

    //if Conc and failed save...
    if(bEndSpell = FALSE)
    {
        //Paral
        effect ePar = EffectParalyze();
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePar, oTarget, 6.0f);

        //damage
        int nDam = d3(1) + SpellDamagePerDice(oPC, 1);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);

        //if dead, end effect
        if(GetIsDead(oTarget))
        {
            effect eChunky = EffectVisualEffect(VFX_COM_CHUNK_RED_MEDIUM);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eChunky, oTarget);

            //End loop next time so it doesn't keep going forever
            bEndSpell = TRUE;
        }

        DelayCommand(6.0f, CrushLoop(oTarget, oPC, bEndSpell, nDC));
    }
}

void main()
{
    // Run the spellhook.
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    object oPC = OBJECT_SELF;
    object oTarget= PRCGetSpellTargetObject();
    int bEndSpell = FALSE;
    int nDC = PRCGetSaveDC(oTarget, oPC);
    int nCasterLvl = PRCGetCasterLevel(oPC);

    PRCSignalSpellEvent(oTarget, TRUE, SPELL_CLUTCH_OF_ORCUS, oPC);

    //Check spell resistance
    if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
    {
        //start loop
        DelayCommand(6.0f, EFConcentrationHB(oPC, oTarget));
        CrushLoop(oTarget, oPC, bEndSpell, nDC);
    }

    //SPEvilShift(oPC);
    PRCSetSchool();
}