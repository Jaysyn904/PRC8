//::///////////////////////////////////////////////
//:: Lingering Damage
//:: ft_lingdmg
//:://////////////////////////////////////////////
/** @file
    Sets up adding and removing OnHit: CastSpell
    - Unique Power to weapons equipped by the feat
    possessor. This is done by the script adding
    itself via the eventhook to OnPlayerEquipItem
    and OnPlayerUnEquipItem events.

    The script also adds itself to be run during
    OnHit event, where it will deal the lingering
    sneak attack damage.


    Should Lingering Damage apply to unarmed strike, too ?
    Also, should there be some text notification when
    the damage is dealt, like with PerformAttackRound?
     - Ornedan
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_combat"

void main()
{
    object oItem;
    int nEvent = GetRunningEvent();

    if(DEBUG) DoDebug("ft_lingdmg running, event: " + IntToString(nEvent));

    // We aren't being called from any event, instead from EvalPRCFeats, so set up the eventhooks
    /*if(nEvent == FALSE)
    {
        oPC = OBJECT_SELF;
        if(DEBUG) DoDebug("ft_lingdmg: Adding eventhooks");

        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM, "ft_lingdmg", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "ft_lingdmg", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONHIT, "ft_lingdmg", TRUE, FALSE);
    }
    // We're being called from the OnHit eventhook, so deal the damage
    else */if(nEvent == EVENT_ONHIT)
    {
        object oPC = OBJECT_SELF;
        oItem = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("ft_lingdmg: OnHit:\n"
                        + "oPC = " + DebugObject2Str(OBJECT_SELF) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );
        // only run if called by a weapon
        int iDamType  = GetWeaponDamageType(oItem);
        if(oTarget != OBJECT_SELF && iDamType != -1)
        {
            if(GetCanSneakAttack(oTarget, oPC))
            {
                int iDam      = d6(GetTotalSneakAttackDice(oPC));
                int iDamPower = GetDamagePowerConstant(oItem, oTarget, oPC);
                if(DEBUG) DoDebug("Lingering Damage - iDam: " + IntToString(iDam) + "; iDamType: " + IntToString(iDamType) + "; iDamPower: " + IntToString(iDamPower));
                effect eDam = EffectDamage(iDam, iDamType, iDamPower);
                DelayCommand(RoundsToSeconds(1), ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget) );
            }
        }
    }
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        if(DEBUG) DoDebug("ft_lingdmg - OnEquip");
        oItem = GetItemLastEquipped();
        if(GetIsWeapon(oItem))
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        if(DEBUG) DoDebug("ft_lingdmg - OnUnequip");
        oItem = GetItemLastUnequipped();
        if(GetIsWeapon(oItem))
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);
    }
}