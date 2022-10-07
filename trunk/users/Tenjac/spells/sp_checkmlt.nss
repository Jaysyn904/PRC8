//:://////////////////////////////////////////////
//:: Name     Checkmate's Light
//:: FileName   sp_chkmlt.nss
//:://////////////////////////////////////////////
/** @file Evocation [Lawful]
Level: Paladin 2, Cleric 3,
Components: V, S, DF,
Casting Time: 1 standard action
Range: Touch
Target: Melee weapon touched
Duration: 1 round/level (D)
Saving Throw: None
Spell Resistance: No

You intone your deity's name and the weapon you touch hums a 
harmonic response before it lights up with a soothing red glow.

You imbue the touched weapon with a +1 enhancement bonus per 
three caster levels (maximum +5 at 15th level), and it is treated
as lawful-aligned for the purpose of overcoming damage reduction.
In addition, you can cause it to cast a red glow as bright as a torch. 
Any creature within the radius of its clear illumination (20 feet)
gets a +1 morale bonus on saving throws against fear effects.

*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 6/14/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_EVOCATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  RoundsToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        
        object oWeapon = PRCGetSpellCastItem(oPC);
        
        object oTarget = PRCGetSpellTargetObject(oPC);
        
        if (GetIsObjectValid(oWeapon))
        {
        	int nBonus = min(nCasterLvl, 15)/3;
        	
        	//Simulating lawful as +3, so give +3 enhancement and penalty to damage and hit to offset
        	if(nBonus == 1)
        	{        		
        		AddItemProperty(oWeapon, DURATION_TYPE_TEMPORARY, ItemPropertyAttackPenalty(2), fDuration);
        		AddItemProperty(oWeapon, DURATION_TYPE_TEMPORARY, ItemPropertyDamagePenalty(2), fDuration);
        		nBonus=3;
        	}        	
        	if (nBonus == 2)
        	{
        		AddItemProperty(oWeapon, DURATION_TYPE_TEMPORARY, ItemPropertyAttackPenalty(1), fDuration);
        		AddItemProperty(oWeapon, DURATION_TYPE_TEMPORARY, ItemPropertyDamagePenalty(1), fDuration);
        		nBonus=3;
        	}        	
        	        	
        	IPSafeAddItemProperty(oWeapon, DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonus(nBonus), fDuration);
        	IPSafeAddItemProperty(oWeapon, DURATION_TYPE_TEMPORARY, ItemPropertyVisualEffect(ITEM_VISUAL_EVIL), fDuration);
        	        
        
        PRCSetSchool();
}