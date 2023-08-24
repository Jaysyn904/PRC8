//::///////////////////////////////////////////////
//:: Time Stop
//:: NW_S0_TimeStop.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
//:://////////////////////////////////////////////
//:: FileName: "ss_ep_grtimestop"
/*   Purpose: Greater Timestop - in all ways this spell is the same as
        Timestop except for the duration, which is doubled.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 11, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_timestop"
#include "inc_epicspells"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
    int nDuration = d4(2)+2;

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_GR_TIME))
    {
        location lTarget = PRCGetSpellTargetLocation();
        effect eVis = EffectVisualEffect(VFX_FNF_TIME_STOP);
        effect eTime = EffectTimeStop();
        float fDuration = RoundsToSeconds(nDuration);

        if(GetPRCSwitch(PRC_TIMESTOP_BIOWARE_DURATION))
             fDuration = 18.0;
        if(GetPRCSwitch(PRC_TIMESTOP_LOCAL))
        {
            eTime = EffectAreaOfEffect(VFX_PER_NEW_TIMESTOP);
            eTime = EffectLinkEffects(eTime, EffectEthereal());
            if(GetPRCSwitch(PRC_TIMESTOP_NO_HOSTILE))
            {
                object oCaster = OBJECT_SELF;
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCaster),fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster),fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_BULLETS, oCaster),fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_ARROWS, oCaster),fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_BOLTS, oCaster),fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oCaster),fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCaster),fDuration);
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCaster),fDuration);            
                DelayCommand(fDuration, RemoveTimestopEquip());
                /*
                string sSpellscript = PRCGetUserSpecificSpellScript();
                DelayCommand(fDuration, PRCSetUserSpecificSpellScript(sSpellscript));
                PRCSetUserSpecificSpellScript("tsspellscript");
                    now in main spellhook*/ 
            }
        }


        SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_TIME_STOP, FALSE));
        DelayCommand(0.75, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTime, OBJECT_SELF, fDuration, TRUE, -1, GetTotalCastingLevel(OBJECT_SELF)));
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

