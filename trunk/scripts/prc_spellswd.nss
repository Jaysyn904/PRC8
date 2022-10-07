//::///////////////////////////////////////////////
//:: [Spellsword Feats]
//:: [prc_spellswd.nss]
//:://////////////////////////////////////////////
//:: Check to see which Spellsword feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius.  Modified by Aaon Graywolf
//:: Modified by Solowing
//:: Created On: Dec 28, 2003
//:://////////////////////////////////////////////

#include "prc_class_const"
#include "inc_item_props"

void main()
{
    object oPC = OBJECT_SELF;

    if(GetLocalInt(oPC, "ONREST"))
    {
        object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        if(GetLocalInt(oItem, "spell"))
        {
            DeleteLocalString(oItem,"spellscript1");
            DeleteLocalString(oItem,"spellscript2");
            DeleteLocalString(oItem,"spellscript3");
            DeleteLocalString(oItem,"spellscript4");
            DeleteLocalString(oItem,"metamagic_feat_1");
            DeleteLocalString(oItem,"metamagic_feat_2");
            DeleteLocalString(oItem,"metamagic_feat_3");
            DeleteLocalString(oItem,"metamagic_feat_4");
            DeleteLocalInt(oItem,"spell");
            DeleteLocalInt(oPC,"spellswd_aoe");
            DeleteLocalInt(oPC,"spell_metamagic");
        }
        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
        if(GetLocalInt(oItem, "spell"))
        {
            DeleteLocalString(oItem,"spellscript1");
            DeleteLocalString(oItem,"spellscript2");
            DeleteLocalString(oItem,"spellscript3");
            DeleteLocalString(oItem,"spellscript4");
            DeleteLocalString(oItem,"metamagic_feat_1");
            DeleteLocalString(oItem,"metamagic_feat_2");
            DeleteLocalString(oItem,"metamagic_feat_3");
            DeleteLocalString(oItem,"metamagic_feat_4");
            DeleteLocalInt(oItem,"spell");
            DeleteLocalInt(oPC,"spellswd_aoe");
            DeleteLocalInt(oPC,"spell_metamagic");
        }
        //set the charges remaining
        if(GetLevelByClass(CLASS_TYPE_SPELLSWORD, oPC) > 3)
        {
            int nUses = (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oPC)/2)+1;
            SetPersistantLocalInt(oPC, "spellswordchannelcharges", nUses);
            SendMessageToPC(oPC, IntToString(nUses)+" uses of channel spell left");
        }
    }
}

