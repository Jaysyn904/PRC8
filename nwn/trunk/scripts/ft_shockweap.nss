#include "prc_alterations"
#include "prc_feat_const"

void main()
{
   if (GetIsImmune(PRCGetSpellTargetObject(),IMMUNITY_TYPE_CRITICAL_HIT)) return;

   object oWeap=GetSpellCastItem();

   if (GetBaseItemType(oWeap)!=BASE_ITEM_SHORTSPEAR ) return;


   int nThreat  = 20;

   if (GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN) == TRUE)
   {
   nThreat = nThreat - 1;
   }

   if (GetHasFeat(FEAT_IMPROVED_CRITICAL_SPEAR) == TRUE)
   {
   nThreat = nThreat - 1;
   }

   int dice=d20();

   int iDiceCritical = 2 + (GetHasFeat(FEAT_WEAPON_OF_CHOICE_SHORTSPEAR) && GetHasFeat(FEAT_INCREASE_MULTIPLIER));

     if (dice>=nThreat)
    {
      FloatingTextStringOnCreature("Critical Hit", OBJECT_SELF);

      if (GetHasFeat( FEAT_SHOCKING_WEAPON,OBJECT_SELF))
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(d10(iDiceCritical),DAMAGE_TYPE_ELECTRICAL,DAMAGE_POWER_NORMAL),PRCGetSpellTargetObject());

      ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(d8(iDiceCritical),DAMAGE_TYPE_SONIC,DAMAGE_POWER_NORMAL),PRCGetSpellTargetObject());

    }
    
  if (GetHasSpellEffect( SPELL_DARKFIRE,oWeap))
  {

     int nDamageType = GetLocalInt(oWeap, "X2_Wep_Dam_Type");
     int nAppearanceTypeS = VFX_IMP_FLAME_S;
     int nAppearanceTypeM = VFX_IMP_FLAME_M;

     switch(nDamageType)
     {
        case DAMAGE_TYPE_ACID: nAppearanceTypeS = VFX_IMP_ACID_S; nAppearanceTypeM = VFX_IMP_ACID_L; break;
        case DAMAGE_TYPE_COLD: nAppearanceTypeS = VFX_IMP_FROST_S; nAppearanceTypeM = VFX_IMP_FROST_L; break;
        case DAMAGE_TYPE_ELECTRICAL: nAppearanceTypeS = VFX_IMP_LIGHTNING_S; nAppearanceTypeM =VFX_IMP_LIGHTNING_M;break;
        case DAMAGE_TYPE_SONIC: nAppearanceTypeS = VFX_IMP_SONIC; nAppearanceTypeM = VFX_IMP_SONIC; break;
     }

     // Get Caster Level
     int nLevel = GetLocalInt(oWeap, "X2_Wep_Caster_Lvl");

    int nDmg = d6() + (nLevel/2);

    effect eDmg = EffectDamage(nDmg,nDamageType);
    effect eVis;
    if (nDmg<10) // if we are doing below 12 point of damage, use small flame
    {
      eVis =EffectVisualEffect(nAppearanceTypeS);
    }
    else
    {
       eVis =EffectVisualEffect(nAppearanceTypeM);
    }
    eDmg = EffectLinkEffects (eVis, eDmg);
    object oTarget = PRCGetSpellTargetObject();

    if (GetIsObjectValid(oTarget))
    {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
    }

  }
}
