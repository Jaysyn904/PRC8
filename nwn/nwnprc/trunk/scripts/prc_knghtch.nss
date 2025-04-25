//::///////////////////////////////////////////////
//:: [Knight of the Chalice Feats]
//:: [prc_knghtch.nss]
//:://////////////////////////////////////////////
//:: Check to see which Knight of the Chalice feats
//:: a creature has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Mar 17, 2004
//:://////////////////////////////////////////////
/*
 	Fiendslaying (Ex): Knights of the Chalice gain a number of special 
	benefits in combat with evil outsiders. A 1st-level knight of the 
	Chalice gets a +1 competence bonus on attack rolls against evil 
	outsiders. On a successful attack, she deals an extra 1d6 points 
	of damage due to her expertise in combating these creatures. 
	
	These bonuses increase as the knight advances in level, as shown below.
	
	Level 	Enhancement / Damage
	1		+1/+1d6 Physical
	3		+2/+2d6 Physical
	6		+3/+2d6 Physical & +1d6 Divine
	9		+4/+2d6	Physical & +2d6 Divine
	11		+5/+3d6	Physical & +2d6 Divine
	
	Pattern repeats through epic levels.
	
 */
#include "inc_newspellbook"
#include "prc_inc_core"
#include "prc_inc_fork"
#include "inc_eventhook"
#include "prc_ipfeat_const"

int GetDSWeaponAttackBonus(object oWeap)
{
    if (!GetIsObjectValid(oWeap)) return 0;

    object oKotC = GetItemPossessor(oWeap);
    itemproperty ip = GetFirstItemProperty(oWeap);
    int iTotal = 0;
    int iValue = 0;

    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_ATTACK_BONUS ||
            GetItemPropertyType(ip) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
        {
            iValue = GetItemPropertyCostTableValue(ip);
            iTotal = (iValue > iTotal) ? iValue : iTotal;
        }
        else if (GetItemPropertyType(ip) == ITEM_PROPERTY_HOLY_AVENGER &&
                 GetLevelByClass(CLASS_TYPE_PALADIN, oKotC))
        {
            iValue = 5;
            iTotal = (iValue > iTotal) ? iValue : iTotal;
        }
        ip = GetNextItemProperty(oWeap);
    }

    return iTotal;
}

int GetWeaponDamageType(object oItem)
{
    int iBaseItem = GetBaseItemType(oItem);

    int iWeapType = StringToInt(Get2DACache("baseitems", "WeaponType", iBaseItem));
    
    switch (iWeapType)
    {
        case 1: return DAMAGE_TYPE_PIERCING;
        case 2: return DAMAGE_TYPE_BLUDGEONING;
        case 3: return DAMAGE_TYPE_SLASHING;
        case 4: return DAMAGE_TYPE_PIERCING;
        case 5: return DAMAGE_TYPE_BLUDGEONING;
    }
    
    return DAMAGE_TYPE_SLASHING;
}

void main()
{
	int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_knghtch running, event: " + IntToString(nEvent));
	
//:: Get the PC. This is event-dependent
    object oKotC;
	object oItem;

    switch(nEvent)
    {
        case EVENT_ONPLAYEREQUIPITEM:   oKotC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oKotC = GetItemLastUnequippedBy(); break;
		case EVENT_ONUNAQUIREITEM:       oKotC = GetModuleItemLostBy(); break;
		
        default:
            oKotC = OBJECT_SELF;
	}
	
	int nClassLevel = GetLevelByClass(CLASS_TYPE_KNIGHT_CHALICE, oKotC);
    if (nClassLevel < 1) return;
	
//:: We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
		effect eFiendSlayAB;
		effect eFiendSlayDam1;
		effect eFiendSlayDam2;
		effect eFiendSlayType;
		effect eLink;
		
		//:: Get mainhand weapon
			object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oKotC);
			
		//:: Get weapon damage type
			int iWeapDamType = GetWeaponDamageType(oItem);
		
		//:: Attack Bonus scaling: +1/+1d6 per 3 levels (starting from level 1)
			int iAttBonus = (nClassLevel + 2) / 3;
			
		//:: Add to current enhancement bonus from weapon
			iAttBonus = iAttBonus + GetDSWeaponAttackBonus(oItem);				
			if (nClassLevel >= 29)
			{
				eFiendSlayAB = VersusAlignmentEffect(EffectAttackIncrease(iAttBonus), 0, ALIGNMENT_EVIL);
				eFiendSlayAB = VersusRacialTypeEffect(eFiendSlayAB, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam1 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_8d6, iWeapDamType), 0, ALIGNMENT_EVIL);
				eFiendSlayDam1 = VersusRacialTypeEffect(eFiendSlayDam1, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam2 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_7d6, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
				eFiendSlayDam2 = VersusRacialTypeEffect(eFiendSlayDam2, RACIAL_TYPE_OUTSIDER);
				
				eLink = EffectLinkEffects(eFiendSlayAB, eFiendSlayDam1);				
				eLink = EffectLinkEffects(eLink, eFiendSlayDam2);
				eLink = SupernaturalEffect(eLink);
				eLink = TagEffect(eLink, "EffectFiendSlaying");				
			}			
			else if (nClassLevel >= 27)
			{
				eFiendSlayAB = VersusAlignmentEffect(EffectAttackIncrease(iAttBonus), 0, ALIGNMENT_EVIL);
				eFiendSlayAB = VersusRacialTypeEffect(eFiendSlayAB, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam1 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_7d6, iWeapDamType), 0, ALIGNMENT_EVIL);
				eFiendSlayDam1 = VersusRacialTypeEffect(eFiendSlayDam1, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam2 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_7d6, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
				eFiendSlayDam2 = VersusRacialTypeEffect(eFiendSlayDam2, RACIAL_TYPE_OUTSIDER);
				
				eLink = EffectLinkEffects(eFiendSlayAB, eFiendSlayDam1);				
				eLink = EffectLinkEffects(eLink, eFiendSlayDam2);
				eLink = SupernaturalEffect(eLink);
				eLink = TagEffect(eLink, "EffectFiendSlaying");				
			}
			else if (nClassLevel >= 25)
			{
				eFiendSlayAB = VersusAlignmentEffect(EffectAttackIncrease(iAttBonus), 0, ALIGNMENT_EVIL);
				eFiendSlayAB = VersusRacialTypeEffect(eFiendSlayAB, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam1 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_7d6, iWeapDamType), 0, ALIGNMENT_EVIL);
				eFiendSlayDam1 = VersusRacialTypeEffect(eFiendSlayDam1, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam2 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_6d6, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
				eFiendSlayDam2 = VersusRacialTypeEffect(eFiendSlayDam2, RACIAL_TYPE_OUTSIDER);
				
				eLink = EffectLinkEffects(eFiendSlayAB, eFiendSlayDam1);				
				eLink = EffectLinkEffects(eLink, eFiendSlayDam2);
				eLink = SupernaturalEffect(eLink);
				eLink = TagEffect(eLink, "EffectFiendSlaying");			
			}	
			else if (nClassLevel >= 23)
			{
				eFiendSlayAB = VersusAlignmentEffect(EffectAttackIncrease(iAttBonus), 0, ALIGNMENT_EVIL);
				eFiendSlayAB = VersusRacialTypeEffect(eFiendSlayAB, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam1 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_6d6, iWeapDamType), 0, ALIGNMENT_EVIL);
				eFiendSlayDam1 = VersusRacialTypeEffect(eFiendSlayDam1, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam2 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_6d6, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
				eFiendSlayDam2 = VersusRacialTypeEffect(eFiendSlayDam2, RACIAL_TYPE_OUTSIDER);
				
				eLink = EffectLinkEffects(eFiendSlayAB, eFiendSlayDam1);				
				eLink = EffectLinkEffects(eLink, eFiendSlayDam2);
				eLink = SupernaturalEffect(eLink);
				eLink = TagEffect(eLink, "EffectFiendSlaying");				
			}				
			else if (nClassLevel >= 21)
			{
				eFiendSlayAB = VersusAlignmentEffect(EffectAttackIncrease(iAttBonus), 0, ALIGNMENT_EVIL);
				eFiendSlayAB = VersusRacialTypeEffect(eFiendSlayAB, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam1 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_6d6, iWeapDamType), 0, ALIGNMENT_EVIL);
				eFiendSlayDam1 = VersusRacialTypeEffect(eFiendSlayDam1, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam2 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_5d6, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
				eFiendSlayDam2 = VersusRacialTypeEffect(eFiendSlayDam2, RACIAL_TYPE_OUTSIDER);
				
				eLink = EffectLinkEffects(eFiendSlayAB, eFiendSlayDam1);				
				eLink = EffectLinkEffects(eLink, eFiendSlayDam2);
				eLink = SupernaturalEffect(eLink);
				eLink = TagEffect(eLink, "EffectFiendSlaying");				
			}	
			else if (nClassLevel >= 19)
			{
				eFiendSlayAB = VersusAlignmentEffect(EffectAttackIncrease(iAttBonus), 0, ALIGNMENT_EVIL);
				eFiendSlayAB = VersusRacialTypeEffect(eFiendSlayAB, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam1 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_5d6, iWeapDamType), 0, ALIGNMENT_EVIL);
				eFiendSlayDam1 = VersusRacialTypeEffect(eFiendSlayDam1, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam2 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_5d6, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
				eFiendSlayDam2 = VersusRacialTypeEffect(eFiendSlayDam2, RACIAL_TYPE_OUTSIDER);
				
				eLink = EffectLinkEffects(eFiendSlayAB, eFiendSlayDam1);				
				eLink = EffectLinkEffects(eLink, eFiendSlayDam2);
				eLink = SupernaturalEffect(eLink);
				eLink = TagEffect(eLink, "EffectFiendSlaying");			
			}	
			else if (nClassLevel >= 17)
			{
				eFiendSlayAB = VersusAlignmentEffect(EffectAttackIncrease(iAttBonus), 0, ALIGNMENT_EVIL);
				eFiendSlayAB = VersusRacialTypeEffect(eFiendSlayAB, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam1 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_5d6, iWeapDamType), 0, ALIGNMENT_EVIL);
				eFiendSlayDam1 = VersusRacialTypeEffect(eFiendSlayDam1, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam2 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_4d6, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
				eFiendSlayDam2 = VersusRacialTypeEffect(eFiendSlayDam2, RACIAL_TYPE_OUTSIDER);
				
				eLink = EffectLinkEffects(eFiendSlayAB, eFiendSlayDam1);				
				eLink = EffectLinkEffects(eLink, eFiendSlayDam2);
				eLink = SupernaturalEffect(eLink);
				eLink = TagEffect(eLink, "EffectFiendSlaying");				
			}		
			else if (nClassLevel >= 15)
			{
				eFiendSlayAB = VersusAlignmentEffect(EffectAttackIncrease(iAttBonus), 0, ALIGNMENT_EVIL);
				eFiendSlayAB = VersusRacialTypeEffect(eFiendSlayAB, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam1 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_4d6, iWeapDamType), 0, ALIGNMENT_EVIL);
				eFiendSlayDam1 = VersusRacialTypeEffect(eFiendSlayDam1, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam2 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_4d6, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
				eFiendSlayDam2 = VersusRacialTypeEffect(eFiendSlayDam2, RACIAL_TYPE_OUTSIDER);
				
				eLink = EffectLinkEffects(eFiendSlayAB, eFiendSlayDam1);				
				eLink = EffectLinkEffects(eLink, eFiendSlayDam2);
				eLink = SupernaturalEffect(eLink);
				eLink = TagEffect(eLink, "EffectFiendSlaying");				
			}	
			else if (nClassLevel >= 13)
			{
				eFiendSlayAB = VersusAlignmentEffect(EffectAttackIncrease(iAttBonus), 0, ALIGNMENT_EVIL);
				eFiendSlayAB = VersusRacialTypeEffect(eFiendSlayAB, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam1 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_4d6, iWeapDamType), 0, ALIGNMENT_EVIL);
				eFiendSlayDam1 = VersusRacialTypeEffect(eFiendSlayDam1, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam2 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_3d6, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
				eFiendSlayDam2 = VersusRacialTypeEffect(eFiendSlayDam2, RACIAL_TYPE_OUTSIDER);
				
				eLink = EffectLinkEffects(eFiendSlayAB, eFiendSlayDam1);				
				eLink = EffectLinkEffects(eLink, eFiendSlayDam2);
				eLink = SupernaturalEffect(eLink);
				eLink = TagEffect(eLink, "EffectFiendSlaying");				
			}
			else if (nClassLevel >= 11)
			{
				eFiendSlayAB = VersusAlignmentEffect(EffectAttackIncrease(iAttBonus), 0, ALIGNMENT_EVIL);
				eFiendSlayAB = VersusRacialTypeEffect(eFiendSlayAB, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam1 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_3d6, iWeapDamType), 0, ALIGNMENT_EVIL);
				eFiendSlayDam1 = VersusRacialTypeEffect(eFiendSlayDam1, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam2 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_3d6, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
				eFiendSlayDam2 = VersusRacialTypeEffect(eFiendSlayDam2, RACIAL_TYPE_OUTSIDER);
				
				eLink = EffectLinkEffects(eFiendSlayAB, eFiendSlayDam1);				
				eLink = EffectLinkEffects(eLink, eFiendSlayDam2);
				eLink = SupernaturalEffect(eLink);
				eLink = TagEffect(eLink, "EffectFiendSlaying");				
			}
			else if (nClassLevel >=9)
			{
				eFiendSlayAB = VersusAlignmentEffect(EffectAttackIncrease(iAttBonus), 0, ALIGNMENT_EVIL);
				eFiendSlayAB = VersusRacialTypeEffect(eFiendSlayAB, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam1 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_3d6, iWeapDamType), 0, ALIGNMENT_EVIL);
				eFiendSlayDam1 = VersusRacialTypeEffect(eFiendSlayDam1, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam2 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_2d6, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
				eFiendSlayDam2 = VersusRacialTypeEffect(eFiendSlayDam2, RACIAL_TYPE_OUTSIDER);
				
				eLink = EffectLinkEffects(eFiendSlayAB, eFiendSlayDam1);				
				eLink = EffectLinkEffects(eLink, eFiendSlayDam2);
				eLink = SupernaturalEffect(eLink);
				eLink = TagEffect(eLink, "EffectFiendSlaying");				
			}	
			else if (nClassLevel >= 7)
			{
				eFiendSlayAB = VersusAlignmentEffect(EffectAttackIncrease(iAttBonus), 0, ALIGNMENT_EVIL);
				eFiendSlayAB = VersusRacialTypeEffect(eFiendSlayAB, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam1 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_2d6, iWeapDamType), 0, ALIGNMENT_EVIL);
				eFiendSlayDam1 = VersusRacialTypeEffect(eFiendSlayDam1, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam2 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_2d6, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
				eFiendSlayDam2 = VersusRacialTypeEffect(eFiendSlayDam2, RACIAL_TYPE_OUTSIDER);
				
				eLink = EffectLinkEffects(eFiendSlayAB, eFiendSlayDam1);				
				eLink = EffectLinkEffects(eLink, eFiendSlayDam2);
				eLink = SupernaturalEffect(eLink);
				eLink = TagEffect(eLink, "EffectFiendSlaying");				
			}	
			else if (nClassLevel >= 5)
			{
				eFiendSlayAB = VersusAlignmentEffect(EffectAttackIncrease(iAttBonus), 0, ALIGNMENT_EVIL);
				eFiendSlayAB = VersusRacialTypeEffect(eFiendSlayAB, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam1 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_2d6, iWeapDamType), 0, ALIGNMENT_EVIL);
				eFiendSlayDam1 = VersusRacialTypeEffect(eFiendSlayDam1, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam2 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_1d6, DAMAGE_TYPE_DIVINE), 0, ALIGNMENT_EVIL);
				eFiendSlayDam2 = VersusRacialTypeEffect(eFiendSlayDam2, RACIAL_TYPE_OUTSIDER);
				
				eLink = EffectLinkEffects(eFiendSlayAB, eFiendSlayDam1);				
				eLink = EffectLinkEffects(eLink, eFiendSlayDam2);
				eLink = SupernaturalEffect(eLink);
				eLink = TagEffect(eLink, "EffectFiendSlaying");			
			}				
			else if (nClassLevel >= 3)
			{
				eFiendSlayAB = VersusAlignmentEffect(EffectAttackIncrease(iAttBonus), 0, ALIGNMENT_EVIL);
				eFiendSlayAB = VersusRacialTypeEffect(eFiendSlayAB, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam1 = VersusAlignmentEffect(EffectDamageIncrease(IP_CONST_DAMAGEBONUS_2d6, iWeapDamType), 0, ALIGNMENT_EVIL);
				eFiendSlayDam1 = VersusRacialTypeEffect(eFiendSlayDam1, RACIAL_TYPE_OUTSIDER);
				
				eLink = EffectLinkEffects(eFiendSlayAB, eFiendSlayDam1);				
				
				eLink = SupernaturalEffect(eLink);
				eLink = TagEffect(eLink, "EffectFiendSlaying");				
			}				
			else
			{
				eFiendSlayAB = VersusAlignmentEffect(EffectAttackIncrease(iAttBonus), 0, ALIGNMENT_EVIL);
				eFiendSlayAB = VersusRacialTypeEffect(eFiendSlayAB, RACIAL_TYPE_OUTSIDER);
				
				eFiendSlayDam1 = VersusAlignmentEffect(EffectDamageIncrease(DAMAGE_BONUS_1d6, iWeapDamType), 0, ALIGNMENT_EVIL);
				eFiendSlayDam1 = VersusRacialTypeEffect(eFiendSlayDam1, RACIAL_TYPE_OUTSIDER);
				
				eLink = EffectLinkEffects(eFiendSlayAB, eFiendSlayDam1);				
				eLink = SupernaturalEffect(eLink);
				eLink = TagEffect(eLink, "EffectFiendSlaying");					
			}
			
		//:: Clear the effect to be safe and prevent stacking
			effect eCheckEffect = GetFirstEffect(oKotC);
				
			while (GetIsEffectValid(eCheckEffect))
			{
				if (GetEffectTag(eCheckEffect) == "EffectFiendSlaying")
				{
					RemoveEffect(oKotC, eCheckEffect);
				
				}
				
			eCheckEffect = GetNextEffect(oKotC);
			
			}

		//:: Make sure we actually have a weapon.
			if (oItem != OBJECT_INVALID)
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oKotC);	

		//:: Hook in the events for Fiendslaying
			if(DEBUG) DoDebug("prc_knghtch: Adding eventhooks");
			AddEventScript(oKotC, EVENT_ONHEARTBEAT,	"prc_knghtch", TRUE, FALSE);			
			AddEventScript(oKotC, EVENT_ONPLAYERUNEQUIPITEM,	"prc_knghtch", TRUE, FALSE);
    }

	//:: We are called from the OnPlayerUnEquipItem eventhook. Remove temp itemprops from oKotC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("prc_knghtch - OnUnEquip\n"
                        + "oKotC = " + DebugObject2Str(oKotC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );	
        //:: Clean up weapons
        if(GetIsWeapon(oItem))
        {
		//:: Clear the effect
			effect eCheckEffect = GetFirstEffect(oKotC);
				
			while (GetIsEffectValid(eCheckEffect))
			{
				if (GetEffectTag(eCheckEffect) == "EffectFiendSlaying")
				{
					RemoveEffect(oKotC, eCheckEffect);
				
				}
				
				eCheckEffect = GetNextEffect(oKotC);		
			}	
		}
	}		
    //:: We are called from the OnPlayerUnAcquireItem eventhook. Remove temp itemprops from oKotC's weapon
    else if(nEvent == EVENT_ONUNAQUIREITEM)
    {
        oItem = GetModuleItemLost();
        if(DEBUG) DoDebug("prc_knghtch - OnUnAcquire\n"
                        + "oKotC = " + DebugObject2Str(oKotC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );	
	//:: Clean up weapons
        if(GetIsWeapon(oItem))
        {
		//:: Clear the effect
			effect eCheckEffect = GetFirstEffect(oKotC);
				
			while (GetIsEffectValid(eCheckEffect))
			{
				if (GetEffectTag(eCheckEffect) == "EffectFiendSlaying")
				{
					RemoveEffect(oKotC, eCheckEffect);
				
				}
				
				eCheckEffect = GetNextEffect(oKotC);		
			}	
		}
	}	

	
    // Everything is handled by the spell's script.
    //ActionCastSpellOnSelf(SPELL_KNIGHTCHALICE_DAMAGE); //prc_knight_dam.nss, Applies attack and damage bonus.
}