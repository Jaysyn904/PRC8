//:://////////////////////////////////////////////
//:: Name     Blessed Aim Heartbeat
//:: FileName   sp_blessedaimc.nss
//:://////////////////////////////////////////////
/** @file
Blessed Aim
Divination
Level: Blackguard 1, Cleric 1, Paladin 1,
Components: V, S,
Casting Time: 1 standard action
Range: 50 ft.
Effect: 50-ft.-radius spread centered on you
Duration: 1 minute/level
Saving Throw: Will negates (harmless)
Spell Resistance: No

With the blessing of your deity, you bolster your allies' aim with an exhortation.

This spell grants your allies within the spread a +2 morale bonus on ranged attack rolls.

 
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"

void main()
{
	location lLoc = GetLocation(OBJECT_SELF);
	object oItem;
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(50.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);
	{
		oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
		if(GetIsReactionTypeFriendly(oTarget)
		{
			if GetWeaponRanged(oItem)
			{
				SPApplyEffectToObject(oTarget, EffectAttackIncrease(2), 6.0f)
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(50.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);
}