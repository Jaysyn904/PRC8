#include "prc_feat_const"
#include "prc_spell_const"

void main()
{

   if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
   {
        SpeakStringByStrRef(40550);
   }
   else
   if(GetHasFeatEffect(FEAT_DIVINE_RESISTANCE) == FALSE)
   {

    int iEpic = GetHasFeatEffect(FEAT_EPIC_DIVINE_RESISTANCE);
    int nResistance = 5+iEpic*5;
    
    int nDuration = iEpic  ? GetAbilityModifier(ABILITY_CHARISMA) :10;
    
    effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, nResistance, 0);
    effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, nResistance, 0);
    effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResistance, 0);
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
    effect eVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

 
    //Link Effects
    effect eLink = EffectLinkEffects(eCold, eFire);
           eLink = EffectLinkEffects(eLink, eElec);
           eLink = EffectLinkEffects(eLink, eDur);
           eLink = EffectLinkEffects(eLink, eDur2);

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