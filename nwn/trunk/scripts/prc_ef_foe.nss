#include "prc_inc_stunfist"
#include "prc_inc_combat"

void AddHooks(object oItem)
{
    if(GetBaseItemType(oItem) == BASE_ITEM_KAMA || GetIsPRCCreatureWeapon(oItem))
    {
        RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "prc_ef_foe", TRUE, FALSE);
        // Add eventhook to the item
        AddEventScript(oItem, EVENT_ITEM_ONHIT, "prc_ef_foe", TRUE, FALSE);

        // Add the OnHitCastSpell: Unique needed to trigger the event
        IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), RoundsToSeconds(1), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    int nEvent = GetRunningEvent();

    // We arent being called from onhit event, instead from spell script, so activate spell and hooks
    if(nEvent == FALSE)
    {
        if(!GetHasMonkWeaponEquipped(oPC))
            return;

        if(GetHasSpellEffect(SPELL_EF_FIST_OF_ENERGY_FIRE, oPC))
            return;
        if(GetHasSpellEffect(SPELL_EF_FIST_OF_ENERGY_ELECTRICITY, oPC))
            return;

        if(!ExpendStunfistUses(oPC, 1))
            return;

        int eDmgType;
        int nSpellID = GetSpellId();
        switch (nSpellID)
        {
            case SPELL_EF_FIST_OF_ENERGY_FIRE       : eDmgType = DAMAGE_TYPE_FIRE; break;
            case SPELL_EF_FIST_OF_ENERGY_ELECTRICITY: eDmgType = DAMAGE_TYPE_ELECTRICAL; break;
            default: if(DEBUG) DoDebug("Unrecognized SpellID: " + IntToString(nSpellID), oPC);
        }

        effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_1d6, eDmgType);
               eDmg = EffectLinkEffects(eDmg, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
               eDmg = SupernaturalEffect(eDmg);

        effect eVFX = EffectVisualEffect(VFX_IMP_HOLY_AID);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDmg, oPC, RoundsToSeconds(1));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oPC);

        if(GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST,oPC) >= 6)
        {
            // setup hooks
            AddHooks(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
            AddHooks(GetItemInSlot(INVENTORY_SLOT_LEFTHAND , oPC));
            AddHooks(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC));
            AddHooks(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC));
        }
    }
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        object oItem  = GetSpellCastItem();
        int eDmgType;

        if (GetHasSpellEffect(SPELL_EF_FIST_OF_ENERGY_FIRE, oPC)) {
            eDmgType = DAMAGE_TYPE_FIRE;
        } else if (GetHasSpellEffect(SPELL_EF_FIST_OF_ENERGY_ELECTRICITY, oPC))    {
            eDmgType = DAMAGE_TYPE_ELECTRICAL;
        } else {
            // undo hooks
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "prc_ef_foe", TRUE, FALSE);
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);
            return;
        }

        object oTarget = PRCGetSpellTargetObject();

        // GetBaseItemType(oWeapR) == BASE_ITEM_KAMA
        int nThreat = 20; // todo, take into account WM with kama, and other(?) crit modifiers
        int iDiceCritical = 1; // todo, take into account WM with kama, and other(?) crit modifier

        int dice = d20();

        if (dice >= nThreat)
        {
            FloatingTextStringOnCreature("Critical Hit", oPC);
            int nDamage = d10(iDiceCritical);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(nDamage, eDmgType), oTarget);
        }
    }
}