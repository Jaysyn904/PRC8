//::///////////////////////////////////////////////
//:: Call Lightning
//:: NW_S0_CallLghtn.nss
//:: Copyright (c) 2001 Bioware Corp.
//::///////////////////////////////////////////////
/*
Evocation [Electricity]
Level:            Drd 3
Components:       V, S
Casting Time:     1 round
Range:            Medium (100 ft. + 10 ft./level)
Effect:           One or more 30-ft.-long vertical lines of lightning
Duration:         1 min./level
Saving Throw:     Reflex half
Spell Resistance: Yes

Immediately upon completion of the spell, and once
per round thereafter, you may call down a 5-foot-wide,
30-foot-long, vertical bolt of lightning that deals
3d6 points of electricity damage. The bolt of lightning
flashes down in a vertical stroke at whatever target
point you choose within the spell’s range (measured
from your position at the time). Any creature in the
target square or in the path of the bolt is affected.

You need not call a bolt of lightning immediately;
other actions, even spellcasting, can be performed.
However, each round after the first you may use a
standard action (concentrating on the spell) to call
a bolt. You may call a total number of bolts equal to
your caster level (maximum 10 bolts).

If you are outdoors and in a stormy area—a rain shower,
clouds and wind, hot and cloudy conditions, or even a
tornado (including a whirlwind formed by a djinni or an
air elemental of at least Large size)—each bolt deals
3d10 points of electricity damage instead of 3d6.

This spell functions indoors or underground but not
underwater.

*/
//:://////////////////////////////////////////////
//:: Notes: totally not like PnP version,
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 22, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: modified by mr_bumpkin Dec 4, 2003

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLvl + SPGetPenetr();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDice = PRCMin(10, nCasterLvl);
    int EleDmg = ChangedElementalDamage(oCaster, DAMAGE_TYPE_ELECTRICAL);
    int nSaveType = ChangedSaveType(EleDmg);

    effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_M);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CALL_LIGHTNING));
            //Get the distance between the explosion and the target to calculate delay
            float fDelay = PRCGetRandomDelay(0.4, 1.75);
            if (!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))
            {
                //Roll damage for each target
                int nDamage = d6(nDice);
                //Resolve metamagic
                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                    nDamage = 6 * nDice;
                if(nMetaMagic & METAMAGIC_EMPOWER)
                   nDamage += nDamage / 2;

				nDamage += SpellDamagePerDice(oCaster, nDice);
                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, PRCGetSaveDC(oTarget, oCaster), nSaveType);
                if(nDamage > 0)
                {
                    //Set the damage effect
                    effect eDam = PRCEffectDamage(oTarget, nDamage, EleDmg);

                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    PRCBonusDamage(oTarget);
                }
            }
        }
       //Select the next target within the spell shape.
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    PRCSetSchool();
}
