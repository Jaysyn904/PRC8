//::///////////////////////////////////////////////
//:: Name           Flay maintain script
//:: FileName       wol_m_flay
//:://////////////////////////////////////////////
/*
LEGACY ITEM BONUSES
5th - Snake Sting 3/day 
7th - +1 animal bane whip 
8th - Whip Wrap 
10th - Snake Sense
*/

#include "prc_inc_template"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_flay running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC, oItem;
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;

        default:
            oPC = OBJECT_SELF;
    }
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Flay");
    
    // You get nothing if you aren't wielding the legacy weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))
    {
        SetCompositeBonus(oSkin, "Flay_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "Flay_Search", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
    	return;
    }
    
    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {     
        // 5th to 10th level abilities
        if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
        {
            if(nHD >= 5)
            {
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FLAY_SNAKE_STING), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }         
            if(nHD >= 6)
            {
                if (9 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 1)), "WOLEffect"), oPC);
                nHPPen += 2;
            }     
            if(nHD >= 7)
            {
                SetCompositeBonus(oSkin, "Flay_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL); 
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_ANIMAL, 3));
                IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_ANIMAL, IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGEBONUS_2d6));             
            } 
            if(nHD >= 8)
            {
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FLAY_WHIP_WRAP), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            } 
            if(nHD >= 9)
            {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 2)), "WOLEffect"), oPC);
            }
            if(nHD >= 10)
            {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectUltravision()), "WOLEffect"), oPC);
                SetCompositeBonus(oSkin, "Flay_Search", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
                nHPPen += 2;
            }    
        }
            
        SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
        if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
        {
            WoLHealthPenaltyHB(oPC);
            SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
        }
    }    
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("wol_m_flay - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        if(oItem == oWOL)
        {
            // Can't equip while using it to grapple
            ForceUnequip(oPC, oWOL, INVENTORY_SLOT_RIGHTHAND);
        }
    }    
}