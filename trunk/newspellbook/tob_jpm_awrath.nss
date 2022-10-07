#include "prc_sp_func"
////#include "prc_alterations"
#include "inc_addragebonus"

void main()
{
    int nEvent = GetRunningEvent();
    object oInitiator = OBJECT_SELF;
    object oItem;

    // We aren't being called from any event, perform setup
    if(nEvent == FALSE)
    {
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);

        // Has to be a melee weapon
        if(GetWeaponRanged(oItem))
        {
            FloatingTextStringOnCreature("You must use a melee weapon for this ability", oInitiator, FALSE);
            return;
        }

        if(!TakeSwiftAction(oInitiator))
            return;

        int nSpellID = GetLocalInt(oInitiator, "JPM_SPELL_CURRENT");
        int nLevel = GetLocalInt(oInitiator, "JPM_SPELL_CURRENT_LVL");
        string sArray = GetLocalString(oInitiator, "JPM_SPELL_CURRENT");

        int nUses = sArray == "" ? GetHasSpell(nSpellID, oInitiator) :
                    persistant_array_get_int(oInitiator, sArray, nSpellID);

        if(!nUses)
        {
            FloatingTextStringOnCreature("You have no more uses of the chosen spell", oInitiator, FALSE);
            return;
        }

        // if we're here, they can cast
        SetLocalInt(oInitiator, "ArcaneWrath", nLevel);

        if(sArray == "")
        {
            DecrementRemainingSpellUses(oInitiator, nSpellID);
        }
        else
        {
            nUses--;
            persistant_array_set_int(oInitiator, sArray, nSpellID, nUses);
        }

        if(GetLocalInt(oInitiator, "ReserveFeatsRunning"))
            DelayCommand(0.1f, ExecuteScript("prc_reservefeat", oInitiator));

        // Attack bonus for one round
        effect eAtk = EffectAttackIncrease(4);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAtk, oInitiator, 6.0);

        // The OnHit
        IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_jpm_awrath", TRUE, FALSE);
    }
    // We're being called from the OnHit eventhook, so deal the damage
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        int nDamageType = GetDamageTypeOfWeapon(INVENTORY_SLOT_RIGHTHAND, oInitiator);
        effect eDam = EffectDamage(d10(GetLocalInt(oInitiator, "ArcaneWrath")), nDamageType);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);

        // Cleaning
        RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        DeleteLocalInt(oInitiator, "ArcaneWrath");
        RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_jpm_awrath", TRUE, FALSE);
        PRCRemoveEffectsFromSpell(oInitiator, JPM_SPELL_ARCANE_WRATH);
    }
}