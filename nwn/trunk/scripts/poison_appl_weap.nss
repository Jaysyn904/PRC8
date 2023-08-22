//::///////////////////////////////////////////////
//:: Poison Weapon spellscript
//:: poison_appl_weap
//::///////////////////////////////////////////////
/** @file
    Applies a poison to the targeted weapon based on
    local integer "pois_idx" on the item being cast from.
    The last 3 letters of the item's tag will be used instead
    if the following module switch is set:

    PRC_USE_TAGBASED_INDEX_FOR_POISON


    The item will have a permanent OnHitCastSpell applied
    to it with spell Poisoned Weapon.
    2 local integers "pois_wpn_idx" and "pois_wpn_uses" will also
    be set on the item. Description of their roles is found
    in poison_wpn_onhit.nss


    The system uses the following module switches:

    PRC_ALLOW_ONLY_SHARP_WEAPONS
    - If this is nonzero, only weapons that do slashing or piercing
      damage are allowed to be poisoned.
    - Default: All weapons can be poisoned.

    PRC_ALLOW_ALL_POISONS_ON_WEAPONS
    - If this is nonzero, inhaled and ingest poisons may be
      placed on weapons in addition to contact and injury.
    - Default: Only contact and injury poisons are allowed on weapons.

    PRC_USE_DEXBASED_WEAPON_POISONING_FAILURE_CHANCE
    - If this is nonzero, a DEX check is rolled against Handle_DC
      in the poison's column in poison.2da.
    - Possessing the Use Poison feat will always pass this check.
    - Default: A static 5% failure chance is used, as per the DMG.


    The following switches determine the amount of uses (successfull hits)
    that can be made with the weapon before the poison wears off.
    These may be overridden with similarly named variables on the item
    used to poison the weapon.
    If the die value is not present (or less than 2), the amount of uses
    will be equal to PRC_USES_PER_POISON_COUNT.
    There will always be at least one use.

    PRC_USES_PER_WEAPON_POISON_COUNT
    - Number of uses or dice for uses of the poisoned weapon.
    - Values less than 1 will be treated as 1.

    PRC_USES_PER_WEAPON_POISON_DIE
    - Size of dice used to determine number of uses. Any number
      greater than 1 works.
    - Values less than 2 on the module switch will disable the die roll.
      Overridden by value defined by the item.
    - Similarly for the override if it is defined. (0 in override counts
      as not defined)


*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 20.12.2004
//:: Updated On: 09.01.2005
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_poison"


void main()
{
    //SpawnScriptDebugger();
    object oItem   = GetSpellCastItem();
    object oPC     = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();


    // Make sure the target is an item
    if (oTarget == OBJECT_INVALID || GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
    {
        SendMessageToPCByStrRef(oPC, 83359);         //"Invalid target "
        return;
    }

    // Make sure it's a weapon
    int nType = GetBaseItemType(oTarget);
    if (!IPGetIsMeleeWeapon(oTarget) &&
        !IPGetIsProjectile(oTarget)  &&
        nType != BASE_ITEM_SHURIKEN  &&
        nType != BASE_ITEM_DART      &&
        nType != BASE_ITEM_THROWINGAXE)
    {
        SendMessageToPCByStrRef(oPC, 83359);         //"Invalid target "
        return;
    }

    // Make sure the weapon can be applied poison to
    if(GetPRCSwitch(PRC_ALLOW_ONLY_SHARP_WEAPONS) &&
       IPGetIsBludgeoningWeapon(oTarget))
    {
        SendMessageToPCByStrRef(oPC, 83367);         //"Weapon does not do slashing or piercing damage "
        return;
    }


    // Get the 2da row to lookup the poison from
    int nRow;
    if(GetPRCSwitch(PRC_USE_TAGBASED_INDEX_FOR_POISON))
        nRow = StringToInt(GetStringRight(GetTag(oItem), 3));
    else
        nRow = GetLocalInt(oItem, "pois_idx");

    // Some paranoia re. valid values
    if (nRow < 0)
    {
        SendMessageToPCByStrRef(oPC, 83360);         //"Nothing happens
        WriteTimestampedLogEntry ("Error: Item with resref " +GetResRef(oItem)+ ", tag " +GetTag(oItem) + " has the PoisonWeapon spellscript attached but "
                                   + (GetPRCSwitch(PRC_USE_TAGBASED_INDEX_FOR_POISON) ? "it's tag" : "it's local integer variable 'pois_idx'")
                                   + " contains an invalid value!");
        return;
    }

    // Make sure the poison can be applied to a weapon
    if(GetPoisonType(nRow) != POISON_TYPE_CONTACT &&
       GetPoisonType(nRow) != POISON_TYPE_INJURY  &&
       !GetPRCSwitch(PRC_ALLOW_ALL_POISONS_ON_WEAPONS))
    {
        SendMessageToPCByStrRef(oPC, STRREF_POISON_NOT_VALID_FOR_WEAPON);
        return;
    }

    /* If weapon is already poisoned, remove the previous. This is to avoid possible
     * complications from having several identical itemproperties.
     */
    if(GetLocalInt(oTarget, "pois_wpn_uses") != 0){
        DoPoisonRemovalFromWeapon(oTarget);
        SendMessageToPCByStrRef(oPC, STRREF_POISON_CLEAN_OFF_WEAPON);
    }


    /** Done with the paranoia, now to start applying the poison **/


    // People with Use Poison feat succeed automatically, others roll for success
    if(!GetHasFeat(FEAT_USE_POISON, oPC))
    {
        // * Force attacks of opportunity
        AssignCommand(oPC, ClearAllActions(TRUE));

        // Check for failure.
        int nFail;
        if(GetPRCSwitch(PRC_DEXBASED_WEAPON_POISONING_FAILURE_CHANCE))
        {
            int nApplyDC = StringToInt(Get2DACache("poison", "Handle_DC", nRow));
            int nDex = GetAbilityModifier(ABILITY_DEXTERITY,oPC) ;
            int nCheck = d10(1)+10+nDex;
            nFail = (nCheck < nApplyDC);
        }
        else
        {
            nFail = (d100() <= 5);
        }

        // Inform user of success / failure and deal failure effects if needed
        if(nFail)
        {
            SendMessageToPCByStrRef(oPC, STRREF_POISON_APPLY_FAILURE); //"You slip while applying the poison to your weapon."

            // User gets poisoned on failure
            effect ePoison = EffectPoison(nRow);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oPC);

        }
    }// end if - handle people without Use Poison feat

    //Add the effect and local ints for the hit script
    itemproperty ip = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1);

    // First, check if something else adds the unique onhit.
    // If nothing does, then we should remove it once the effect has been used up
    if(!IPGetItemHasProperty(oTarget, ip, -1))
        SetLocalInt(oTarget, "PoisonedWeapon_DoDelete", TRUE);

    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oTarget);
    SetLocalInt(oTarget, "pois_wpn_idx", nRow);

    int nUses = 0;
    int nDie = GetLocalInt(oItem, PRC_USES_PER_WEAPON_POISON_DIE);
        nDie = nDie ? nDie : GetPRCSwitch(PRC_USES_PER_WEAPON_POISON_DIE);
    int nCount = GetLocalInt(oItem, PRC_USES_PER_WEAPON_POISON_COUNT);
        nCount = nCount > 0 ? nCount : GetPRCSwitch(PRC_USES_PER_WEAPON_POISON_COUNT);
        nCount = nCount > 0 ? nCount : 1;
    if(nDie >= 2){
        int i;
        for(i = 0; i < nCount; i++){
            nUses += Random(nDie) + 1;
        }
    }
    else{
        nUses = nCount;
    }
    SetLocalInt(oTarget, "pois_wpn_uses", nUses);

    // Eventhook the weapon
    AddEventScript(oTarget, EVENT_ITEM_ONHIT, "poison_wpn_onhit", TRUE, FALSE);

    // Inform player and do VFX
    SendMessageToPC(oPC,
                    GetStringByStrRef(STRREF_POISON_APPLY_SUCCESS) + " " +
                    GetStringByStrRef(StringToInt(Get2DACache("poison", "Name", nRow)))
                   );  //"You coat your weapon with xxxx"

    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));

}