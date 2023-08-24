
#include "prc_alterations"
#include "prc_feat_const"

void main()
{
     object oPC = OBJECT_SELF;

     object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

     if (GetBaseItemType(oItem) != BASE_ITEM_BATTLEAXE)
     {
         SendMessageToPC(oPC, "You must have a battleaxe equipped to use this feat");
         IncrementRemainingFeatUses(oPC, FEAT_CLANGEDDINS_MIGHT);
         return;
     }

   int iConMod = GetAbilityModifier(ABILITY_CONSTITUTION);
   
   iConMod = (iConMod * 6) + 6;

   float fConMod = IntToFloat(iConMod);

   effect eVis = EffectVisualEffect(VFX_DUR_BARD_SONG);
   effect eLink = EffectModifyAttacks(1);
   eLink=EffectLinkEffects (eLink,eVis);

   ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eLink), oPC);
   DelayCommand(fConMod, RemoveEffect(oPC, eLink)); 
}


