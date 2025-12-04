//::///////////////////////////////////////////////
//:: Name      Claws of the Bebilith event script
//:: FileName  prc_evnt_clbebil.nss
//:://////////////////////////////////////////////
#include "prc_inc_combmove"

void main()
{
	//Check for target's armor/shield
	object oSpellTarget = PRCGetSpellTargetObject();
	object oSpellOrigin = OBJECT_SELF;
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oSpellTarget);
	object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSpellTarget);
	int bArmor;
	int bShield;
	
	int bNoRend	= GetHasFeat(FEAT_INTRINSIC_ARMOR, oSpellTarget);
	
	if (bNoRend)
	{
		SendMessageToPC(oSpellOrigin, "Your target's armor cannot be rended.");
		return;
	}

	if(GetIsObjectValid(oShield))
	{
		//Make sure it's a shield
		int nShield = GetBaseItemType(oShield);

		if(nShield != BASE_ITEM_SMALLSHIELD &&
		   nShield != BASE_ITEM_LARGESHIELD &&
		   nShield != BASE_ITEM_TOWERSHIELD)
	       {
		       int bShield = TRUE;
	       }
       }

       if(GetIsObjectValid(oArmor))
       {
	       int bArmor = TRUE;
       }

	object oAffected = oArmor;
	int nAffectedSlot = INVENTORY_SLOT_CHEST;

	//if both Armor and Shield present
	if(bArmor == TRUE && bShield == TRUE)
	{
		//roll the dice
		int nRoll = d6();

		if(nRoll > 4)
		{
			oAffected = oShield;
			nAffectedSlot = INVENTORY_SLOT_LEFTHAND;
		}
	}

	else if(bShield == TRUE)
	{
		oAffected = oShield;
		nAffectedSlot = INVENTORY_SLOT_LEFTHAND;
	}

	else
	{
		SendMessageToPC(oSpellOrigin, "Your target has no valid items");
		return;
	}

	//The caster makes a grapple check whenever she hits with a claw attack,
	//adding to the opponent's roll any enhancement bonus from magic possessed
	//by the opponent's armor or shield.

	int nEnhance;
	itemproperty ip = GetFirstItemProperty(oAffected);
	while(GetIsItemPropertyValid(ip))
	{
		if(GetItemPropertyType(ip) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
		{
			nEnhance = GetItemPropertyCostTableValue(ip);
			break;
		}
	        ip = GetNextItemProperty(oAffected);
	}
    nEnhance *= -1; // New function needs negatives for target bonuses
	//Check
    if(_DoGrappleCheck(oSpellOrigin, oSpellTarget, nEnhance))
	{
		//check switch
		if(GetPRCSwitch(PRC_BEBILITH_CLAWS_DESTROY))
		{
			if(!GetPlotFlag(oAffected))
			{
				DestroyObject(oAffected);
			}
		}

		else
		{
			if(oAffected == oShield)
			{
				ForceUnequip(oSpellTarget, oAffected, nAffectedSlot);
			}

			//if oArmor, copy to inventory then destroy
			else
			{
				CopyItem(oArmor, oSpellTarget, TRUE);
				DestroyObject(oArmor);
			}
		}

	}
}