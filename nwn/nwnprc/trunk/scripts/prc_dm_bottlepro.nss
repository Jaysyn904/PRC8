#include "prc_inc_clsfunc"

void main()
{
object oPC = OBJECT_SELF;

if(GetHasFreeHand(oPC) == FALSE ||
   GetLocalInt(oPC, "DRUNKEN_MASTER_NUMBER_OF_BOTTLES_BEING_USED") >= 2)
    {
    FloatingTextStringOnCreature("You do not have a free hand to use the bottle with", oPC);
    return;
    }

if(UseBottle(oPC) == FALSE)
    {
    FloatingTextStringOnCreature("You do not have an empty bottle in your inventory", oPC);
    return;
    }

effect eSlash = EffectDamageIncrease(DAMAGE_BONUS_1d4, DAMAGE_TYPE_SLASHING);
effect eBludg = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_BLUDGEONING);

switch(d3())
    {
    case 1:
      {
      // The bottle breaks on the next attack:
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlash, oPC, RoundsToSeconds(2));
      DelayCommand(RoundsToSeconds(2), SetLocalInt(oPC, "DRUNKEN_MASTER_NUMBER_OF_BOTTLES_BEING_USED", GetLocalInt(oPC, "DRUNKEN_MASTER_NUMBER_OF_BOTTLES_BEING_USED") - 1));
      DelayCommand(RoundsToSeconds(2), FloatingTextStringOnCreature("The bottle just shattered", oPC));
      break;}
    case 2:
      {
      // The Bottle hits on the next attack but doesn't break until the 2nd attack:
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBludg, oPC, RoundsToSeconds(4));
      DelayCommand(RoundsToSeconds(2), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlash, oPC, RoundsToSeconds(2)));
      DelayCommand(RoundsToSeconds(4), SetLocalInt(oPC, "DRUNKEN_MASTER_NUMBER_OF_BOTTLES_BEING_USED", GetLocalInt(oPC, "DRUNKEN_MASTER_NUMBER_OF_BOTTLES_BEING_USED") - 1));
      DelayCommand(RoundsToSeconds(4), FloatingTextStringOnCreature("The bottle just shattered", oPC));
      break;}
    case 3:
      {
      // The Bottle hits on the next 2 attacks but doesn't break until the 3rd attack:
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBludg, oPC, RoundsToSeconds(6));
      DelayCommand(RoundsToSeconds(4), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlash, oPC, RoundsToSeconds(2)));
      DelayCommand(RoundsToSeconds(6), SetLocalInt(oPC, "DRUNKEN_MASTER_NUMBER_OF_BOTTLES_BEING_USED", GetLocalInt(oPC, "DRUNKEN_MASTER_NUMBER_OF_BOTTLES_BEING_USED") - 1));
      DelayCommand(RoundsToSeconds(6), FloatingTextStringOnCreature("The bottle just shattered", oPC));
      break;}
    }

FloatingTextStringOnCreature("Bottle Equiped", oPC);
SetLocalInt(oPC, "DRUNKEN_MASTER_NUMBER_OF_BOTTLES_BEING_USED", GetLocalInt(oPC, "DRUNKEN_MASTER_NUMBER_OF_BOTTLES_BEING_USED") + 1);
}
