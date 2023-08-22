 //::///////////////////////////////////////////////
//:: OnHit Darkfire
//:: x2_s3_darkfire
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

   OnHit Castspell Darkfire Damage property for the
   Darkfire spell (x2_s3_darkfire).

   We need to use this property because we can not
   add random elemental damage to a weapon in any
   other way and implementation should be as close
   as possible to the book.

   Behavior:
   The casterlevel is set as a variable on the
   weapon, so if players leave and rejoin, it
   is lost (and the script will just assume a
   minimal caster level).


*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-17
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin on Dec 4, 2003 for prc stuff - caster level left alone.
//:: altered by motu99 on Apr 7, 2007

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
	// if you want to force the execution of an onhitcast spell script (that has the check) without routing the call
	// through prc_onhitcast, you must use ForceExecuteSpellScript(), to be found in prc_inc_spells
	if(!ContinueOnHitCastSpell(oSpellOrigin)) return;

	// DeleteLocalInt(oSpellOrigin, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(oSpellOrigin, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

	// find the weapon on which the Darkfire spell resides
	object oWeapon = PRCGetSpellCastItem(oSpellOrigin);
		
	// find the target of the spell
	object oTarget = PRCGetSpellTargetObject(oSpellOrigin);

	// only bother to do anything, if the weapon is valid, and the target is valid and lives
	if (GetIsObjectValid(oWeapon) && GetIsObjectValid(oTarget) && !GetIsDead(oTarget))
	{
		// motu99: added differentiation between darkfire and flame weapon damage
		int nDamageType = GetLocalInt(oWeapon, "X2_Wep_Dam_Type_DF");

		int nAppearanceTypeS = VFX_IMP_FLAME_S;
		int nAppearanceTypeM = VFX_IMP_FLAME_M;

		switch(nDamageType)
		{
			case DAMAGE_TYPE_ACID:       nAppearanceTypeS = VFX_IMP_ACID_S;      nAppearanceTypeM = VFX_IMP_ACID_L;      break;
			case DAMAGE_TYPE_COLD:       nAppearanceTypeS = VFX_IMP_FROST_S;     nAppearanceTypeM = VFX_IMP_FROST_L;     break;
			case DAMAGE_TYPE_ELECTRICAL: nAppearanceTypeS = VFX_IMP_LIGHTNING_S; nAppearanceTypeM = VFX_IMP_LIGHTNING_M; break;
			case DAMAGE_TYPE_SONIC:      nAppearanceTypeS = VFX_IMP_SONIC;       nAppearanceTypeM = VFX_IMP_SONIC;       break;
		}

		// Get Caster Level
		// motu99: added differentiation between darkfire and flame weapon damage
		int nLevel = GetLocalInt(oWeapon, "X2_Wep_Caster_Lvl_DF");
		// assume minimum level, if level not found

		if (DEBUG) DoDebug("x2_s3_darkfire: on hit cast with weapon "+GetName(oWeapon)+", caster level = "+IntToString(nLevel));

		if (!nLevel) nLevel = 5;

		nLevel /= 2;

		// motu99: maximum was missing ; put it on a switch!
		int iLimit = GetPRCSwitch(PRC_DARKFIRE_DAMAGE_MAX);
		if (!iLimit) iLimit = 10;
		if (nLevel > iLimit)	nLevel = iLimit;

		int nDmg = d6() + nLevel;

		effect eDmg = PRCEffectDamage(oTarget, nDmg,nDamageType);
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
//DoDebug("x2_s3_darkfire: applying fire damage (1d6 + "+IntToString(nLevel)+") = "+IntToString(nDmg)+" to target "+GetName(oTarget));
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
	}
	else
	{
//DoDebug("x2_s3_darkfire: invalid weapon ("+GetName(oWeapon)+") or invalid/dead target ("+GetName(oTarget)+")");
	}

	DeleteLocalInt(oSpellOrigin, "X2_L_LAST_SPELLSCHOOL_VAR");
}
