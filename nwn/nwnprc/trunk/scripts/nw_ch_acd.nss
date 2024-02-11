//::///////////////////////////////////////////////
//:: User Defined Henchmen Script
//:: NW_CH_ACD
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The most complicated script in the game.
    ... ever
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 18, 2002
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "nw_i0_generic"

void RelayModeToAssociates(int nActionMode, int nValue, object oSelf)
{
    SetActionMode(oSelf, nActionMode, nValue);
    object oTest = GetAssociate(ASSOCIATE_TYPE_FAMILIAR);
    if(GetIsObjectValid(oTest))
        SetActionMode(oTest, nActionMode, nValue);

    oTest = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);
    if(GetIsObjectValid(oTest))
        SetActionMode(oTest, nActionMode, nValue);

    oTest = GetAssociate(ASSOCIATE_TYPE_SUMMONED);
    if(GetIsObjectValid(oTest))
        SetActionMode(oTest, nActionMode, nValue);

    oTest = GetAssociate(ASSOCIATE_TYPE_DOMINATED);
    if(GetIsObjectValid(oTest))
        SetActionMode(oTest, nActionMode, nValue);
}

void main()
{
    object oSelf = OBJECT_SELF;
    int nEvent = GetUserDefinedEventNumber();

    ExecuteScript("prc_onuserdef", oSelf);

    //HenchAI start
    if(!GetIsFighting(oSelf))
    {
        if(nEvent == 20000 + ACTION_MODE_STEALTH)
        {
            if(!GetLocalInt(oSelf, "HenchDisableAutoHide"))
            {
                int bStealth = GetActionMode(GetMaster(), ACTION_MODE_STEALTH);
                RelayModeToAssociates(ACTION_MODE_STEALTH, bStealth, oSelf);
            }
        }
        else if(nEvent == 20000 + ACTION_MODE_DETECT)
        {
            int bDetect = GetActionMode(GetMaster(), ACTION_MODE_DETECT);
            RelayModeToAssociates(ACTION_MODE_DETECT, bDetect, oSelf);
        }
    }
    //HenchAI end

    // * If a creature has the integer variable X2_L_CREATURE_NEEDS_CONCENTRATION set to TRUE
    // * it may receive this event. It will unsommon the creature immediately
    if(nEvent == X2_EVENT_CONCENTRATION_BROKEN)
    {
        effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oSelf));
        FloatingTextStrRefOnCreature(84481, GetMaster(oSelf));
        DestroyObject(oSelf, 0.1f);
    }
}
