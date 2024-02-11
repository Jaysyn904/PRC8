 //::///////////////////////////////////////////////
//:: OnHit Firedamage
//:: x2_s3_flamgind
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

   OnHit Castspell Fire Damage property for the
   flaming weapon spell (x2_s0_flmeweap).

   We need to use this property because we can not
   add random elemental damage to a weapon in any
   other way and implementation should be as close
   as possible to the book.


*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-17
//:://////////////////////////////////////////////

/// altered Dec 15, 2003 by mr_bumpkin for prc stuff.
/// altered Apr 7, 2007 by motu99
// Converted to control Kapak poison Feb 10, 2008 by Fox

#include "prc_inc_spells"
#include "prc_inc_onhit"

void main()
{
	//string toSay =  " Self: " + GetTag(OBJECT_SELF) + " Item: " + GetTag(GetSpellCastItem());
	//SendMessageToPC(OBJECT_SELF, toSay);
	//  GetTag(OBJECT_SELF) was nothing, just ""  and the SendMessageToPC sent the message to my player.
	//  It's funny because I thought player characters had tags :-?  So who knows what to make of it?

	object oSpellOrigin = OBJECT_SELF;

	// route all onhit-cast spells through the unique power script (hardcoded to "prc_onhitcast")
	// in order to fix the Bioware bug, that only executes the first onhitcast spell found on an item
	// any onhitcast spell should have the check ContinueOnHitCast() at the beginning of its code
	// if you want to force the execution of an onhitcast spell script, that has the check, without routing the call
	// through prc_onhitcast, you must use ForceExecuteSpellScript(), to be found in prc_inc_spells
	if(!ContinueOnHitCastSpell(oSpellOrigin)) return;

	// find the weapon on which the Flame Weapon spell resides
	object oWeapon = PRCGetSpellCastItem(oSpellOrigin);

	// find the target of the spell
	object oTarget = PRCGetSpellTargetObject(oSpellOrigin);
	// only do anything, if we have a valid weapon, and a valid living target
	if (GetIsObjectValid(oWeapon) && GetIsObjectValid(oTarget)&& !GetIsDead(oTarget))
	{
		effect ePoison = EffectPoison(POISON_GIANT_WASP_POISON);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget);
	}
}
