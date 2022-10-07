/*
   ----------------
   Flame of the Shadow Sun

   tob_ssn_flamess.nss
   ----------------

    18 MAR 09 by GC
*/ /** @file

*/
#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"
#include "prc_inc_sp_tch"

void main()
{
    int nEvent = GetRunningEvent();
    int nID    = GetSpellId();
    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oInitiator);

    if(nID == SSN_FLAMESS_ATTACK)
    {
        if(!GetLocalInt(oInitiator, "SSN_FLAMESS_PASS"))
        {
            FloatingTextStringOnCreature("*Your protection has not yet been breached*", oInitiator, FALSE);
            return;
        }
        int nAttackRoll = PRCDoRangedTouchAttack(oTarget, TRUE, oInitiator);
        if(nAttackRoll > 0)
        {
            effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
            ApplyTouchAttackDamage(oInitiator, oTarget, 1, d6(2), DAMAGE_TYPE_FIRE);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            DeleteLocalInt(oInitiator, "SSN_FLAMESS_PASS");
        }

        return; // Skip the rest
    }
    if(nEvent == FALSE)
    {// Called as spell
        if(!TakeSwiftAction(oInitiator)) return;
        if (!PreManeuverCastCode())
        {
            // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
            return;
        }
        // End of Spell Cast Hook

        struct maneuver move = EvaluateManeuver(oInitiator, oTarget, TRUE);
        effect eLink;

        if(move.bCanManeuver)
        {
            //eLink = EffectDamageResistance(DAMAGE_TYPE_COLD, 10);
            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PARALYZED));
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oInitiator, 6.0);

            // The OnHit
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_ssn_flamess", TRUE, FALSE);
            DelayCommand(6.0, RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_ssn_flamess", TRUE, FALSE));
            DelayCommand(6.0, RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY));
        }
    }
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem = GetSpellCastItem();
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            int nCold = min(10, GetDamageDealtByType(DAMAGE_TYPE_COLD));
            if(nCold > 0)
            {
            effect eHeal = EffectHeal(nCold);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oInitiator);
            SetLocalInt(oInitiator, "SSN_FLAMESS_PASS", TRUE);
            DelayCommand(6.0, DeleteLocalInt(oInitiator, "SSN_FLAMESS_PASS"));
            // Cleanup
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_ssn_flamess", TRUE, FALSE);
            }
        }
    }
}