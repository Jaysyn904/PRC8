#include "prc_alterations"

/// +3 on Craft Weapon /////////
void Expert_Bowyer(object oPC, object oSkin, int nBowyer)
{

   if(GetLocalInt(oSkin, "PABowyer") == nBowyer) return;

    SetCompositeBonus(oSkin, "PABowyer", nBowyer, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_WEAPON);
}

// Removes Power Shot feats if they unequip their bow
void CheckPowerShot(object oPC)
{
      int bHasSpellActive = FALSE;

      // if the feat is active, remove the spell's effects.
      if(GetHasSpellEffect(SPELL_PA_POWERSHOT, oPC) ||
         GetHasSpellEffect(SPELL_PA_IMP_POWERSHOT, oPC) ||
         GetHasSpellEffect(SPELL_PA_SUP_POWERSHOT, oPC))
      {
         FloatingTextStringOnCreature("*Power Shot Deactivated - No Bow Equipped*", OBJECT_SELF, FALSE);
         PRCRemoveSpellEffects(SPELL_PA_POWERSHOT, OBJECT_SELF, OBJECT_SELF);
	 PRCRemoveSpellEffects(SPELL_PA_IMP_POWERSHOT, OBJECT_SELF, OBJECT_SELF);
	 PRCRemoveSpellEffects(SPELL_PA_SUP_POWERSHOT, OBJECT_SELF, OBJECT_SELF);
      }
}

void main()
{
     //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);

    int iBow = GetBaseItemType(oWeapon) == BASE_ITEM_LONGBOW || GetBaseItemType(oWeapon) == BASE_ITEM_SHORTBOW;
    int nBowyer = GetHasFeat(FEAT_EXPERT_BOWYER, oPC) ? 3 : 0;

    if (nBowyer>0) Expert_Bowyer(oPC, oSkin, nBowyer);

    if (!iBow) CheckPowerShot(oPC);
}
