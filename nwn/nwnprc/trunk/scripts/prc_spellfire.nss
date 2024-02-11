/*

    prc_spellfire.nss - Spellfire functions called here, all routed through the one script

    notes: data stored as persistant local ints

    By: Flaming_Sword
    Created: December 17, 2005
    Modified: February 15, 2006

    Naming conventions:
        nExpend <-> GetPersistantLocalInt(oPC, "SpellfireLevelExpend");
        nStored <-> GetPersistantLocalInt(oPC, "SpellfireLevelStored");

Called Elsewhere:

    CheckSpellfire()

*/
#include "prc_alterations"
#include "prc_spellf_inc"

void main()
{
    object oPC = OBJECT_SELF;
    if(GetHasFeat(FEAT_SHADOWWEAVE, oPC))
    {
        SendMessageToPC(oPC, "You no longer have access to the weave and cannot use spellfire");
        return;
    }
    int nSpellID = GetSpellId();
    object oTarget = PRCGetSpellTargetObject();
    switch (nSpellID)
    {
        case SPELL_SPELLFIRE_ATTACK: SpellfireAttack(oPC, oTarget, TRUE); break;
        case SPELL_SPELLFIRE_HEAL: SpellfireHeal(oPC, oTarget); break;
        case SPELL_SPELLFIRE_CHECK: SendMessageToPC(oPC, "Spellfire levels stored: " + IntToString(GetPersistantLocalInt(oPC, "SpellfireLevelStored"))); break;
        case SPELL_SPELLFIRE_PLUS_ONE: AdjustSpellfire(oPC, 1); break;
        case SPELL_SPELLFIRE_PLUS_FIVE: AdjustSpellfire(oPC, 5); break;
        case SPELL_SPELLFIRE_PLUS_TEN: AdjustSpellfire(oPC, 10); break;
        case SPELL_SPELLFIRE_PLUS_TWENTY: AdjustSpellfire(oPC, 20); break;
        case SPELL_SPELLFIRE_MINUS_ONE: AdjustSpellfire(oPC, -1); break;
        case SPELL_SPELLFIRE_MINUS_FIVE: AdjustSpellfire(oPC, -5); break;
        case SPELL_SPELLFIRE_MINUS_TEN: AdjustSpellfire(oPC, -10); break;
        case SPELL_SPELLFIRE_MINUS_TWENTY: AdjustSpellfire(oPC, -20); break;
        case SPELL_SPELLFIRE_CHECK_EXP: SendMessageToPC(oPC, "Spellfire levels to expend: " + IntToString(GetPersistantLocalInt(oPC, "SpellfireLevelExpend"))); break;
        case SPELL_SPELLFIRE_QUICKSELECT_CHANGE: SpellfireQuickselectChange(oPC); break;
        case SPELL_SPELLFIRE_QUICKSELECT_1: //Gotta love cascading cases
        case SPELL_SPELLFIRE_QUICKSELECT_2:
        case SPELL_SPELLFIRE_QUICKSELECT_3: SpellfireQuickselect(oPC, nSpellID); break;
        case SPELL_SPELLFIRE_DRAIN_CHARGED: SpellfireDrain(oPC, oTarget); break;
        case SPELL_SPELLFIRE_RAPID_BLAST_TWO: SpellfireAttack(oPC, oTarget, TRUE, 2); break;
        case SPELL_SPELLFIRE_RAPID_BLAST_THREE: SpellfireAttack(oPC, oTarget, TRUE, 3); break;
        case SPELL_SPELLFIRE_DRAIN_PERMANENT: SpellfireDrain(oPC, oTarget, FALSE); break;
        case SPELL_SPELLFIRE_CHARGE_ITEM: SpellfireChargeItem(oPC, oTarget); break;
        case SPELL_SPELLFIRE_CROWN: SpellfireCrown(oPC); break;
        case SPELL_SPELLFIRE_MAELSTROM: SpellfireMaelstrom(oPC); break;
        case SPELL_SPELLFIRE_ABSORB: SpellfireToggleAbsorbFriendly(oPC); break;
        default: if(DEBUG) DoDebug("Unrecognized SpellID: " + IntToString(nSpellID), oPC);
    }
}