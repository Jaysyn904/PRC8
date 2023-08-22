//::///////////////////////////////////////////////
//:: Fire Storm
//:: NW_S0_FireStm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a zone of destruction around the caster
    within which all living creatures are pummeled
    with fire.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 11, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 21, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"  
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetLocation(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDamage;
    int nDamage2;
    
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

   
    int EleDmg = ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_FIRE);


    int nCasterLevel = CasterLvl;
    if(nCasterLevel > 20)
    {
        nCasterLevel = 20; //bugfix, was == 20
    }
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eFireStorm = EffectVisualEffect(VFX_FNF_FIRESTORM);
    float fDelay;
    CasterLvl +=SPGetPenetr();

    //Apply Fire and Forget Visual in the area;
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFireStorm, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        //This spell smites everyone who is more than 2 meters away from the caster.
        //if (GetDistanceBetween(oTarget, OBJECT_SELF) > 2.0)
        //{
            if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
            {
                fDelay = PRCGetRandomDelay(1.5, 2.5);
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FIRE_STORM));
                //Make SR check, and appropriate saving throw(s).
                if (!PRCDoResistSpell(OBJECT_SELF, oTarget,CasterLvl, fDelay))
                {
                      //Roll Damage
                      nDamage = d6(nCasterLevel);
                      //Enter Metamagic conditions
                      if(nMetaMagic & METAMAGIC_MAXIMIZE)
                         nDamage = 6 * nCasterLevel;//Damage is at max
                      if(nMetaMagic & METAMAGIC_EMPOWER)
                         nDamage = nDamage + (nDamage/2);//Damage/Healing is +50%
                       int nDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
                      //Save versus both holy and fire damage
                      nDamage += SpellDamagePerDice(OBJECT_SELF, nCasterLevel);
                      nDamage2 = PRCGetReflexAdjustedDamage(nDamage/2, oTarget, (nDC), SAVING_THROW_TYPE_DIVINE);
                      nDamage = PRCGetReflexAdjustedDamage(nDamage/2, oTarget, (nDC), SAVING_THROW_TYPE_FIRE);
                    if(nDamage)
                    {
                          // Apply effects to the currently selected target.  For this spell we have used
                          //both Divine and Fire damage.
                          effect eDivine = PRCEffectDamage(oTarget, nDamage2, DAMAGE_TYPE_DIVINE);
                          effect eFire = PRCEffectDamage(oTarget, nDamage, EleDmg);
                          DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
                          DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDivine, oTarget));
                          DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }
                }
            //}
        }
        //Select the next target within the spell shape.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }

    PRCSetSchool();
}