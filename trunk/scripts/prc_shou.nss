//::///////////////////////////////////////////////
//:: Shou Disciple
//:: prc_shou.nss
//:://////////////////////////////////////////////
//:: Check to see which Shou Disciple feats a PC
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: June 28, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_unarmed"


/*
it_crewpb006 - 1d6
it_crewpb011 - 1d8
it_crewpb015 - 1d10
it_crewpb016 - 2d6
*/


void DodgeBonus(object oPC, object oSkin)
{

    //SendMessageToPC(OBJECT_SELF, "DodgeBonus is called");

    int ACBonus = 0;
    int iShou = GetLevelByClass(CLASS_TYPE_SHOU, oPC);

    //SendMessageToPC(OBJECT_SELF, "Shou Class Level: " + IntToString(iShou));

    if(iShou > 0 && iShou < 2)
    {
        ACBonus = 1;
    }
    else if(iShou >= 2 && iShou < 4)
    {
        ACBonus = 2;
    }
    else if(iShou >= 4)
    {
        ACBonus = 3;
    }

    //SendMessageToPC(OBJECT_SELF, "Dodge Bonus to AC: " + IntToString(ACBonus));

    SetCompositeBonus(oSkin, "ShouDodge", ACBonus, ITEM_PROPERTY_AC_BONUS);
    SetLocalInt(oPC, "HasShouDodge", 2);
}


void RemoveDodge(object oPC, object oSkin)
{
    SetCompositeBonus(oSkin, "ShouDodge", 0, ITEM_PROPERTY_AC_BONUS);
    SetLocalInt(oPC, "HasShouDodge", 1);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

    object oWeapRL = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oWeapLL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

    int iBaseL = GetBaseItemType(oWeapLL);
    int iBaseR = GetBaseItemType(oWeapRL);
    int iEquip = GetLocalInt(oPC,"ONEQUIP");
    string nMes = "";

    //SendMessageToPC(OBJECT_SELF, "prc_shou is called");

    if( GetBaseAC(oArmor) > 3 )
    {
        RemoveDodge(oPC, oSkin);

        if(GetHasSpellEffect(SPELL_MARTIAL_FLURRY_LIGHT, oPC) || GetHasSpellEffect(SPELL_MARTIAL_FLURRY_ALL, oPC))
        {
          PRCRemoveEffectsFromSpell(oPC, SPELL_MARTIAL_FLURRY_LIGHT);
          PRCRemoveEffectsFromSpell(oPC, SPELL_MARTIAL_FLURRY_ALL);
        }

        FloatingTextStringOnCreature("*Shou Disciple Abilities Disabled Due To Equipped Armour*", oPC);
    }
    else if(iBaseL == BASE_ITEM_SMALLSHIELD || iBaseL == BASE_ITEM_LARGESHIELD || iBaseL == BASE_ITEM_TOWERSHIELD)
    {
        RemoveDodge(oPC, oSkin);

        if(GetHasSpellEffect(SPELL_MARTIAL_FLURRY_LIGHT, oPC) || GetHasSpellEffect(SPELL_MARTIAL_FLURRY_ALL, oPC))
        {
          PRCRemoveEffectsFromSpell(oPC, SPELL_MARTIAL_FLURRY_LIGHT);
          PRCRemoveEffectsFromSpell(oPC, SPELL_MARTIAL_FLURRY_ALL);
        }

        FloatingTextStringOnCreature("*Shou Disciple Abilities Disabled Due To Equipped Shield*", oPC);
    }
    // This checks to make sure he doesnt have a non-light weapon equipped for Martial Flurry Light
    else if(StringToInt(Get2DACache("baseitems", "WeaponSize", iBaseL)) > 2 || StringToInt(Get2DACache("baseitems", "WeaponSize", iBaseR)) > 2)
    {
        PRCRemoveEffectsFromSpell(oPC, SPELL_MARTIAL_FLURRY_LIGHT);
        FloatingTextStringOnCreature("*Martial Flurry Light Disabled Due to Equipped Weapons*", oPC);
    }
    else
    {
        if(GetLevelByClass(CLASS_TYPE_SHOU, oPC) > 1 )
        {
            RemoveDodge(oPC, oSkin);
            DodgeBonus(oPC, oSkin);
        }
    }

    //Evaluate The Unarmed Strike Feats
    //UnarmedFeats(oPC);
    SetLocalInt(OBJECT_SELF, CALL_UNARMED_FEATS, TRUE);

    //Evaluate Fists
    //UnarmedFists(oPC);
    SetLocalInt(OBJECT_SELF, CALL_UNARMED_FISTS, TRUE);
}
