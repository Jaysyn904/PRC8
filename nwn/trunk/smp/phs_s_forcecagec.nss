/*:://////////////////////////////////////////////
//:: Spell Name Forcecage: On Heartbeat
//:: Spell FileName PHS_S_ForcecageC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Needs 4 placeables for the bars, and an AOE within the centre of it. If
    any of the bars are destroyed (via. disintegration ETC), it means the entire
    spell collapses.

    The AOE is plotted too, and does the correct 50% vs ranged attack consealment
    as they will have to shoot through the bars.

    On Heartbeat:

    - Round 1. We set the placeables used as walls from the caster to us, and set us to plot.
    - First 2 rounds: If there is no one in the area in the first 2 rounds, it will collapse
    - Every round: If any of the 4 walls are destroyed by magic, it will collapse.

    -Collapsing-
    - Destroys any of the walls left
    - Destroys ourselves
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Destroys self, and any remaining barriers.
void Collapse(object oSelf, string sSetup);

void main()
{
    // Setup variables
    object oCaster = GetAreaOfEffectCreator();
    object oSelf = OBJECT_SELF;
    // We always start nRoundsDone on 1, so the first heartbeat this is 1.
    int nRoundsDone = PHS_IncreaseStoredInteger(oSelf, "PHS_FORCECAGE_SETUP");
    string sSetup = "PHS_FORCEWALL_WALL";
    string sTotal;
    object oObject;
    int nCnt;
    if(nRoundsDone == 1)
    {
        for(nCnt = 1; nCnt <= 4; nCnt++)
        {
            sTotal = sSetup + IntToString(nCnt);
            // Set it from the casters variable
            SetLocalObject(oSelf, sTotal, GetLocalObject(oCaster, sTotal));
            // Delete it from the caster
            DeleteLocalObject(oCaster, sTotal);
        }
    }

    // Check AOE creator, check the 4 forcewalls, check if anyone is in the AOE.
    if(!GetIsObjectValid(oCaster))
    {
        // Go
        Collapse(oSelf, sSetup);
        return;
    }
    // Check if we are in the first or second round
    if(nRoundsDone <= 2)
    {
        // Check validity of objects in the AOE
        oObject = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
        if(!GetIsObjectValid(oObject))
        {
            // Go
            Collapse(oSelf, sSetup);
            return;
        }
    }

    // Check the 4 walls are still there
    for(nCnt = 1; nCnt <= 4; nCnt++)
    {
        sTotal = sSetup + IntToString(nCnt);
        // Get the wall at the position
        oObject = GetLocalObject(oSelf, sTotal);

        if(!GetIsObjectValid(oObject))
        {
            // Go
            Collapse(oSelf, sSetup);
            return;
        }
    }
}

// Destroys self, and any remaining barriers.
void Collapse(object oSelf, string sSetup)
{
    string sTotal;
    object oObject;
    int nCnt;
    // Check the 4 walls and destroy any left.
    for(nCnt = 1; nCnt <= 4; nCnt++)
    {
        sTotal = sSetup + IntToString(nCnt);
        // Get the wall at the position
        oObject = GetLocalObject(oSelf, sTotal);

        if(GetIsObjectValid(oObject))
        {
            // Destory it
            SetPlotFlag(oObject, FALSE);
            DestroyObject(oObject);
        }
    }

    // Set our plot flag to false and go ourselves
    SetPlotFlag(oSelf, FALSE);
    DestroyObject(oSelf);
}
