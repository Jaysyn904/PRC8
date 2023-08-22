/*
   ----------------
   Void of the Shadow Sun

   tob_ssn_voidss.nss
   ----------------

    18 MAR 09 by GC
*/ /** @file

*/
#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"
#include "prc_inc_sp_tch"

void TheDarkness(object oInitiator)
{
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), GetLocation(oInitiator));
        int nDC    = 10 + GetHitDice(oInitiator)/2 + GetAbilityModifier(ABILITY_WISDOM);

    effect eLink;
    effect eVis = EffectVisualEffect(VFX_DUR_DARKNESS);
    
    while(GetIsObjectValid(oTarget))
    {
        if(GetIsEnemy(oTarget))
        {
            int nDamage = PRCGetReflexAdjustedDamage(d6(8), oTarget, nDC, SAVING_THROW_TYPE_COLD);
            eLink       = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
            eLink       = SupernaturalEffect(eLink);
            if(nDamage > 0)
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), GetLocation(oInitiator));
    }
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oInitiator, 1.0);
}

void main()
{
    int nEvent = GetRunningEvent();
    int nID    = GetSpellId();
    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    object oItem         = GetItemInSlot(INVENTORY_SLOT_CHEST, oInitiator);
    
    if(nID == SSN_VOIDSS_ATTACK)
    {
        if(!GetLocalInt(oInitiator, "SSN_VOID_BLAST"))
        {
            FloatingTextStringOnCreature("*Your Void of the Shadow Sun defense was not breached*", oInitiator, FALSE);
            return;
        }

        TheDarkness(oInitiator);
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

        // Was our defense breached last turn?
        if(GetLocalInt(oInitiator, "SSN_VOID_BLAST"))
        {
            FloatingTextStringOnCreature("*You cannot shield yourself with Void of the Shadow Sun this turn*", oInitiator, FALSE);
            return;
        }

        struct maneuver move = EvaluateManeuver(oInitiator, oTarget, TRUE);
        effect eLink;

        if(move.bCanManeuver)
        {
            //eLink = EffectDamageResistance(DAMAGE_TYPE_COLD, 10);
            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR));
            eLink = EffectLinkEffects(eLink, EffectACIncrease(2, AC_DEFLECTION_BONUS));
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oInitiator, 6.0);

            // The OnHit
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_ssn_voidss", TRUE, FALSE);
            DelayCommand(6.0, RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_ssn_voidss", TRUE, FALSE));
        }
    }
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem = GetSpellCastItem();
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            effect eLook = GetFirstEffect(oInitiator);
            while (GetIsEffectValid(eLook))
            {
              if (GetEffectSpellId(eLook) == nID && GetEffectType(eLook) == EFFECT_TYPE_AC_INCREASE)
                RemoveEffect(oInitiator, eLook);
              eLook = GetNextEffect(oInitiator);
            }// Remove deflection bonus

            // Allow void blast next turn
            FloatingTextStringOnCreature("*Void of the Shadow Sun breached*", oInitiator, FALSE);
            SetLocalInt(oInitiator, "SSN_VOID_BLAST", TRUE);
            DelayCommand(6.0, DeleteLocalInt(oInitiator, "SSN_VOID_BLAST"));

            // Cleanup
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_ssn_voidss", TRUE, FALSE);
        }
    }
}
