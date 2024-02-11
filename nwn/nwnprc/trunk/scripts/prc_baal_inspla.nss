//::///////////////////////////////////////////////
//:: Insect Plague
//:: prc_baal_inspla
//:://////////////////////////////////////////////
/*
  Causes 1d3 damage, and if damaged, causes
  a penalty of -10 to all checks for 3minutes
*/

#include "prc_alterations"

float SpellDelay (object oTarget, int nShape);


#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);


    //Declare major variables
    int nCasterLevel = 15;
    int nDamage;
    float fDelay;
    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
     // March 2003. Removed this as part of the reputation pass
     //            if((PRCGetSpellId() == 340 && !GetIsFriend(oTarget)) || PRCGetSpellId() == 25)
            {
                //Fire cast spell at event for the specified target
                //SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONE_OF_COLD));
                //Get the distance between the target and caster to delay the application of effects
                fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20.0;
                //Make SR check, and appropriate saving throw(s).
               // if(!PRCDoResistSpell(OBJECT_SELF, oTarget, fDelay) && (oTarget != OBJECT_SELF))
               // {
                    //Detemine damage
                    nDamage = d3(1);


                    //Adjust damage according to Reflex Save, Evasion or Improved Evasion

                    // Apply effects to the currently selected target.
                    effect eBite = EffectDamage(nDamage,DAMAGE_TYPE_MAGICAL);
                    effect eVis = EffectVisualEffect(VFX_IMP_DISEASE_S);
                    effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 10);
                    effect eLink = EffectLinkEffects(eBite,eVis);
                    if(!PRCMySavingThrow(SAVING_THROW_FORT,oTarget,20,SAVING_THROW_TYPE_DISEASE))
                    //if(nDamage > 0)
                    {
                        //Apply delayed effects
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSkill, oTarget,180.0f));
                    }
              //  }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

