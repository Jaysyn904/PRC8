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

#include "prc_alterations"
#include "prc_inc_combat"


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

	// DeleteLocalInt(oSpellOrigin, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(oSpellOrigin, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

	// find the weapon on which the Flame Weapon spell resides
	object oWeapon = PRCGetSpellCastItem(oSpellOrigin);

	// find the target of the spell
	object oTarget = PRCGetSpellTargetObject(oSpellOrigin);
	if (DEBUG) DoDebug("x2_s3_flamingd: caster level = "+IntToString(PRCGetCasterLevel(oSpellOrigin)));
	// only do anything, if we have a valid weapon, and a valid living target
	if (GetIsObjectValid(oWeapon) && GetIsObjectValid(oTarget)&& !GetIsDead(oTarget))
	{
		int nDamageType = GetLocalInt(oWeapon, "X2_Wep_Dam_Type");
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
		int nLevel = GetLocalInt(oWeapon, "X2_Wep_Caster_Lvl");
		// Assume minimum caster level if variable is not found

		if (DEBUG) DoDebug("x2_s3_flamingd: on hit cast with weapon "+GetName(oWeapon)+", caster level = "+IntToString(nLevel));

		if (!nLevel) nLevel =3;

		// motu99: maximum was missing ; put it on a switch!
		int iLimit = GetPRCSwitch(PRC_FLAME_WEAPON_DAMAGE_MAX);
		if (!iLimit) iLimit = 10;
		if (nLevel > iLimit)	nLevel = iLimit;

		int nDmg = d4() + nLevel;

		effect eDmg = PRCEffectDamage(oTarget, nDmg,nDamageType);
		effect eVis;
		if (nDmg<10) // if we are doing below 10 point of damage, use small flame
		{
			eVis =EffectVisualEffect(nAppearanceTypeS);
		}
		else
		{
			eVis =EffectVisualEffect(nAppearanceTypeM);
		}
		eDmg = EffectLinkEffects (eVis, eDmg);

//int nMetaMagic = PRCGetMetaMagicFeat();
//DoDebug("x2_s3_flamingd: nMetaMagic = "+ IntToString(nMetaMagic)+", applying fire damage (1d4 + "+IntToString(nLevel)+") = "+IntToString(nDmg)+" to target "+GetName(oTarget));
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
	}
	else
	{
//DoDebug("x2_s3_flamingd: invalid weapon ("+GetName(oWeapon)+") or invalid/dead target ("+GetName(oTarget)+")");
	}

	DeleteLocalInt(oSpellOrigin, "X2_L_LAST_SPELLSCHOOL_VAR");
	// int to hold spell school.
}
