//::///////////////////////////////////////////////
//:: PRC OnItemUnequipped
//:: prc_unequip
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnUnEquip Event
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////
#include "prc_inc_function"
#include "inc_timestop"
#include "prc_inc_itmrstr"
#include "prc_inc_combat"
#include "prc_inc_template"

void PrcFeats(object oPC, object oItem)
{
     SetLocalInt(oPC,"ONEQUIP",1);
     EvalPRCFeats(oPC);

     //this is to remove effect-related itemproperties
     //in here to take advantage of the local
     //I didnt put it in EvalPRCfeats cos I cant be bothered to wait for the compile
     //Ill probably move it at some point, dont worry
     //Primogenitor
     CheckPRCLimitations(oItem, oPC);

     DeleteLocalInt(oPC,"ONEQUIP");
}

void DoNaturalWeaponEffect(object oPC)
{
    if (DEBUG) DoDebug("GetIsUsingPrimaryNaturalWeapons "+IntToString(GetIsUsingPrimaryNaturalWeapons(oPC))+" PrimaryNaturalWeapEffect "+IntToString(GetLocalInt(oPC, "PrimaryNaturalWeapEffect")));
    if (GetIsUsingPrimaryNaturalWeapons(oPC) && GetLocalInt(oPC, "PrimaryNaturalWeapEffect")) 
    {
    	SetPrimaryNaturalWeaponAttacks(oPC, 0);
    	DeleteLocalInt(oPC, "PrimaryNaturalWeapEffect");
    }	
}    

void DoWeaponUnequip(object oPC, object oItem);

//Added hook into EvalPRCFeats event
//  Aaon Graywolf - 6 Jan 2004
//Added delay to EvalPRCFeats event to allow module setup to take priority
//  Aaon Graywolf - Jan 6, 2004
void main()
{
    object oItem = GetItemLastUnequipped();
    object oPC   = GetItemLastUnequippedBy();

//if(DEBUG) DoDebug("Running OnUnEquip, creature = '" + GetName(oPC) + "' is PC: " + DebugBool2String(GetIsPC(oPC)) + "; Item = '" + GetName(oItem) + "' - '" + GetTag(oItem) + "'");

    DoTimestopUnEquip(oPC, oItem);
    
    if (GetResRef(oItem) == "prc_crown_might") DestroyObject(oItem);    
    if (GetResRef(oItem) == "prc_crown_prot") DestroyObject(oItem); 

	int nItemType = GetBaseItemType(oItem);
	
	if(nItemType == BASE_ITEM_CBLUDGWEAPON
	|| nItemType == BASE_ITEM_CPIERCWEAPON
	|| nItemType == BASE_ITEM_CSLASHWEAPON
	|| nItemType == BASE_ITEM_CSLSHPRCWEAP)
	{
		DestroyObject(oItem);	
	}
	
	int nClaw = GetStringLeft(GetResRef(oItem), 12) == "prc_diaclaw_" ? TRUE : FALSE;
    if(nClaw)DestroyObject(oItem);	
	
	nClaw = GetStringLeft(GetResRef(oItem), 9) == "prc_claw_" ? TRUE : FALSE;
    if(nClaw)DestroyObject(oItem);		
	
	int nUnarmed = GetStringLeft(GetResRef(oItem), 12) == "prc_unarmed_" ? TRUE : FALSE;
    if(nUnarmed)DestroyObject(oItem);		

    // Delay a bit to prevent TMI due to polymorph effect being braindead and running the unequip script for each and
    // bloody every item the character has equipped at the moment of effect application. Without detaching the script
    // executions from the script that does the effect application. So no instruction counter resets.
    // This will probably smash some scripts to pieces, at least when multiple unequips happen at once. Hatemail
    // to nwbugs@bioware.com please.

    DelayCommand(0.0f, PrcFeats(oPC, oItem));

    /* Does not seem to work, the effect is not listed yet when the unequip scripts get run
    if(PRCGetHasEffect(EFFECT_TYPE_POLYMORPH, oPC))
    {
        DoDebug("prc_unequip: delayed call");
        DelayCommand(0.0f, PrcFeats(oPC));
    }
    else
    {
        DoDebug("prc_unequip: direct call");
        PrcFeats(oPC);
    }*/

    DoWeaponUnequip(oPC, oItem);
    // No weapons equipped, restore 
    
	DelayCommand(0.15, DoNaturalWeaponEffect(oPC));
	
//:: Saint / Holy Touch doesn't work w/ ranged weapons
	if (GetHasTemplate(TEMPLATE_SAINT, oPC))
	{
	//:: Setup Holy Touch extra damage vs evil
		effect eEffect1 = VersusAlignmentEffect(EffectDamageIncrease(7, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
		effect eEffect2 = VersusAlignmentEffect(EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
		       eEffect2 = VersusRacialTypeEffect(eEffect2, RACIAL_TYPE_OUTSIDER);
		effect eEffect3 = VersusAlignmentEffect(EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
		       eEffect3 = VersusRacialTypeEffect(eEffect3, RACIAL_TYPE_UNDEAD);
		effect eLink = EffectLinkEffects(eEffect1, eEffect2);
		       eLink = EffectLinkEffects(eLink, eEffect3);
		       eLink = SupernaturalEffect(eLink);
		       eLink = TagEffect(eLink, "EffectHolyTouch");

	//:: Clear the effect to be safe and prevent stacking
		effect eCheckEffect = GetFirstEffect(oPC);
            
		while (GetIsEffectValid(eCheckEffect))
		{
			if (GetEffectTag(eCheckEffect) == "EffectHolyTouch")
			{
				RemoveEffect(oPC, eCheckEffect);
			
			}
			
		eCheckEffect = GetNextEffect(oPC);
		
		}

//:: check if equipped with a ranged weapon and apply effect again if not
        if (!GetWeaponRanged(oItem))
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
	}	

    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERUNEQUIPITEM);
    ExecuteAllScriptsHookedToEvent(oItem, EVENT_ITEM_ONPLAYERUNEQUIPITEM);

    // Tag-based scripting hook for PRC items
    SetUserDefinedItemEventNumber(X2_ITEM_EVENT_UNEQUIP);
    ExecuteScript("is_"+GetTag(oItem), OBJECT_SELF);
}

void DoWeaponUnequip(object oPC, object oItem)
{
    //initialize variables
    int nRealSize = PRCGetCreatureSize(oPC);  //size for Finesse/TWF
    int nSize = nRealSize;                    //size for equipment restrictions
    int nWeaponSize = GetWeaponSize(oItem);

	//:: Handle Elven blade feat emulation.	
    effect eEffect = GetFirstEffect(oPC);
    while(GetIsEffectValid(eEffect))
    {
        if(GetEffectTag(eEffect) == "LIGHTBLADE_FEAT_EMULATATION")
            RemoveEffect(oPC, eEffect);
        if(GetEffectTag(eEffect) == "THINBLADE_FEAT_EMULATATION")
            RemoveEffect(oPC, eEffect);		
        if(GetEffectTag(eEffect) == "COURTBLADE_FEAT_EMULATATION")
            RemoveEffect(oPC, eEffect);
        eEffect = GetNextEffect(oPC);
    }
	
	//Powerful Build bonus
    if(GetHasFeat(FEAT_RACE_POWERFUL_BUILD, oPC))
        nSize++;
    //Monkey Grip
    if(GetHasFeat(FEAT_MONKEY_GRIP, oPC))
    {
        nSize++;   
        // If you try and use the big weapons
        if (nWeaponSize > nRealSize)
        {
            SetCompositeAttackBonus(oPC, "MonkeyGripL", 0, ATTACK_BONUS_OFFHAND);
            SetCompositeAttackBonus(oPC, "MonkeyGripR", 0, ATTACK_BONUS_ONHAND);
        }    
    }         

    // if(DEBUG) DoDebug("prc_restwpnsize - OnUnEquip");  // <-script no longer exists

    // remove any TWF penalties
    //if weapon was a not light, and there's still something equipped in the main hand(meaning that an offhand item was de-equipped)
    if(nWeaponSize == nRealSize && GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) != OBJECT_INVALID)
    {
        //remove any effects added
        SetCompositeAttackBonus(oPC, "OTWFPenalty", 0);
    }
    //remove any simulated finesse
    if(GetHasFeat(FEAT_WEAPON_FINESSE, oPC) && nWeaponSize != -1)
    {
        //if left hand unequipped, clear 
        //if right hand unequipped, left hand weapon goes to right hand, so should still be cleared
        SetCompositeAttackBonus(oPC, "ElfFinesseLH", 0, ATTACK_BONUS_OFFHAND);
        //if right hand weapon unequipped
        if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem)
            SetCompositeAttackBonus(oPC, "ElfFinesseRH", 0, ATTACK_BONUS_ONHAND);
    }

    //remove any two-handed weapon bonus
    SetCompositeDamageBonusT(oItem, "THFBonus", 0);

    //No longer needed due to new weapon feats via Beamdog
    /*DoWeaponFeatUnequip(oPC, oItem, ATTACK_BONUS_OFFHAND);
    if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem)
        DoWeaponFeatUnequip(oPC, oItem, ATTACK_BONUS_ONHAND);*/

    //clean any nonproficient penalties
    SetCompositeAttackBonus(oPC, "Unproficient" + IntToString(ATTACK_BONUS_OFFHAND), 0, ATTACK_BONUS_OFFHAND);
    if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem)
        SetCompositeAttackBonus(oPC, "Unproficient" + IntToString(ATTACK_BONUS_ONHAND), 0, ATTACK_BONUS_ONHAND);
}