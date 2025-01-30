//::///////////////////////////////////////////////
//:: Name      Necrotic Burst
//:: FileName  sp_nec_burst.nss
//:://////////////////////////////////////////////
/** @file
Necrotic Burst
Necromancy [Evil]
Level: Clr 5, sor/wiz 5
Components: V, S, F
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Target: Living creature with necrotic cyst
Duration: Instantaneous
Saving Throw: Fortitude partial
Spell Resistance: No

You cause the cyst of a subject already harboring a necrotic cyst
(see spell of the same name) to explosively enlarge itself at the
expense of the subject's body tissue. if the subject succeeds on
her saving throw, she takes 1d6 points of damage per level
(maximum 15d6), and half the damage is considered vile damage
(see necrotic bloat). The subject's cyst-derived saving throw
penalty against effects from the school of necromancy applies.

If the subject fails her saving throw, the cyst expands beyond
control, killing the subject. On the round following the subject's
death, the cyst exits the flesh of the slain subject as a free-willed
undead called a skulking cyst. The skulking cyst is formed from the
naked organs of the subject (usually the intestines, but also
including a mass of blood vessels, the odd bone or two, and
sometimes even half the lolling head).

    Author:    Tenjac
    Created:   9/22/05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "spinc_necro_cyst"
#include "inc_utility"
#include "prc_add_spell_dc"

void main()
{
    // Set the spellschool
    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    // Run the spellhook.
    if (!X2PreSpellCastCode()) return;


    object oPC = OBJECT_SELF;
    int nLevel = PRCMin(PRCGetCasterLevel(oPC), 15);
    int nMetaMagic = PRCGetMetaMagicFeat();
    object oTarget = PRCGetSpellTargetObject();

    PRCSignalSpellEvent(oTarget, TRUE, SPELL_NECROTIC_BURST, oPC);

    if(!GetCanCastNecroticSpells(oPC))
    return;

    if(!GetHasNecroticCyst(oTarget))
    {
        // "Your target does not have a Necrotic Cyst."
        SendMessageToPCByStrRef(oPC, nNoNecCyst);
        return;
    }

    //Define nDC

    int nDC = PRCGetSaveDC(oTarget, oPC);

    //Resolve spell
    if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
    {
        if(!GetHasMettle(oTarget, SAVING_THROW_FORT))
        {

            int nDam = d6(nLevel);

            //Metmagic: Maximize
            if (nMetaMagic & METAMAGIC_MAXIMIZE)
            {
                nDam = 6 * (nLevel);
            }

            //Metmagic: Empower
            if (nMetaMagic & METAMAGIC_EMPOWER)
            {
                nDam += (nDam/2);
            }
			nDam += SpellDamagePerDice(oPC, nLevel);
            int nVile = nDam/2;
            int nNorm = (nDam - nVile);
            //Vile damage is currently being applied as Positive damage
            effect eVileDam = PRCEffectDamage(oTarget, nVile, DAMAGE_TYPE_POSITIVE);
            effect eNormDam = PRCEffectDamage(oTarget, nNorm, DAMAGE_TYPE_MAGICAL);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVileDam, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eNormDam, oTarget);
        }
    }

    else
    {
        DeathlessFrenzyCheck(oTarget);
        effect eDeath = EffectDeath();

        eDeath = SupernaturalEffect(eDeath);
        effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
        RemoveCyst(oTarget);
        PRCSetSchool();
    }
    //SPEvilShift(oPC);
}

