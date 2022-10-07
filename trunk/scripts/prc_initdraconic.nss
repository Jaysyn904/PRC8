#include "prc_inc_clsfunc"
#include "prc_inc_unarmed"
#include "prc_ip_srcost"

void SpellResistancePC(object oPC, object oSkin, int iLevel)
{
    //15 +lvl
    if (iLevel % 2 == 0)
    {
       iLevel = (iLevel-10)/2;
       iLevel = (iLevel>IP_CONST_SPELLRESISTANCEBONUS_60) ? IP_CONST_SPELLRESISTANCEBONUS_60 :iLevel ;
    }
    else
    {
       iLevel = iLevel/2+21;
       iLevel = (iLevel>IP_CONST_SPELLRESISTANCEBONUS_61) ? IP_CONST_SPELLRESISTANCEBONUS_61 :iLevel ;

    }

    if (GetLocalInt(oSkin,"IniSR")==iLevel) return;
    RemoveSpecificProperty(oSkin,ITEM_PROPERTY_SPELL_RESISTANCE,-1,IP_CONST_ONHIT_SAVEDC_26,GetLocalInt(oSkin,"IniSR"));
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusSpellResistance(iLevel),oSkin);
    SetLocalInt(oSkin,"IniSR",iLevel);
}

void StunStrike(object oPC,object oSkin)
{
    if (GetLocalInt(oSkin,"IniStunStrk")) return;

    object oWeapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);

    // fixed to work with new unarmed inc
    if(!GetIsPRCCreatureWeapon(oWeapL))
        return;

    RemoveSpecificProperty(oWeapL,ITEM_PROPERTY_ON_HIT_PROPERTIES,IP_CONST_ONHIT_STUN,IP_CONST_ONHIT_SAVEDC_26,IPRP_CONST_ONHIT_DURATION_5_PERCENT_1_ROUNDS);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitProps(IP_CONST_ONHIT_STUN,IP_CONST_ONHIT_SAVEDC_26,IPRP_CONST_ONHIT_DURATION_5_PERCENT_1_ROUNDS),oWeapL);
    SetLocalInt(oSkin,"IniStunStrk",1);

}

void main()
{
    object oPC = OBJECT_SELF;

    // We cannot add stuff to the creature weapons until they have been evaluated,
    // so we request their evaluation, and wait for it to happen.
    if(!GetLocalInt(OBJECT_SELF, UNARMED_CALLBACK))
    {
        //Evaluate The Unarmed Strike Feats
        //UnarmedFeats(oPC);
        SetLocalInt(oPC, CALL_UNARMED_FEATS, TRUE);

        //Evaluate Fists
        //UnarmedFists(oPC);
        SetLocalInt(oPC, CALL_UNARMED_FISTS, TRUE);

        // Request callback once the feat & fist evaluation is done
        AddEventScript(oPC, CALLBACKHOOK_UNARMED, "prc_initdraconic", FALSE, FALSE);
    }
    else
    {
        //Declare main variables.
        object oSkin  = GetPCSkin(oPC);
        object oWeapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);

        if (GetHasFeat(FEAT_INIDR_SPELLRESISTANCE,oPC)) SpellResistancePC(oPC,oSkin,GetLevelByClass(CLASS_TYPE_INITIATE_DRACONIC,oPC)+15);
        if (GetHasFeat(FEAT_INIDR_STUNSTRIKE,oPC)) StunStrike(oPC,oSkin);
    }
}