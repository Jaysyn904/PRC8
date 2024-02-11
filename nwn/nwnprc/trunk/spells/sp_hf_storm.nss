//::///////////////////////////////////////////////
//:: Name      Hellfire Storm
//:: FileName  sp_hf_storm.nss
//:://////////////////////////////////////////////
/**@file Hellfire Storm 
Evocation [Evil] 
Level: Diabolic 7 
Range: Medium (100 ft. + 10 ft./level)
Area: 20-ft.-radius spread

As hellfire, except in area and range and that the 
spell deals 5d6 points of special diabolic fire damage.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        //Declare major variables
        object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nMetaMagic = PRCGetMetaMagicFeat();
        int nDamage;
        float fDelay;
        effect eExplode = EffectVisualEffect(807);
        effect eVis = EffectVisualEffect(VFX_FNF_HELLFIRESTORM);
        effect eDam;
        
        //spellhook
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_EVOCATION);
        
        //Get the spell target location as opposed to the spell target.
        location lTarget = PRCGetSpellTargetLocation();  
        
        //Apply the fireball explosion at the location captured above.
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
        
        //Declare the spell shape, size and the location.  Capture the first target object in the shape.
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        
        //Cycle through the targets within the spell shape until an invalid object is captured.
        while (GetIsObjectValid(oTarget))
        {
                if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
                {
                        //Get the distance between the explosion and the target to calculate delay
                        fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                        if (!PRCDoResistSpell(OBJECT_SELF, oTarget, nCasterLvl))
                        {
                                //Roll damage for each target
                                nDamage = d6(5);
                                
                                //Resolve metamagic
                                if (nMetaMagic & METAMAGIC_MAXIMIZE)
                                {
                                        nDamage = 30;
                                }
                                if (nMetaMagic & METAMAGIC_EMPOWER)
                                {
                                        nDamage = nDamage + nDamage / 2;
                                }
                                nDamage += SpellDamagePerDice(oPC, 5);
                                //Set the damage effect
                                eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_DIVINE);
                                if(nDamage > 0)
                                {
                                        // Apply effects to the currently selected target.
                                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));                                                
                                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                                }
                        }
                }
                //Select the next target within the spell shape.
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }       
        //SPEvilShift(oPC);
        PRCSetSchool();
}