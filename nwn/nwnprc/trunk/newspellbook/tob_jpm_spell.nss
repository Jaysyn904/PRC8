//:://////////////////////////////////////////////
//:: Spell selection for the Jade Phoenix Mage's abilities
//:: tob_jpm_spell.nss
//:://////////////////////////////////////////////
/** @file
    Spell selection for Jade Phoenix Mage's abilities
    Handles the quickselects

    @author Stratovaris
    @rewritten GC

*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "inc_newspellbook"
#include "tob_move_const"

void main()
{
    object oPC = OBJECT_SELF;
    int nID = GetSpellId();

    if(nID == JPM_SPELL_SELECT_CONVO)
    {
        DelayCommand(0.5, StartDynamicConversation("tob_jpm_spellcon", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, oPC));
    }
    else
    {
        string sSlotNo;
        switch(nID)
        {
            case JPM_SPELL_SELECT_QUICK1: sSlotNo = "1"; break;
            case JPM_SPELL_SELECT_QUICK2: sSlotNo = "2"; break;
            case JPM_SPELL_SELECT_QUICK3: sSlotNo = "3"; break;
            case JPM_SPELL_SELECT_QUICK4: sSlotNo = "4"; break;
        }

        if(sSlotNo == "")
            return;

        int nSpell = GetLocalInt(oPC, "JPM_SPELL_QUICK"+sSlotNo);
        int nLevel = GetLocalInt(oPC, "JPM_SPELL_QUICK"+sSlotNo+"LVL");
        int nRealSpell = GetLocalInt(oPC, "JPM_REAL_SPELL_QUICK"+sSlotNo);
        if(nRealSpell == -1) nRealSpell = nSpell;
        string sArray = GetLocalString(oPC, "JPM_SPELL_QUICK"+sSlotNo);
        SetLocalInt(oPC, "JPM_SPELL_CURRENT", nSpell);
        SetLocalInt(oPC, "JPM_SPELL_CURRENT_LVL", nLevel);
        SetLocalString(oPC, "JPM_SPELL_CURRENT", sArray);
        int nUses = sArray == "" ? GetHasSpell(nSpell, oPC) : persistant_array_get_int(oPC, sArray, nSpell);
        FloatingTextStringOnCreature("*Selected Spell: " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nRealSpell))) + "*", oPC, FALSE);
        FloatingTextStringOnCreature("*You have " + IntToString(nUses) + " uses left*", oPC, FALSE);
    }
}