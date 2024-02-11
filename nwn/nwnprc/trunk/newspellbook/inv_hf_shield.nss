#include "inv_inc_invfunc"
#include "inv_invokehook"
#include "inv_inc_blast"

void main()
{
    object oPC = OBJECT_SELF, oItem;
    int nEvent = GetRunningEvent();

    if(nEvent == FALSE)
    {
        if(DEBUG) DoDebug("inv_hf_shield: Adding eventhooks");

        AddEventScript(oPC, EVENT_ONHIT, "inv_hf_shield", TRUE, FALSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_FIRE), oPC);

        oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
        if(!GetIsObjectValid(oItem))
            oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
        IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }
    else if(nEvent == EVENT_ONHIT)
    {
        SetLocalInt(oPC, PRC_INVOKING_CLASS, CLASS_TYPE_WARLOCK + 1);
        DelayCommand(0.0f, DeleteLocalInt(oPC, PRC_INVOKING_CLASS));

        if(!PreInvocationCastCode()) return;

        oItem = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();

        if(DEBUG) DoDebug("inv_hf_shield: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        RemoveEventScript(oPC, EVENT_ONHIT, "inv_hf_shield", TRUE, FALSE);
        RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);

        if(HellFireConDamage(oPC))
        {
            int nInvLevel = GetInvokerLevel(oPC, CLASS_TYPE_WARLOCK);
            int nPenetr = nInvLevel + SPGetPenetr();

            //Make SR Check
            if(!PRCDoResistSpell(oPC, oTarget, nPenetr))
            {
                int nDmgDice = GetBlastDamageDices(oPC, nInvLevel)
                             + GetLevelByClass(CLASS_TYPE_HELLFIRE_WARLOCK, oPC) * 2;
                int nDamage = d6(nDmgDice);
                int nDC = 10 + (GetHitDice(oPC) / 2) + GetAbilityModifier(ABILITY_CHARISMA);
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_FIRE);

                if(nDamage)
                {
                    //Apply the VFX impact
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_DIVINE), oTarget);
                }
            }
        }
    }
}
