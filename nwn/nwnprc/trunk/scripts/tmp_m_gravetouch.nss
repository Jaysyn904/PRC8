//::///////////////////////////////////////////////
//:: Name           Gravetouched Ghoul template script
//:: FileName       tmp_m_gravetouch
//:: 
//:://////////////////////////////////////////////
/*CREATING A GRAVETOUCHED GHOUL
�Gravetouched ghoul� is an acquired template that can be added to any corporeal aberration, fey, giant, humanoid, or monstrous
humanoid with Intelligence and Charisma scores of 3 or higher (referred to hereafter as the base creature).

A gravetouched ghoul speaks all the languages it spoke in life (usually Common). It has all the base creature�s statistics
and special abilities except as noted here.

Size and Type: The creature�s type changes to undead. Do not recalculate base attack bonus, saves, or skill points. Size is unchanged.

Hit Dice: Increase to d12.

Armor Class: The base creature�s natural armor bonus improves by 2.

Attack: A gravetouched ghoul retains all the attacks of the base creature and also gains a bite and two claw attacks if it
didn�t already have them. If the base creature uses weapons, the gravetouched ghoul retains this ability. 

Damage: Gravetouched ghouls have bite and claw attacks. 

Size Bite Damage Claw Damage
Fine       1     �
Diminutive 1d2   1
Tiny       1d3   1d2
Small      1d4   1d3
Medium     1d6   1d4
Large      1d8   1d6
Huge       2d6   1d8
Gargantuan 2d8   2d6
Colossal   4d6   2d8

Special Attacks: A gravetouched ghoul retains all the special attacks of the base creature and gains those described below. 
Saves have a DC of 10 + 1/2 the gravetouched ghoul�s HD + gravetouched ghoul�s Cha modifier unless otherwise noted.

Ghoul Rot (Su): The gravetouched ghoul's bite attack delivers the ghoul rot disease 

Paralysis (Ex): Victims hit by a gravetouched ghoul�s bite or claw attack must make a successful Fortitude save or be paralyzed for
1d4+1 rounds. Elves have immunity to this paralysis.

Special Qualities: A gravetouched ghoul retains all the special qualities of the base creature and gains those described below.

Turn Resistance (Ex): A gravetouched ghoul has +2 turn resistance.

Abilities: Increase from the base creature as follows: Str +2, Dex +4, Int +2, Wis +4, Cha +2. As an undead creature, a gravetouched ghoul has no Constitution score.

Feats: A gravetouched ghoul retains all its feats, and it gains Multiattack as a bonus feat.

Alignment: Base creature�s alignment changes to chaotic evil.

Level Adjustment: Same as base creature +2.
*/

#include "prc_inc_template"
#include "prc_inc_natweap"
#include "prc_inc_combat"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("tmp_m_gravetouch running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC;
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;
        case EVENT_ONHEARTBEAT:         oPC = OBJECT_SELF;               break;

        default:
            oPC = OBJECT_SELF;
    }

    object oItem;
	object oSkin = GetPCSkin(oPC);
	itemproperty ipIP;

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
		//natural armor, Turn Resist
		SetCompositeBonus(oSkin, "Template_Gravetouched_ac", 2, ITEM_PROPERTY_AC_BONUS);
		SetCompositeBonus(oSkin, "Template_Gravetouched_turn", 2, ITEM_PROPERTY_TURN_RESISTANCE);
		
		// Alignment
		AdjustAlignment(oPC, ALIGNMENT_EVIL,    100, FALSE);
		AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, 100, FALSE);
	
		//Abilities
		SetCompositeBonus(oSkin, "Template_Gravetouched_str", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_STR);
		SetCompositeBonus(oSkin, "Template_Gravetouched_dex", 4, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_DEX);
		SetCompositeBonus(oSkin, "Template_Gravetouched_int", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);
		SetCompositeBonus(oSkin, "Template_Gravetouched_wis", 4, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_WIS);
		SetCompositeBonus(oSkin, "Template_Gravetouched_cha", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);
		
		//feats
		ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_CREATURE);
 	   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
		ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_UNARMED_STRIKE);
 	   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 	   	
		
		//Natural Attacks
 	   	string sResRef = "prc_raks_bite_";
 	   	int nSize = PRCGetCreatureSize(oPC);
 	   	sResRef += GetAffixForSize(nSize);
 	   	AddNaturalSecondaryWeapon(oPC, sResRef);
 	   	//primary weapon
 	   	sResRef = "prc_claw_1d6l_";
 	   	sResRef += GetAffixForSize(nSize);
 	   	AddNaturalPrimaryWeapon(oPC, sResRef, 2);
	
		//make Gravetouched undead
		ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNDEAD_HD);
 	   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
 	   	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_ABILITY_DECREASE);
 	   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
 	   	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_CRITICAL);
 	   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
 	   	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_DEATH);
 	   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
 	   	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_DISEASE);
 	   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
 	   	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_MIND_SPELLS);
 	   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
 	   	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_PARALYSIS);
 	   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
 	   	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_POISON);
 	   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
 	   	ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_SNEAKATTACK);
 	   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
 	   	ipIP = ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGEIMMUNITY_100_PERCENT);
 	   	IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
		
		SetSubRace(oPC, "Undead (Augmented Humanoid)");

        // Hook in the events, needed from level 1 for Skirmish
        if(DEBUG) DoDebug("tmp_m_gravetouch: Adding eventhooks");
        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "tmp_m_gravetouch", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "tmp_m_gravetouch", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONHEARTBEAT,         "tmp_m_gravetouch", TRUE, FALSE);
    }
    // We're being called from the OnHit eventhook
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("tmp_m_gravetouch: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );
	    //FloatingTextStringOnCreature(GetName(oItem)+" is OnHit Item for Gravetouched", oPC, FALSE);
		int nDC = 10 + GetHitDice(oPC)/2 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
		if (oItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC))
		{
			// Disease bite
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DISEASE)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDisease(DISEASE_GHOUL_ROT), oTarget);
		}
		// Can't paralyze elves
		if (GetIsCreatureWeapon(oItem) && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_ELF)
		{
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE)) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectParalyze(), oTarget, RoundsToSeconds(d4()+1));		
		}
    }// end if - Running OnHit event
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("tmp_m_gravetouch - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );
		if (oItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC))
		{
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        AddEventScript(oItem, EVENT_ITEM_ONHIT, "tmp_m_gravetouch", TRUE, FALSE);		
		}
		if (oItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC))
		{
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        AddEventScript(oItem, EVENT_ITEM_ONHIT, "tmp_m_gravetouch", TRUE, FALSE);		
		}
		if (oItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC))
		{
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	        AddEventScript(oItem, EVENT_ITEM_ONHIT, "tmp_m_gravetouch", TRUE, FALSE);
	        //AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGEBONUS_2), oItem, 99999.0);
		}		
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("tmp_m_gravetouch - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to creature weapons
        if(GetIsCreatureWeapon(oItem))
        {
            // Remove the temporary OnHitCastSpell: Unique
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tmp_m_gravetouch", TRUE, FALSE);
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);           
        }
    }  
    else if(nEvent == EVENT_ONHEARTBEAT)
    {
        if(DEBUG) DoDebug("tmp_m_gravetouch - OnHB\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          ); 
     /*   FloatingTextStringOnCreature(GetName(oPC)+" is heartbeat", oPC, FALSE);                  
        oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);                  
		if (GetIsObjectValid(oItem))
		{
           // IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	       // AddEventScript(oItem, EVENT_ITEM_ONHIT, "tmp_m_gravetouch", TRUE, FALSE);
	        FloatingTextStringOnCreature(GetName(oItem)+" is in Creature Slot Bite", oPC, FALSE);
		}
        oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);                  
		if (GetIsObjectValid(oItem))
		{
           // IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	       // AddEventScript(oItem, EVENT_ITEM_ONHIT, "tmp_m_gravetouch", TRUE, FALSE);	
	        FloatingTextStringOnCreature(GetName(oItem)+" is in Creature Slot Right", oPC, FALSE);
		}
        oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);                  
		if (GetIsObjectValid(oItem))
		{
           // IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
           // AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), oItem, 99999.0);
	       // AddEventScript(oItem, EVENT_ITEM_ONHIT, "tmp_m_gravetouch", TRUE, FALSE);	
	        FloatingTextStringOnCreature(GetName(oItem)+" is in Creature Slot Left", oPC, FALSE);
	        
			// No equipping magical items, and make sure to ignore creature items
			itemproperty ip = GetFirstItemProperty(oItem);
			while(GetIsItemPropertyValid(ip))
			{
				FloatingTextStringOnCreature(ItemPropertyToString(ip)+" is on Creature Slot Left", oPC, FALSE);
				ip = GetNextItemProperty(oItem);
			}	        
			
			//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyMonsterDamage(iMonsterDamage),oWeapL);
			
			//AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGEBONUS_10), oItem, 99999.0);
		}*/
    }    
}