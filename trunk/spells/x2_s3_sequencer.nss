//::///////////////////////////////////////////////
//:: x2_s3_sequencer
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Fires the spells stored on this sequencer.
    GZ: - Also handles clearing off spells if the
          item has the clear sequencer property
        - added feedback strings
*/
//Modifed by primogenitor to use the PRC casterlevel override for the right level
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 31, 2003
//:: Updated By: Georg
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_inc_onhit"

void ChannelSpell(int nSpellID, int nLevel, int nDC, int nMeta, object oPC = OBJECT_SELF)
{
    ClearAllActions();
    //break association with new spellbook system
    object oTarget = GetLocalObject(oPC, "ChannelSpellTarget");
    int nOverride = TRUE;
    if (!GetIsObjectValid(oTarget))
    {
        nOverride = FALSE;
        oTarget = OBJECT_INVALID;
    }    
    ActionDoCommand(DeleteLocalInt(oPC, "NSB_Class"));
    ActionDoCommand(SetLocalInt(oPC, "SpellIsSLA", TRUE));
    ActionCastSpell(nSpellID, nLevel, 0, nDC, nMeta, CLASS_TYPE_INVALID, FALSE, nOverride, oTarget);
    //ActionDoCommand(DeleteLocalInt(oPC, "SpellIsSLA"));
}

void main()
{
    object oItem = GetSpellCastItem();
    object oPC =   OBJECT_SELF;

    int i = 0;
    int nSpellId = -1;
    int nMode = PRCGetSpellId();
    int iMax = 5;
//    int iMax = IPGetItemSequencerProperty(oItem);
//    if (iMax ==0) // Should never happen unless you added clear sequencer to a non sequencer item
//    {
//        DoDebug("No sequencer on item");
//        return;
//    }
    if (nMode == 720 ) // clear seqencer
    {
        for (i = 1; i <= iMax; i++)
        {
            DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER" + IntToString(i));
            DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER_L" + IntToString(i));
            DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER_M" + IntToString(i));
            DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER_D" + IntToString(i));
        }
        DeleteLocalInt(oItem, "X2_L_NUMTRIGGERS");
        effect eClear = EffectVisualEffect(VFX_IMP_BREACH);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eClear, oPC);
        FloatingTextStrRefOnCreature(83882, oPC); // sequencer cleared
    }
    else
    {
        int bSuccess = FALSE;
        if(nMode == 700) //Fired via OnHit:CastUniqueSpell
        {
            //ClearAllActions();
            if (DEBUG ) DoDebug("Mode 700");
            float fDelay;

            for (i = 1; i <= iMax; i++)
            {
                nSpellId = GetLocalInt(oItem, "X2_L_CHANNELTRIGGER" + IntToString(i));
                int nLevel = GetLocalInt(oItem, "X2_L_CHANNELTRIGGER_L" + IntToString(i));
                int nMeta  = GetLocalInt(oItem, "X2_L_CHANNELTRIGGER_M" + IntToString(i));
                int nDC    = GetLocalInt(oItem, "X2_L_CHANNELTRIGGER_D" + IntToString(i));
                if (DEBUG)
                {
                    DoDebug("nMode = "+IntToString(nMode));
                    DoDebug("nLevel = "+IntToString(nLevel));
                    DoDebug("nMeta = "+IntToString(nMeta));
                    DoDebug("nDC = "+IntToString(nDC));
                }
                if (nSpellId>0)
                {
                    bSuccess = TRUE;
                    nSpellId --; // I added +1 to the spellID when the sequencer was created, so I have to remove it here
                    fDelay = i*0.125-0.125;
                    DelayCommand(fDelay, ChannelSpell(nSpellId, nLevel, nDC, nMeta, oPC));
                    if (DEBUG) DoDebug("Channel Spell Cast");
                }
            }

            if(GetLocalInt(oItem, "DuskbladeChannelDischarge")!=2)//not a discharging duskblade
            {
                if (DEBUG) DoDebug("Mode 700, Not a Duskblade Discharge");
                ActionAttack(GetAttackTarget());
                //clear the settings
                for (i = 1; i <= iMax; i++)
                {
                    DeleteLocalInt(oItem, "X2_L_CHANNELTRIGGER" + IntToString(i));
                    DeleteLocalInt(oItem, "X2_L_CHANNELTRIGGER_L" + IntToString(i));
                    DeleteLocalInt(oItem, "X2_L_CHANNELTRIGGER_M" + IntToString(i));
                    DeleteLocalInt(oItem, "X2_L_CHANNELTRIGGER_D" + IntToString(i));
                }
                DeleteLocalInt(oItem, "X2_L_NUMCHANNELTRIGGERS");
            }
            else if(GetLocalInt(oItem, "DuskbladeChannelDischarge")==2)//is a discharging duskblade
            {
                if (DEBUG) DoDebug("Mode 700, Duskblade Discharge");
                //ActionAttack(GetAttackTarget());
                //clear the settings
                for (i = 1; i <= iMax; i++)
                {
                    DelayCommand(6.0, DeleteLocalInt(oItem, "X2_L_CHANNELTRIGGER"   + IntToString(i)));
                    DelayCommand(6.0, DeleteLocalInt(oItem, "X2_L_CHANNELTRIGGER_L" + IntToString(i)));
                    DelayCommand(6.0, DeleteLocalInt(oItem, "X2_L_CHANNELTRIGGER_M" + IntToString(i)));
                    DelayCommand(6.0, DeleteLocalInt(oItem, "X2_L_CHANNELTRIGGER_D" + IntToString(i)));
                }
                DelayCommand(6.0, DeleteLocalInt(oItem, "X2_L_NUMCHANNELTRIGGERS"));
            }
        }
        else
        {
            for (i = 1; i <= iMax; i++)
            {
                nSpellId = GetLocalInt(oItem, "X2_L_SPELLTRIGGER" + IntToString(i));
                int nLevel = GetLocalInt(oItem, "X2_L_SPELLTRIGGER_L" + IntToString(i));
                int nMeta  = GetLocalInt(oItem, "X2_L_SPELLTRIGGER_M" + IntToString(i));
                int nDC    = GetLocalInt(oItem, "X2_L_SPELLTRIGGER_D" + IntToString(i));
                if (DEBUG)
                {
                    DoDebug("nMode = "+IntToString(nMode));
                    DoDebug("nLevel = "+IntToString(nLevel));
                    DoDebug("nMeta = "+IntToString(nMeta));
                    DoDebug("nDC = "+IntToString(nDC));
                }
                if (nSpellId>0)
                {
                    bSuccess = TRUE;
                    nSpellId --; // I added +1 to the spellID when the sequencer was created, so I have to remove it here
                    //modified to use the PRCs casterlevel override to cheatcast at the right level
                    //also mark it as a SLA so it doesn't need a component
                    ActionDoCommand(DeleteLocalInt(oPC, "NSB_Class"));
                    ActionDoCommand(SetLocalInt(oPC, "SpellIsSLA", TRUE));
                    ActionCastSpell(nSpellId, nLevel,0, nDC, nMeta);
                    ActionDoCommand(DeleteLocalInt(oPC, "SpellIsSLA"));
                }
            }
        }
        if (!bSuccess)
        {
            FloatingTextStrRefOnCreature(83886, oPC); // no spells stored
        }
    }
}