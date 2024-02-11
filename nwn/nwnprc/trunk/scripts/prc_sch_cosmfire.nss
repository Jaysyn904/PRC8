//::///////////////////////////////////////////////
//:: Song of Cosmic Fire
//:: prc_sch_cosmfire.nss
//:://////////////////////////////////////////////
/*
// A 10th-level Sublime Chord with 20 or more ranks
// in the Perform skill learns the Song of Cosmic Fire.
// Using this ability costs a Sublime Chord two of her
// daily uses of Bardic Music. The Song of Cosmic Fire
// creates a 20-foot-radius spread of fire anywhere
// within 100 feet of the Sublime Chord (provided she
// has line of effect to the fire's point of origin).
// Creatures in the area take damage equal to the
// Sublime Chord's Perform check result. All affected
// creatures are entitled to a Reflex save (DC10 +
// Sublime Chord level + Cha modifier) for half damage.
*/
//:://////////////////////////////////////////////
//:: Created By: xwarren
//:: Created On: Dec 8, 2009
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
    object oCaster = OBJECT_SELF;

    if (PRCGetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }
    else if(GetSkillRank(SKILL_PERFORM, oCaster) < 20)
    {
        FloatingTextStringOnCreature("You need 20 or more ranks in perform skill.", oCaster, FALSE);
        return;
    }
    else if (!GetHasFeat(FEAT_BARD_SONGS, oCaster))
    {
        //SpeakStringByStrRef(40550);
        FloatingTextStringOnCreature("No Bard Song uses!", oCaster, FALSE);
        return;
    }
    else
    {
        DecrementRemainingFeatUses(oCaster, FEAT_BARD_SONGS);
        if (!GetHasFeat(FEAT_BARD_SONGS, oCaster))
        {
            //SpeakStringByStrRef(40550);
            FloatingTextStringOnCreature("No Bard Song uses!", oCaster, FALSE);
            IncrementRemainingFeatUses(oCaster, FEAT_BARD_SONGS);
        }
        else
        {
        DecrementRemainingFeatUses(oCaster, FEAT_BARD_SONGS);
        //Declare major variables
        int nCasterLvl = GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oCaster);
        int nDamage = d20(1) + GetSkillRank(SKILL_PERFORM, oCaster);
        int nDC = 10 + nCasterLvl + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
        float fDelay;
        effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
        effect eDam;
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
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                //Get the distance between the explosion and the target to calculate delay
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_FIRE);
                if(nDamage > 0)
                {
                    //Set the damage effect
                    eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_FIRE);
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    PRCBonusDamage(oTarget);
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
           //Select the next target within the spell shape.
           oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
      }
    }
}

