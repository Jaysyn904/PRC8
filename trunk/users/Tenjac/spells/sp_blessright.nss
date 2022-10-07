//:://////////////////////////////////////////////
//:: Name     Blessing of the Righteous
//:: FileName   sp_blessright.nss
//:://////////////////////////////////////////////
/** @file
Blessing of the Righteous
Evocation [Good]
Level: Cleric 4, Paladin 4,
Components: V, S, DF,
Casting Time: 1 standard action
Range: 40 ft.
Area: All allies in a 40-ft.-radius burst centered on you
Duration: 1 round/level
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

A sudden burst of warm, radiant light engulfs you and your allies.
The light fades quickly but lingers on the weapons of those affected.
You bless yourself and your allies.
You and your allies'melee and ranged attacks deal an extra 1d6 points
of holy damage and are considered good-aligned for the purpose of 
overcoming damage reduction.
 
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 1/26/21
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_EVOCATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur = RoundsToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        location lLoc = PRCGetSpellTargetLocation();
        int nBonus = DAMAGE_BONUS_1d6;
        
        if (nMetaMagic & METAMAGIC_EXTEND) fDur *= 2;
        if (nMetaMagic & METAMAGIC_MAXIMIZE) nBonus = DAMAGE_BONUS_6;
	
	object oTarget = GetFirstObjectinShape(SHAPE_SPHERE, FeetToMeters(40.0), lLoc);
	
	while (GetIsObjectValid(oTarget))
	{
		//if it's friendly
		if(GetIsReactionTypeFriendly(oTarget))
		{
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageIncrease(nBonus, DAMAGE_TYPE_POSITIVE), oTarget, fDur);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HOLY_AID), oTarget);
		}
		OTarget = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(40.0), lLoc);
	
	PRCSetSchool();
}