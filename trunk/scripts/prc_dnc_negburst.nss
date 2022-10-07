//::///////////////////////////////////////////////
//:: Negative Energy Burst
//:: prc_dnc_negburst.nss
//:://////////////////////////////////////////////
/*
    The Dread Necro releases a burst of negative energy
    doing 1d4 / level negative energy damage
*/

#include "prc_inc_spells"  
#include "prc_add_spell_dc"
#include "prc_inc_function"

void main()
{
    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nClass = GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oCaster);
    int nDamage;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_FNF_LOS_EVIL_20); //Replace with Negative Pulse
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eDam, eHeal;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Get the spell target location as opposed to the spell target.
    location lTarget = GetLocation(oCaster);
    //Apply the explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
            int nDC = 10 + (nClass/2) + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
            //Roll damage for each target
            nDamage = d4(nClass);
            if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (nDC), SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, fDelay))
            {
                nDamage /= 2;
                
                    if (GetHasMettle(oTarget, SAVING_THROW_WILL)) // Ignores partial effects
		    {
		            	nDamage = 0;
                    }  
            }
            //nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF, FALSE);
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // * any undead should be healed, not just Friendlies
            if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
            || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD)
            || GetLocalInt(oTarget, "AcererakHealing"))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_BURST, FALSE));
                //Set the heal effect
                eHeal = EffectHeal(nDamage);
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the flame that erupts on the target not on the ground.
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget));
            }
            else
            {
                if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
                {
                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_BURST));
                        //Set the damage effect
                        eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_NEGATIVE);
                        // Apply effects to the currently selected target.
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                        //This visual effect is applied to the target object not the location as above.  This visual effect
                        //represents the flame that erupts on the target not on the ground.
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }

       //Select the next target within the spell shape.
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget);
    }
}
