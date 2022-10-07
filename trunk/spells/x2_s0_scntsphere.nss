//::///////////////////////////////////////////////
//:: Scintillating Sphere
//:: X2_S0_ScntSphere
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A scintillating sphere is a burst of electricity
// that detonates with a low roar and inflicts 1d6
// points of damage per caster level (maximum of 10d6)
// to all creatures within the area. Unattended objects
// also take damage. The explosion creates almost no pressure.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 25 , 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs, 02/06/2003
//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void ApplyDamage(object oTarget, effect eDamage)
{
    effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    PRCBonusDamage(oTarget);
}

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLvl + SPGetPenetr();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int EleDmg = ChangedElementalDamage(oCaster, DAMAGE_TYPE_ELECTRICAL);
    int nSaveType = ChangedSaveType(EleDmg);
    int nDamage;
    float fDelay;
    effect eDam;

    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 10)
        nCasterLvl = 10;

    //Apply the fireball explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_ELECTRIC_EXPLOSION), lTarget);

    //Cycle through the targets within the spell shape until an invalid object is captured.
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SCINTILLATING_SPHERE));

            if (!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))
            {
                //Roll damage for each target
                nDamage = d6(nCasterLvl);
                //Resolve metamagic
                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                    nDamage = 6 * nCasterLvl;
                if(nMetaMagic & METAMAGIC_EMPOWER)
                    nDamage += nDamage / 2;
                nDamage += SpellDamagePerDice(oCaster, nCasterLvl);
                    

                int nDC = PRCGetSaveDC(oTarget, oCaster);
                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType);

                if(nDamage > 0)
                {
                    //Get the distance between the explosion and the target to calculate delay
                    fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                    //Set the damage effect
                    eDam = PRCEffectDamage(oTarget, nDamage, EleDmg);
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyDamage(oTarget, eDam));
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    PRCSetSchool();
}