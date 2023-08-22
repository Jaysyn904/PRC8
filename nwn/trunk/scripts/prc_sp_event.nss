/*
    prc_sp_event

    Script for implementing holding the charge
        touch attacks

    By: Flaming_Sword
    Created: February 2, 2006
    Modified: February 12, 2006
*/

#include "prc_sp_func"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nID = GetSpellId();
    int nEvent = GetRunningEvent();

    if (nEvent == EVENT_ITEM_ONHIT) {
        int nCharges = GetLocalInt(oPC, PRC_SPELL_CHARGE_COUNT);
        int nSpellID = GetLocalInt(oPC, PRC_SPELL_CHARGE_SPELLID);

        if(nCharges > 0)
        {
            SetLocalInt(oPC, "AttackHasHit", 1); // maybe do crit in 1/20 chance?
            SetLocalInt(oPC, "NoSpellSneak", TRUE);
            SetLocalInt(oPC, PRC_CASTERLEVEL_OVERRIDE, GetLocalInt(oPC, PRC_SPELL_CHARGE_LEVEL));
            RunImpactScript(oPC, nSpellID, PRC_SPELL_EVENT_ATTACK);
            DeleteLocalInt(oPC, "AttackHasHit");
            DeleteLocalInt(oPC, "NoSpellSneak");
            DeleteLocalInt(oPC, PRC_CASTERLEVEL_OVERRIDE);
        }
    }
    else if(nID == SPELLS_SPELLS_TOUCH_ATTACK || nID == SPELLS_SPELLS_RANGED_ATTACK)
    {
        int nCharges = GetLocalInt(oPC, PRC_SPELL_CHARGE_COUNT);
        if(nCharges > 0)//sanity check
        {
            int nSpellID = GetLocalInt(oPC, PRC_SPELL_CHARGE_SPELLID);
            SetLocalInt(oPC, PRC_CASTERLEVEL_OVERRIDE, GetLocalInt(oPC, PRC_SPELL_CHARGE_LEVEL));
            if (nID == SPELLS_SPELLS_TOUCH_ATTACK && !IsTouchSpell(nSpellID) && !GetHasFeat(FEAT_EF_HOLD_RAY, oPC))
                SendMessageToPC(oPC, "This is not a touch spell");  //sanity check
            else if (nID == SPELLS_SPELLS_TOUCH_ATTACK && !IsTouchSpell(nSpellID) && !IsRaySpell(nSpellID) && GetHasFeat(FEAT_EF_HOLD_RAY, oPC))
                SendMessageToPC(oPC, "This is not a touch or ray spell");  //sanity check
            else if(IsTouchSpell(nSpellID) && nID == SPELLS_SPELLS_RANGED_ATTACK)
                SendMessageToPC(oPC, "This is not a ranged spell");  //sanity check
            else
                RunSpellScript(oPC, nSpellID, PRC_SPELL_EVENT_ATTACK);
            DelayCommand(1.0, DeleteLocalInt(oPC, PRC_CASTERLEVEL_OVERRIDE));
        }
        else
            SendMessageToPC(oPC, "You have no charges remaining");
    }
    else if(nID == SPELLS_SPELLS_CONCENTRATION_TARGET)
    {
        SetLocalObject(oPC, PRC_SPELL_CONC_TARGET, oTarget);
        FloatingTextStringOnCreature("*Target Selected*", oPC);
    }
    else if (nID == SPELLS_SPELLS_HOLD_CHARGE_TOGGLE)
    {
        int nState = GetLocalInt(oPC, PRC_SPELL_HOLD);
        if(nState)
            FloatingTextStringOnCreature("*Normal Casting*", oPC);
        else
            FloatingTextStringOnCreature("*Holding the Charge*", oPC);

        SetLocalInt(oPC, PRC_SPELL_HOLD, !nState);
    }
}