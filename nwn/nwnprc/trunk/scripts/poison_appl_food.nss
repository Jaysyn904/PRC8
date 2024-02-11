//::///////////////////////////////////////////////
//:: Poison Food spellscript
//:: poison_appl_food
//::///////////////////////////////////////////////
/** @file
    Applies a poison to the targeted food item based on
    local integer "pois_idx" on the item being cast from.
    The last 3 letters of the item's tag will be used instead
    if the following module switch is set:

    PRC_USE_TAGBASED_INDEX_FOR_POISON


    Any non-contact poison will have no effect. An already
    poisoned food cannot be poisoned again.

    Whether an object is food or not is determined by
    executing a script called "poison_is_food".
    This script is not present in it's compiled form in
    the hak, so you can compile it in your module without
    having to take it out of the hak.
    You need to add your own checks into that script, as
    by default it only returns false.


    The item will have a 2 local integers applied to it:
      pois_food_idx       - The number of poison to use. A line
                            in poison.2da
      pois_food           - Set to TRUE. Because idx can have 0
                            as it's value, this is needed for
                            absolute certainty about whether the
                            food is poisoned.


    For the poisoned food to have any effect, you will have to
    hook "poison_eat_hook" into wherever you handle eating & drinking
    in your module. The hook checks for presence of poison on the food
    item, so you needn't add such check to your own script.

    Add the following lines to such script(s):
    SetLocalObject(GetModule(), "poison_eat_hook_item", oFood);
    ExecuteScript("poison_eat_hook", oEater);
    DeleteLocalObject(GetModule(), "poison_eat_hook_item");


      oFood   - Whichever item was eaten or drunk. This should hold
                the pois_food and pois_food_idx locals.
      oEater  - Whomever does the eating. This is the target to be poisoned.

*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 10.01.2005
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

    // Make sure the target is some type of food or drink
    // Get the name of the script to run from a switch. If it's not present, use default
    string sIsFoodScriptName = GetLocalString(GetModule(), PRC_POISON_IS_FOOD_SCRIPT_NAME);
    if(sIsFoodScriptName == "") sIsFoodScriptName = "poison_is_food";
    // Run it
    if(!ExecuteScriptAndReturnInt(sIsFoodScriptName, oTarget))
    {
        SendMessageToPCByStrRef(oPC, STRREF_TARGET_NOT_FOOD);       // "Target is not food."
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
        WriteTimestampedLogEntry ("Error: Item with resref " +GetResRef(oItem)+ ", tag " +GetTag(oItem) + " has the PoisonFood spellscript attached but "
                                   + (GetPRCSwitch(PRC_USE_TAGBASED_INDEX_FOR_POISON) ? "it's tag" : "it's local integer variable 'pois_idx'")
                                   + " contains an invalid value!");
        return;
    }

    // Make sure the poison is a contact poison
    if(GetPoisonType(nRow) != POISON_TYPE_INGESTED)
    {
        SendMessageToPCByStrRef(oPC, STRREF_NOT_INGESTED_POISON);
        return;
    }

    /* If item is already poisoned, inform user and stop. */
    if(GetLocalInt(oTarget, "pois_food"))
    {
        SendMessageToPCByStrRef(oPC, STRREF_TARGET_ALREADY_POISONED);
        return;
    }

    /** Done with the paranoia, now to start applying the poison **/

    // * Force attacks of opportunity
    AssignCommand(oPC, ClearAllActions(TRUE));

    SetLocalInt(oTarget, "pois_itm_idx", nRow);
    SetLocalInt(oTarget, "pois_food", TRUE);

    // Inform player
    SendMessageToPC(oPC,
                    GetStringByStrRef(STRREF_POISON_FOOD_USE_1) + " " +
                    GetStringByStrRef(StringToInt(Get2DACache("poison", "Name", nRow))) + " " +
                    GetStringByStrRef(STRREF_POISON_FOOD_USE_2) + " " +
                    GetName(oTarget) + "."
                   );  //"You put some xxxx into yyyy"
}