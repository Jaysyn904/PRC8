/*:://////////////////////////////////////////////
//:: Spell Name Refuge - On Activated
//:: Spell FileName PHS_S_RefugeA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Can be cast on any item.

    Once the item has the spell, it has the caster's name set on it. Only PCs
    can cast this spell.

    Once used, the item power set (permamently) on the thing that is, it will
    transport the PC to the caster, or, Vice Versa.

    Cannot be dispelled, for easyness sakes, and needs a material component.

    It was also "to the casters Abode", but heck, that'd be so much more complicated
    and unfun.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Get the PC of sName - noting sName must be GetPCPlayerName(oCaster) + GetName(oCaster)
object GetPCOfName(string sName);

void main()
{
    //Declare major variables
    object oPerson = OBJECT_SELF;
    object oItem = GetSpellCastItem();
    // Get the caster of the spell
    object oCaster = GetPCOfName(GetLocalString(oItem, "PHS_REFUGE_CASTER_NAME"));
    // Get the boolean value
    // If TRUE, the caster is teleported to the target, so
    // it defaults to FALSE, which means the person using it (the target) is
    // teleported to the caster.
    // * It is kinda a "Move the caster to the target?" question for the name reference.
    int bMoveCaster = GetLocalInt(oItem, "PHS_SPELL_REFUGE_MOVE_CASTER");

    // Make sure they are a valid caster - else wasted spell
    if(!GetIsObjectValid(oCaster) || oCaster == oPerson)
    {
        // Failed
        FloatingTextStringOnCreature("*Refuge attempt failed, no caster of Refuge found*", oPerson, FALSE);
        // Make sure always to destroy the item
        PHS_CompletelyDestroyObject(oItem);
        return;
    }

    // Check faction alignment
    if(!GetFactionEqual(oCaster, oPerson))
    {
        // Failed
        FloatingTextStringOnCreature("*Refuge attempt failed, caster of Refuge not in party*", oPerson, FALSE);
        // Make sure always to destroy the item
        PHS_CompletelyDestroyObject(oItem);
        return;
    }

    // Get locations
    location lPerson = GetLocation(oPerson);
    location lCaster = GetLocation(oCaster);

    // Must be on the same plane - no going from maze or to prismatic plane :-)
    if(PHS_CheckIfSamePlane(lPerson, lCaster))
    {
        // Failed
        FloatingTextStringOnCreature("*Refuge attempt failed, caster of Refuge not on the same plane*", oPerson, FALSE);
        // Make sure always to destroy the item
        PHS_CompletelyDestroyObject(oItem);
        return;
    }

    // If not, we work the magic
    if(bMoveCaster == TRUE)
    {
        // oCaster to oPerson
        AssignCommand(oCaster, PHS_ForceMovementToLocation(PHS_GetRandomLocation(lPerson, 6), VFX_FNF_TELEPORT_OUT, VFX_FNF_TELEPORT_IN));
    }
    else
    {
        // oPerson to oCaster
        AssignCommand(oPerson, PHS_ForceMovementToLocation(PHS_GetRandomLocation(lCaster, 6), VFX_FNF_TELEPORT_OUT, VFX_FNF_TELEPORT_IN));
    }

    // Make sure always to destroy the item
    PHS_CompletelyDestroyObject(oItem);
}

// Get the PC of sName - nothing sName must be GetPCPlayerName(oCaster) + GetName(oCaster)
object GetPCOfName(string sName)
{
    object oPC = GetFirstPC();
    while(GetIsObjectValid(oPC))
    {
        // Check name
        if(GetPCPlayerName(oPC) + GetName(oPC) == sName)
        {
            return oPC;
        }
        // Get next PC
        oPC = GetNextPC();
    }
    return OBJECT_INVALID;
}
