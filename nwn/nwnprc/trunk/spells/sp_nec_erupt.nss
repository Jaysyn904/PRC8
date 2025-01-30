//::///////////////////////////////////////////////
//:: Name      Necrotic Eruption
//:: FileName  sp_nec_erupt.nss
//:://////////////////////////////////////////////
/** @file
Necrotic Eruption
Necromancy [Evil]
Level: Clr 6, sor/wiz 6
Components: V, S, F
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Target: Living creature with necrotic cyst and all creatures in 20 ft. Radius spread
Duration: Instantaneous
Saving Throw: Fortitude partial
Spell Resistance: No

You cause the cyst of a subject already harboring a necrotic cyst
(see spell of the same name) to explosively enlarge itself at the
expense of the subject's body tissue, harming both the subject
(and nearby creatures if the subject fails his save). if the
subject succeeds on his saving throw, he takes 1d6 points of damage
 per level (maximum 15d6), and half the damage is considered vile
damage (see necrotic bloat). The subject's cyst-derived saving throw
 penalty against effects from the school of necromancy applies.

If the subject fails his saving throw, the cyst expands beyond control,
 killing the subject. All creatures within 20 feet of the subject take
1d6 points of damage per level (maximum 15d6; Reflex half), and half the
 damage taken is considered vile damage. All creatures in range that take
this secondary damage are also exposed to the effect of the base necrotic
cyst spell. On the round following the subject's death, the cyst exits the
 flesh of the slain subject as a free-willed undead called a skulking cyst.

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
    object oTarget = PRCGetSpellTargetObject();
    int nLevel = PRCMin(PRCGetCasterLevel(oPC), 15);
    int nMetaMagic = PRCGetMetaMagicFeat();

    PRCSignalSpellEvent(oTarget, TRUE, SPELL_NECROTIC_ERUPTION, oPC);

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
        //Kill target
        DeathlessFrenzyCheck(oTarget);
        effect eDeath = EffectDeath();
        effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
        RemoveCyst(oTarget);

        //Apply same damage above in ALL creatures in 20 foot radius of target
        location lTarget = PRCGetSpellTargetLocation();
        //Declare the spell shape, size and the location.  Capture the first target object in the shape.
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);

        //Cycle through the targets within the spell shape until an invalid object is captured.
        while (GetIsObjectValid(oTarget))
        {
            int nDam = d6(nLevel);
            nDam += SpellDamagePerDice(oPC, nLevel);
            int nVile = nDam/2;
            int nNorm = (nDam - nVile);
            //Vile damage is currently being applied as Positive damage
            effect eVileDam = PRCEffectDamage(oTarget, nVile, DAMAGE_TYPE_POSITIVE);
            effect eNormDam = PRCEffectDamage(oTarget, nNorm, DAMAGE_TYPE_MAGICAL);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVileDam, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eNormDam, oTarget);
            //Apply Necrotic Cyst to target
            AssignCommand(oPC, ActionCastSpellAtObject(SPELL_NECROTIC_CYST, oTarget, METAMAGIC_NONE, TRUE, 6, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));

            //Select the next target within the spell shape.
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }
    }

    //SPEvilShift(oPC);

    PRCSetSchool();
}
