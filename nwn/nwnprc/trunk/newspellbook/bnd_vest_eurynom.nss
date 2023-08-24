/*
04/03/21 by Stratovarius

Eurynome, Mother of the Material
  
Eurynome grants lordship over the beasts of land, seas, and air. She also gives those with whom she binds some of the might of titans.

Vestige Level: 4th
Binding DC: 21
Special Requirement: Eurynome hates Amon for some unknown reason and will not answer your call if you are already bound to him.

Influence: Eurynome’s influence makes you paranoid and ungrateful; you see secret motives and possible betrayals behind every action. Eurynome requires that you not 
attack a foe unless an ally has already done so. If no allies are present, she makes no such requirement

Granted Abilities: 
Eurynome grants you the ability to befriend animals and wield a massive hammer. In addition, she turns your blood into poison and gives you resistance to weapon blows.

Animal Friend: All animals automatically have an initial attitude of friendly toward you.

Damage Reduction: You gain damage reduction 2/+3.

Eurynome’s Maul: You summon a magic warhammer (1d8+1d4 bludgeoning damage, ×3 crit). You are proficient with this weapon and can wield it without penalty. Your warhammer’s 
exact bonus and abilities depend on your effective binder level, according to the following table.
Effective Binder Level Warhammer Summoned
10th or lower +1 warhammer
11th–14th +1 anarchic warhammer
15th–18th +1 anarchic adamantine warhammer
19th or higher +3 anarchic adamantine warhammer

Poison Blood: While you are bound to Eurynome, your blood becomes poisonous. Any creature that makes a bite attack against you must immediately make a successful 
Fortitude save or take 1d6 points of damage. After 1 minute, the creature must make another Fortitude save at the same DC or take another 1d6 points of damage per
three effective binder levels you possess (maximum 5d6). Each bite attack poisons the creature anew, forcing a new round of saving throws.
*/

#include "bnd_inc_bndfunc"

void EurynomeInfluence(object oBinder, int nCombat);

void EurynomeInfluence(object oBinder, int nCombat)
{
	if (GetHasSpellEffect(VESTIGE_EURYNOME, oBinder))
	{
		int nCurrent = GetIsInCombat(oBinder);
		// We just entered combat
		if (nCurrent == TRUE && nCombat == FALSE)
		{
			// Find an ally
			location lTarget = GetLocation(oBinder);
    		object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    		while(GetIsObjectValid(oAreaTarget))
    		{
    		    if(GetIsFriend(oAreaTarget, oBinder)) // Find that friend!
    		    {
		        	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectSlow()), oBinder, 6.0);
		        	break;
    		    }
    		//Select the next target within the spell shape.
    		oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    		}		
		}	
		 
    	DelayCommand(0.25, EurynomeInfluence(oBinder, nCurrent));
    }	
}

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 
    SetLocalObject(GetModule(), "EurynomeCharm", oBinder);
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_EURYNOME);

    effect eLink = EffectLinkEffects(EffectVisualEffect(PSI_DUR_SYNESTHETE), EffectPact(oBinder));
    if (!GetIsVestigeExploited(oBinder, VESTIGE_EURYNOME_ANIMAL_FRIEND)) eLink = EffectLinkEffects(eLink, EffectAreaOfEffect(136, "bnd_vest_eurychm", "", ""));
    if (!GetIsVestigeExploited(oBinder, VESTIGE_EURYNOME_DR)) eLink = EffectLinkEffects(eLink, EffectDamageReduction(2, DAMAGE_POWER_PLUS_THREE));
    if (!GetIsVestigeExploited(oBinder, VESTIGE_EURYNOME_MAUL))
    {
    	IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_WARHAMMER), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    
    	object oHammer = CreateItemOnObject("bnd_eury_hammer", oBinder);
    	SetIdentified(oHammer, TRUE);
    	SetDroppableFlag(oHammer, FALSE);
    	SetItemCursedFlag(oHammer, TRUE); 
    	AssignCommand(oHammer, SetIsDestroyable(FALSE, FALSE, FALSE));
    	DelayCommand(0.25, AssignCommand(oBinder, ActionEquipItem(oHammer, INVENTORY_SLOT_RIGHTHAND))); 
    	
    	if (nBinderLevel >= 19) IPSafeAddItemProperty(oHammer, ItemPropertyEnhancementBonus(3), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
    	if (nBinderLevel >= 15)
    	{
			IPSafeAddItemProperty(oHammer, ItemPropertyAttackBonus(5), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
    	   	IPSafeAddItemProperty(oHammer, ItemPropertyAttackPenalty(5), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
    	}   	
		if (nBinderLevel >= 11) IPSafeAddItemProperty(oHammer, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_LAWFUL, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d6), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);    
	}	
	    
    if (!GetLocalInt(oBinder, "PactQuality"+IntToString(VESTIGE_EURYNOME)))
    {
    	FloatingTextStringOnCreature("You have made a poor pact, and Eurynome prevents you from acting first in combat!", oBinder, FALSE);    
    	// Lets the spell apply first
    	DelayCommand(3.0, EurynomeInfluence(oBinder, FALSE));
    }	

    if (!GetIsVestigeExploited(oBinder, VESTIGE_EURYNOME_POISON))
    {
    	IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CHEST, oBinder), ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	AddEventScript(GetItemInSlot(INVENTORY_SLOT_CHEST, oBinder), EVENT_ITEM_ONHIT, "bnd_events", TRUE, FALSE);
    }	
	
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}