//::///////////////////////////////////////////////
//:: Flame Strike
//:: NW_S0_FlmStrike
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A flame strike is a vertical column of divine fire
// roaring downward. The spell deals 1d6 points of
// damage per level, to a maximum of 15d6. Half the
// damage is fire damage, but the rest of the damage
// results directly from divine power and is therefore
// not subject to protection from elements (fire),
// fire shield (chill shield), etc.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 19, 2000
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: Aug 1, 2001
//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"  
#include "prc_add_spell_dc"

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
    int EleDmg = ChangedElementalDamage(oCaster, DAMAGE_TYPE_FIRE);
    int nSaveType = ChangedSaveType(EleDmg);
    int nDice = PRCMin(15, nCasterLvl);

    int nDamage, nDamage2;
    effect eStrike = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_FIRE);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    effect eHoly, eFire;

    //Apply the location impact visual to the caster location instead of caster target creature.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, lTarget);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, FALSE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_PLACEABLE|OBJECT_TYPE_DOOR);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FLAME_STRIKE));

            //Make SR check, and appropriate saving throw(s).
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr, 0.6))
            {
                nDamage = d6(nDice);
                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                    nDamage = 6 * nDice;
                if(nMetaMagic & METAMAGIC_EMPOWER)
                    nDamage = nDamage + (nDamage/2);
				nDamage += SpellDamagePerDice(oCaster, nDice);
                //Adjust the damage based on Reflex Save, Evasion and Improved Evasion
                int nDC = PRCGetSaveDC(oTarget, oCaster);
                nDamage2 = PRCGetReflexAdjustedDamage(nDamage/2, oTarget, nDC, nSaveType);

                //Make a faction check so that only enemies receieve the full brunt of the damage.
                if(!GetIsFriend(oTarget))
                {
                    nDamage  = PRCGetReflexAdjustedDamage(nDamage/2, oTarget, nDC, SAVING_THROW_TYPE_DIVINE);
                    if(nDamage)
                    {
                        eHoly = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_DIVINE);
                        DelayCommand(0.6, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHoly, oTarget));
                    }
                }
                // Apply effects to the currently selected target.
                if(nDamage2)
                {
                    eFire = PRCEffectDamage(oTarget, nDamage2, EleDmg);
                    DelayCommand(0.6, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
                    DelayCommand(0.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, FALSE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_PLACEABLE|OBJECT_TYPE_DOOR);
    }

    PRCSetSchool();
}