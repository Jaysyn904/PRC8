/*:://////////////////////////////////////////////
//:: Name Trap Disarm
//:: FileName PHS_OT_Trapdisar
//:://////////////////////////////////////////////
//:: Notes
//:://////////////////////////////////////////////
    When activated (When they know about a magical trap in the area) a rogue
    or anyone can use this power on an item to diarm the trap from the perimeter.

    They have a local int set on any AOE's (the magical traps) which are
    detected by the PC.

    Explosive runes and the like are detected if the item targeted has it, and
    it is sucessfully detected. It will be disarmed if they detect it.

    Item description:

    Rogue only.

    Use this tool on yourself to disarm magical traps you know about in the area
    such as Symbol: Death. It requires you to be aware the magical trap is there
    (visible runes and magical traps you always know about) and have a sucessful
    Disarm Trap check against 25 + Spell level.

    If you target an item, you check to see if has any Explosive Runes or similar
    spells on it, and attempt to disarm them if it does. Once you know it has
    Explosive runes upon it, use the tool again to disarm them, or attempt to.
    The DC for this is also 25 + Spell level.

    If you ever fail a Disarm Trap check and get a 1, you trigger the runes or
    magical trap, and it goes off instantly as if you were the triggerer.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Disarm oTrap with special checks. Must be in fDistance meters to do so.
void ActionDisarmTheMagicTrap(object oTrap, float fDistance = 8.0, object oDisarmer = OBJECT_SELF);

void main()
{
    // Declare major variables
    object oSelf = OBJECT_SELF;
    object oDisarm;
    string sName = GetName(oSelf);
    int nCnt = 1;

    // Only PC's can disarm magical traps. No faries ETC
    if(!GetIsPC(oSelf)) return;

    // Only a rogue can use this
    if(!GetLevelByClass(CLASS_TYPE_ROGUE, oSelf)) return;

    // See if we know of any traps nearby. Loop until we find on in 20M
    object oAOE = GetNearestObject(OBJECT_TYPE_AREA_OF_EFFECT, oSelf, nCnt);
    while(GetIsObjectValid(oAOE) && GetDistanceToObject(oAOE) <= 20.0)
    {
        // Check if detected. PC's should have unique names.
        if((GetLocalInt(oAOE, PHS_MAGICAL_TRAP_DETECTED_BY + sName) == TRUE ||
            GetLocalInt(oAOE, PHS_MAGICAL_TRAP_ALWAYS_DETECTED) == TRUE) &&
            GetLocalInt(oAOE, PHS_MAGICAL_TRAP_LEVEL) >= 1)
        {
            // Stop
            oDisarm = oAOE;
            break;
        }
        // Get next one
        nCnt++;
        oAOE = GetNearestObject(OBJECT_TYPE_AREA_OF_EFFECT, oSelf, nCnt);
    }

    // Is oDiarm valid?
    if(GetIsObjectValid(oDisarm))
    {
        // The DC in each case is 25 + spell level, (EG: 31 for symbol of fear).
        SendMessageToPC(oSelf, "You have detected a magical trap, so you plan on disarming it");

        // Get the DC of the disarm check


    }
    else
    {

    }
}

// Disarm oTrap with special checks. Must be in fDistance meters to do so.
void ActionDisarmTheMagicTrap(object oTrap, float fDistance = 8.0, object oDisarmer = OBJECT_SELF)
{
    // Make sure we are fDistance or nearer
    if(GetDistanceToObject(oTrap) <= fDistance)
    {
        // Get DC and do a check
        int nDC = GetLocalInt(oTrap, PHS_MAGICAL_TRAP_LEVEL);
        if(GetIsSkillSuccessful(oDisarmer, SKILL_DISABLE_TRAP, nDC))
        {
            SendMessageToPC(oDisarmer, "PASS: You disable the magical trap with your tools.");
            DestroyObject(oTrap);
        }
        else if(d20() == 1)
        {
            // Trap goes off!
            SendMessageToPC(oDisarmer, "FAIL: You fail to disable the magical trap, and it goes off!");

        }
        else
        {
            // Fail to disable it but no trap goes off
            SendMessageToPC(oDisarmer, "FAIL: You fail to disable the magical trap with your tools.");
        }
    }
    else
    {
        FloatingTextStringOnCreature("You are too far away from the magical trap to disarm it", oDisarmer);
    }
}
