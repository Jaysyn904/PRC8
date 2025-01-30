//::///////////////////////////////////////////////
//:: Burning Hands
//:: NW_S0_BurnHand
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Evocation [Fire]
Level:            Fire 1, Sor/Wiz 1
Components:       V, S
Casting Time:     1 standard action
Range:            15 ft.
Area:             Cone-shaped burst
Duration:         Instantaneous
Saving Throw:     Reflex half
Spell Resistance: Yes

A cone of searing flame shoots from your fingertips.
Any creature in the area of the flames takes 1d4
points of fire damage per caster level (maximum 5d4).
Flammable materials burn if the flames touch them.
A character can extinguish burning items as a
full-round action.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 5, 2001
//:://////////////////////////////////////////////
//:: Last Updated On: April 5th, 2001
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 23, 2001
//:: modified by mr_bumpkin Dec 4, 2003

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLevel + SPGetPenetr();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int EleDmg = ChangedElementalDamage(oCaster, DAMAGE_TYPE_FIRE);
    int nSaveType = ChangedSaveType(EleDmg);
    int nDice = PRCMin(5, nCasterLevel);
    int nDamage;
    float fDist;

    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            //Signal spell cast at event to fire.
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BURNING_HANDS));
            //Calculate the delay time on the application of effects based on the distance
            //between the caster and the target
            fDist = GetDistanceBetween(oCaster, oTarget)/20;
            //Make SR check, and appropriate saving throw.
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDist) && oTarget != oCaster)
            {
                nDamage = d4(nDice);
                //Enter Metamagic conditions
                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                     nDamage = 4 * nDice;//Damage is at max
                if(nMetaMagic & METAMAGIC_EMPOWER)
                     nDamage += nDamage / 2; //Damage/Healing is +50%

				nDamage += SpellDamagePerDice(oCaster, nDice);
                //Run the damage through the various reflex save and evasion feats
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, PRCGetSaveDC(oTarget, oCaster), nSaveType);
                if(nDamage > 0)
                {
                    effect eFire = PRCEffectDamage(oTarget, nDamage, EleDmg);

                    // Apply effects to the currently selected target.
                    DelayCommand(fDist, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDist, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
                    PRCBonusDamage(oTarget);
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    PRCSetSchool();
}
