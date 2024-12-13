/*
    File Name: prc_iaijutsu
    Author: aser
    Date: Feb 26 2005
    Purpose: To simulate an Iaijutsu Focus Attack

    Modified by Flaming_Sword
    Nov 17 2005
*/

//#include "NW_I0_GENERIC"
//#include "x0_i0_position"
//#include "prc_feat_const"
#include "prc_inc_combat"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    object oItem1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    object oItem2 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    object oWeap = GetFirstItemInInventory(oPC);
    int iMainHand;
    int iNumDice;
    int iNumSides;
    int nDamage = 0;
    int iChaMod = GetAbilityModifier(ABILITY_CHARISMA,oPC);
    int iSkill = GetSkillRank(SKILL_IAIJUTSU_FOCUS,oPC)+ d20(); //Iaijutsu Focus Check
	
	if(DEBUG) DoDebug("prc_iaijutsu >> Initial Iaijutsu focus check is "+IntToString(iSkill)+".");

    if(GetHasFeat(FEAT_SKILL_FOCUS_IAI))
        if(GetHasFeat(FEAT_EPIC_SKILL_FOCUS_IAI))
            iSkill = iSkill + 13;
        else
            iSkill = iSkill + 3;
		
	if(DEBUG) DoDebug("prc_iaijutsu >> Finall Iaijutsu focus check is "+IntToString(iSkill)+".");
	
    //string OneKat;
    int iDie = 0;

    //SetLocalInt(oPC,OneKat,0);
    //int OneKat = 0;

    //Calculate Bonus Damage
    iDie = iSkill / 5;
    if(iDie > 0) //if iaijutsu check was successful
    {
        if(!GetHasFeat(FEAT_EPIC_IAIJUTSU_FOCUS)) //If not epic iaijutsu
            if(iDie > 9)
                iDie = 9;

        nDamage = d6(iDie);
		if(DEBUG) DoDebug("prc_iaijutsu >> Iaijutsu damage = "+IntToString(nDamage)+" extra damage.");
		

        if(GetHasFeat(FEAT_STRIKE_VOID)) 
		{
			nDamage = nDamage + iChaMod*iDie;
			if(DEBUG) DoDebug("prc_iaijutsu >> Strike of the Void grants +"+IntToString(iChaMod+iDie)+" extra damage.");
		}
        // Only works on flatfooted foes or objects. Does half damage to objects
        if (!GetIsDeniedDexBonusToAC(oTarget, oPC) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE) 
		{
			if(DEBUG) DoDebug("prc_iaijutsu >> Target is not flat-footed");
			nDamage = 0;
		}
        else if (GetObjectType(oTarget) != OBJECT_TYPE_CREATURE) nDamage /= 2;
    }

    //Begin Attack Scripting
    if(oTarget != oPC)
    {
        if(!GetIsObjectValid(oItem2) && !GetIsObjectValid(oItem1))
        {
            //Searching for a single Katana
            while(GetIsObjectValid(oWeap) /*&& !OneKat*/)
            {
                if(GetBaseItemType(oWeap) == BASE_ITEM_KATANA
                    || // Hack - Assume a Soulknife with Iaijutsu Master levels using bastard sword shape has it shaped like a katana
                   (GetStringLeft(GetTag(oWeap), 14) == "prc_sk_mblade_" && GetBaseItemType(oWeap) == BASE_ITEM_BASTARDSWORD)
                   )
                {
                    ActionEquipItem(oWeap,INVENTORY_SLOT_RIGHTHAND);
                    effect eVFX;
                    //this is an action to make sure the "katana" is equiped
                    ActionDoCommand(PerformAttackRound(oTarget, oPC, eVFX, 0.0, 0, nDamage, DAMAGE_TYPE_SLASHING, FALSE, "*Iaijutsu Hit*", "*Iaijutsu Miss"));
                    //OneKat = 1;
                    break;
                }
                oWeap = GetNextItemInInventory(oPC);
            }
        }
        else
        {
            FloatingTextStringOnCreature("Must have Katana unequiped, in inventory.",OBJECT_SELF);
        }
    }
    else if(GetIsObjectValid(oItem2))
    {
        ActionUnequipItem(oItem2);
    }
}