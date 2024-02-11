//::///////////////////////////////////////////////
//:: Name listener_conv
//:: Copyright (c) 2005
//:://////////////////////////////////////////////
/*
    Modified spawn script, includes PRC
        and listen patterns
*/
//:://////////////////////////////////////////////
//:: Created By: Flaming_Sword
//:: Created On: Oct 9, 2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_ecl"
#include "inc_utility"
#include "nw_i0_plot"

void Align(object oShouter, int nAlign, int nNewAlign, int nAlignment1, int nAlignment2)
{
    int nAlignment, nShift;

    while(nAlign != nNewAlign)
    {
        nAlignment = nAlignment1;
        nShift = nNewAlign - nAlign;
        if(nShift < 0)
        {
            nAlignment = nAlignment2;
            nShift = 0 - nShift;
        }
        AdjustAlignment(oShouter, nAlignment, nShift);
        nAlign = (nAlignment1 == ALIGNMENT_GOOD) ? GetGoodEvilValue(oShouter) : GetLawChaosValue(oShouter);
    }

    return;
}

void main()
{

    int nMatch = GetListenPatternNumber();
    int nLevel, nXP, nAlign, nNewAlign, nShift, nAlignment, nSpell, nVis;
    object oShouter = GetLastSpeaker();
    int nHD = GetHitDice(oShouter);
    float nXPf;
    //SendMessageToPC(oShouter, IntToString(nMatch));  //DEBUGGING
    switch(nMatch)
    {
        case 5000:
        {
            nLevel = StringToInt(GetMatchedSubstring(1));
            if((nLevel > 0) && (nLevel <= 40))
            {
                nXPf = IntToFloat(GetXP(oShouter));
                nHD = FloatToInt((1 + (sqrt(1 + (nXPf / 125)))) / 2);
                nSpell = (nLevel >= nHD) ? SPELL_AID : SPELL_ENERGY_DRAIN;
                nVis = (nLevel >= nHD) ? VFX_IMP_HOLY_AID : VFX_IMP_REDUCE_ABILITY_SCORE;
                //ActionCastFakeSpellAtObject(nSpell, oShouter);
                ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVis), oShouter));
                ActionDoCommand(SetXP(oShouter, nLevel * (nLevel - 1) * 500));
                SetPersistantLocalInt(oShouter, sXP_AT_LAST_HEARTBEAT, nLevel*(nLevel-1)*500);
            }
        }
        break;

        case 5001:
        {
            //ActionCastFakeSpellAtObject(SPELL_MORDENKAINENS_DISJUNCTION, oShouter);
            nXP = GetXP(oShouter);
            ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION), oShouter));
            ActionDoCommand(SetXP(oShouter, 0));
            ActionDoCommand(SetXP(oShouter, nXP));
        }
        break;

        case 5002:
        {
            nAlign = GetGoodEvilValue(oShouter);
            nNewAlign = StringToInt(GetMatchedSubstring(1));

            nShift = nNewAlign - nAlign;
            nSpell = (nShift < 0) ? SPELL_HARM : SPELL_HEAL;
            nVis = (nShift < 0) ? VFX_IMP_HARM : VFX_IMP_HEALING_X;

            if((nNewAlign >= 0) && (nNewAlign <= 100))
            {
                //ActionCastFakeSpellAtObject(nSpell, oShouter);
                ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVis), oShouter));
                ActionDoCommand(Align(oShouter, nAlign, nNewAlign, ALIGNMENT_GOOD, ALIGNMENT_EVIL));
            }
        }
        break;

        case 5003:
        {
            nAlign = GetLawChaosValue(oShouter);
            nNewAlign = StringToInt(GetMatchedSubstring(1));

            nShift = nNewAlign - nAlign;
            nSpell = (nShift < 0) ? SPELL_HARM : SPELL_HEAL;
            nVis = (nShift < 0) ? VFX_IMP_HARM : VFX_IMP_HEALING_X;

            if((nNewAlign >= 0) && (nNewAlign <= 100))
            {
                //ActionCastFakeSpellAtObject(nSpell, oShouter);
                ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVis), oShouter));
                ActionDoCommand(Align(oShouter, nAlign, nNewAlign, ALIGNMENT_LAWFUL, ALIGNMENT_CHAOTIC));
            }
        }
        break;

        case 5004:
        {
            //ActionCastFakeSpellAtObject(SPELL_PROTECTION_FROM_EVIL, oShouter);
            ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oShouter));
            ActionDoCommand(GiveGoldToCreature(oShouter, StringToInt(GetMatchedSubstring(1))));
        }
        break;

        case 5005:
        {
            string sShop = GetMatchedSubstring(1);
            object oShop = GetObjectByTag(sShop);
            if(GetIsObjectValid(oShop))
                gplotAppraiseOpenStore(oShop, oShouter);
        }
        break;

        case 5006:
        {
            //ActionCastFakeSpellAtObject(SPELL_CALL_LIGHTNING, oShouter);
            ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oShouter));
            int i;
            object oItem;
            for(i = 0; i < NUM_INVENTORY_SLOTS; i++)
            {
                oItem = GetItemInSlot(i, oShouter);
                if(GetItemCharges(oItem))
                    SetItemCharges(oItem, 50);
            }
            oItem = GetFirstItemInInventory(oShouter);
            while(GetIsObjectValid(oItem))
            {
                if(GetItemCharges(oItem))
                    SetItemCharges(oItem, 50);
                oItem = GetNextItemInInventory(oShouter);
            }
        }
        break;

        case 5007:
        {
            //ActionCastFakeSpellAtObject(SPELL_NATURES_BALANCE, oShouter);
            ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_NATURES_BALANCE), oShouter));
            ActionDoCommand(GiveXPToCreature(oShouter, StringToInt(GetMatchedSubstring(1))));
            SetPersistantLocalInt(oShouter, sXP_AT_LAST_HEARTBEAT, 
                GetPersistantLocalInt(oShouter, sXP_AT_LAST_HEARTBEAT)+StringToInt(GetMatchedSubstring(1)));
        }
        break;

        default:
        {
        }
        break;
    }
    // Execute scripts hooked to this event for the NPC triggering it
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_NPC_ONCONVERSATION);
}