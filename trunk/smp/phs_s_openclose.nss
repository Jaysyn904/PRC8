/*:://////////////////////////////////////////////
//:: Spell Name Open/Close
//:: Spell FileName PHS_S_OpenClose
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Range: Close (8M)
    Target: Door or portal weighing up to 30 lb. that can be opened/closed
    Duration: Instantaneous
    Saving Throw: Will negates (object)
    Spell Resistance: Yes (object)

    You can open or close (depending if it is already open or close) a door. If
    anything resists this activity (such as a bar or a lock), the spell fails.
    In addition, the spell can only open and close things weighing 30 pounds or
    less. Thus, doors sized for enormous creatures may be beyond this spell’s
    ability to affect.

    Note: In NwN, this spell can only affect doors set to be able to be affected.
    By default, this will fail. A will save also negates this spell.

    Focus: A brass key.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This requires the object to:

    - Be a door (placables cannot be opened from afar, its hardcoded)
    - Not be plot
    - Not be locked
    - Have the variable "Can be Opened or Closed" set, so that big
      doors/immune things are accounted for.

    Does do a spell resistance and will save check.

    And just AssignCommand(Open) on it :-)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_OPEN_CLOSE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nObjectType = GetObjectType(oTarget);
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    // Variables for the checks
    int bLock = GetLocked(oTarget);
    int bPlot = GetPlotFlag(oTarget);

    // Declare effects
    effect eVis = EffectVisualEffect(SPELL_KNOCK);

    // Checks
    if(nObjectType == OBJECT_TYPE_DOOR)
    {
        // Second checks
        if(bLock == FALSE && bPlot == FALSE &&
           GetLocalInt(oTarget, PHS_CONST_CAN_BE_MAGICALLY_OPENED) == TRUE)
        {
            // Check spell immunity (you never know what effects these things
            // might have...)
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Will save - Placeables can have will saves, of course.
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC))
                {
                    // Effects and assign command - open or close
                    PHS_ApplyVFX(oTarget, eVis);

                    // Open or close it!
                    if(GetIsOpen(oTarget))
                    {
                        AssignCommand(oTarget, ActionCloseDoor(oTarget));
                    }
                    else
                    {
                        AssignCommand(oTarget, ActionOpenDoor(oTarget));
                    }
                }
            }
        }
    }
}
