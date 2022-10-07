#include "prc_inc_spells"

void SoldierOfLight()
{
   if (!GetHasFeat(FEAT_TURN_UNDEAD,OBJECT_SELF))  return;
   
   if (!GetHasFeat(FEAT_SUP_POSITIVE_ENERGY_BURST,OBJECT_SELF))
   {
     DecrementRemainingFeatUses(OBJECT_SELF,FEAT_TURN_UNDEAD);

    if (!GetHasFeat(FEAT_TURN_UNDEAD,OBJECT_SELF))
    {
      IncrementRemainingFeatUses(OBJECT_SELF,FEAT_TURN_UNDEAD);
      FloatingTextStringOnCreature("Not Enough Turn Undead Uses", OBJECT_SELF, FALSE);
      return;
    }
   }
   DecrementRemainingFeatUses(OBJECT_SELF,FEAT_TURN_UNDEAD);

   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_30), GetLocation(OBJECT_SELF));
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD), GetLocation(OBJECT_SELF));
   
   location lTarget = GetSpellTargetLocation();

   int CasterLvl = GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT);

    effect eDeath ;
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    int nDamage;

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 100.0, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {

      if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
      || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD))
      {

          nDamage = PRCGetReflexAdjustedDamage(d6(CasterLvl), oTarget, (10+CasterLvl), SAVING_THROW_TYPE_POSITIVE);
          eDeath = EffectDamage(nDamage,DAMAGE_TYPE_POSITIVE,DAMAGE_POWER_ENERGY);

          effect eLink = EffectLinkEffects(eDeath, eVis);

           DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT,eLink,oTarget));
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_STUN), oTarget);
      }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, 100.0, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    }

}

void SacredPurifier()
{
    object oPC = OBJECT_SELF;
    if (!GetHasFeat(FEAT_TURN_UNDEAD,oPC))  return;
    DecrementRemainingFeatUses(oPC,FEAT_TURN_UNDEAD);
    if (!GetHasFeat(FEAT_TURN_UNDEAD,oPC))
    {
        IncrementRemainingFeatUses(oPC,FEAT_TURN_UNDEAD);
        FloatingTextStringOnCreature("Not Enough Turn Undead Uses", oPC, FALSE);
        return;
    }   
    DecrementRemainingFeatUses(oPC,FEAT_TURN_UNDEAD);
    
    location lTarget = GetLocation(oPC);
    int nClass = GetLevelByClass(CLASS_TYPE_SACREDPURIFIER);
    int nCha = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    int nDC = 10 + nCha + nClass;

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_30), lTarget);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD), lTarget);

    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    int nDamage;

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
        || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD))
        {
            nDamage = PRCGetReflexAdjustedDamage(d6(10), oTarget, nDC, SAVING_THROW_TYPE_POSITIVE);
            effect eDeath = EffectDamage(nDamage,DAMAGE_TYPE_POSITIVE,DAMAGE_POWER_ENERGY);
            effect eLink = EffectLinkEffects(eDeath, eVis);
            DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT,eLink,oTarget));
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    }
}

void main()
{
    if (GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT) > GetLevelByClass(CLASS_TYPE_SACREDPURIFIER))
        SoldierOfLight();
    else
        SacredPurifier();
}
