//::///////////////////////////////////////////////
//:: Poison Item spellscript
//:: poison_appl_item
//::///////////////////////////////////////////////
/** @file
    Applies a poison to the targeted item based on
    local integer "pois_idx" on the item being cast from.
    The last 3 characters of the item's tag will be used
    instead if the following module switch is set:

    PRC_USE_TAGBASED_INDEX_FOR_POISON


    The last 3 digits of the tag are used as a reference
    to poison.2da. Any non-contact poison will have no
    effect. An already poisoned item cannot be poisoned again
    before being cleaned.

    The item will have 3 local integers applied to it:
      pois_itm_idx       - The number of poison to use. A line
                           in poison.2da
      pois_itm_uses      - The number of times this item can
                           poison a target before the poison
                           wearing off
      pois_itm_trap_dc   - The DC Spot and Disable Trap checks will
                           be made against.
                           d20 + poisoner's Set Trap

    A local object marking the poisoner will also be added.
      pois_itm_poisoner  - The PC who poisoned the item


    If the poisoned item is equipped, the equipper will
    always be effected by the poison.

    If the poisoned item is acquired, any others than the
    poisoner will have to make a Spot check versus
    poisoner's Set Trap. On a successfull check, they
    notice the poison on the item and pick it up without touching
    the poison.

    The item will have a Cast Spell: Clean Poison Off itemproperty
    given to it. Using this is safe for the poisoner, others
    must roll Disable Traps versus Set Trap.
    Failure results in poisoning.
    Both success and failure remove the poison from the item.


    The following switches determine the amount of times the poisoned
    item will affect targets.
    These may be overridden with similarly named variables on the item
    used to poison the item.
    If the die value is not present (or less than 2), the amount of uses
    will be equal to PRC_USES_PER_POISON_COUNT.
    There will always be at least one use.

    PRC_USES_PER_ITEM_POISON_COUNT
    - Number of uses or dice for times the poisoned item will
      take effect.
    - Values less than 1 will be treated as 1.

    PRC_USES_PER_ITEM_POISON_DIE
    - Size of dice used to determine number of uses. Any number
      greater than 1 works.
    - Values less than 2 on the module switch will disable the die roll.
      Overridden by value defined by the item.
    - Similarly for the override if it is defined. (0 in override counts
      as not defined)

*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 09.01.2005
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_poison"


void main()
{
    object oItem   = GetSpellCastItem();
    object oPC     = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    // Make sure the target is an item
    if (oTarget == OBJECT_INVALID || GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
    {
        SendMessageToPCByStrRef(oPC, STRREF_INVALID_TARGET);         // * Target is not an item *
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
        WriteTimestampedLogEntry ("Error: Item with resref " +GetResRef(oItem)+ ", tag " +GetTag(oItem) + " has the PoisonItem spellscript attached but "
                                   + (GetPRCSwitch(PRC_USE_TAGBASED_INDEX_FOR_POISON) ? "it's tag" : "it's local integer variable 'pois_idx'")
                                   + " contains an invalid value!");
        return;
    }

    // Make sure the poison is a contact poison
    if(GetPoisonType(nRow) != POISON_TYPE_CONTACT)
    {
        SendMessageToPCByStrRef(oPC, STRREF_NOT_CONTACT_POISON);
        return;
    }

    /* If item is already poisoned, inform user and stop. */
    if(GetLocalInt(oTarget, "pois_itm_uses") != 0)
    {
        SendMessageToPCByStrRef(oPC, STRREF_TARGET_ALREADY_POISONED);
        return;
    }

    /** Done with the paranoia, now to start applying the poison **/

    // * Force attacks of opportunity
    AssignCommand(oPC, ClearAllActions(TRUE));

    int nDC = d20() + GetSkillRank(SKILL_SET_TRAP, oPC);
    itemproperty ip = ItemPropertyCastSpell(IP_CONST_CASTSPELL_CLEAN_POISON_OFF, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);

    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oTarget);
    SetLocalObject(oTarget, "pois_itm_poisoner", oPC);
    SetLocalInt(oTarget, "pois_itm_idx", nRow);
    SetLocalInt(oTarget, "pois_itm_trap_dc", nDC);

    int nUses = 0;
    int nDie = GetLocalInt(oItem, PRC_USES_PER_ITEM_POISON_DIE);
        nDie = nDie ? nDie : GetPRCSwitch(PRC_USES_PER_ITEM_POISON_DIE);
    int nCount = GetLocalInt(oItem, PRC_USES_PER_ITEM_POISON_COUNT);
        nCount = nCount > 0 ? nCount : GetPRCSwitch(PRC_USES_PER_ITEM_POISON_COUNT);
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
    SetLocalInt(oTarget, "pois_itm_uses", nUses);

    // Eventhook the item
    AddEventScript(oTarget, EVENT_ITEM_ONACQUIREITEM, "poison_onaquire", TRUE, FALSE);
    AddEventScript(oTarget, EVENT_ITEM_ONPLAYEREQUIPITEM, "poison_onequip", TRUE, FALSE);

    // Inform player
    SendMessageToPC(oPC,
                    GetStringByStrRef(STRREF_POISON_ITEM_USE_1) + " " +
                    GetStringByStrRef(StringToInt(Get2DACache("poison", "Name", nRow))) + " " +
                    GetStringByStrRef(STRREF_POISON_ITEM_USE_2) + " " +
                    GetName(oTarget) + "."
                   );  //"You smear xxxx all over yyyy"
}