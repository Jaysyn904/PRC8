#include "prc_feat_const"
#include "prc_spell_const"

void main()
{

   if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
   {
        SpeakStringByStrRef(40550);
   }
   else
   if(GetHasFeatEffect(FEAT_DIVINE_CLEANSING) == FALSE)
   {
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, 2);
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID); 
    
    //Link Effects
    effect eLink = EffectLinkEffects(eSave, eDur);
           eLink = EffectLinkEffects(eLink, eDur2);

    int nDuration = GetAbilityModifier(ABILITY_CHARISMA)>0 ? GetAbilityModifier(ABILITY_CHARISMA):1 ;

    location lTarget = GetSpellTargetLocation();

      //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {

        if ( GetIsFriend(oTarget)|| GetFactionEqual(oTarget))
        {
                //Apply the VFX impact and effects
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

        }

        //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    }  
    
     DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD); 
    
   }
   
   
}