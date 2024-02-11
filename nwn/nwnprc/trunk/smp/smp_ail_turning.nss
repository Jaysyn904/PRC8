/*:://////////////////////////////////////////////
//:: Name Turning Heartbeat
//:: FileName SMP_ail_turning
//:://////////////////////////////////////////////
    This runs on an creature with the effect EffectTurned().

    Effect and Duration of Turning: Turned undead flee from you by the best and
    fastest means available to them. They flee for 10 rounds (1 minute). If they
    cannot flee, they cower (giving any attack rolls against them a +2 bonus).
    If you approach within 10 feet of them, however, they overcome being turned
    and act normally. (You can stand within 10 feet without breaking the turning
    effect-you just can’t approach them.)

    Ok, in NwN:

    Effect and Duration of Turning: Turned undead flee from you by the best and
    fastest means available to them. They flee for 10 rounds (1 minute). If they
    cannot flee, they cower, having -2 AC. If you approach within 10 feet of them,
    however, they overcome being turned and act normally. You can attack them
    with ranged attacks, and others can attack them in any fashion.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_AILMENT"
//#include "SMP_INC_SPELLS"

// Get the nearest valid creator of fear in the area.
// Checks for turning. No checks for seen/heard - its clerical abilties, so
// the cleric forces them away.
object GetNearestPersonWhoCreatedFear(object oSelf);

void main()
{
    // Declare us
    object oSelf = OBJECT_SELF;

    // Get the nearest person who turned us
    object oTurner = GetNearestPersonWhoCreatedFear(oSelf);

    // Are they valid?
    if(GetIsObjectValid(oTurner))
    {
        // If they are within 10ft, we will remove all turning from that creator
        if(GetDistanceToObject(oTurner) <= RADIUS_SIZE_FEET_10)
        {
            // If nearby, we remove turning
            SetCommandable(TRUE);
            SMP_RemoveSpecificEffect(EFFECT_TYPE_TURNED, oSelf);

        }
        else
        {
            //Allow the target to recieve commands for the round
            SetCommandable(TRUE);

            // Flee from the turner - run if possible
            ClearAllActions();
            ActionMoveAwayFromObject(oTurner, TRUE, 60.0);

            //Disable the ability to recieve commands.
            SetCommandable(FALSE);
        }
    }
    else
    {
        // If not valid, we remove turning
        SetCommandable(TRUE);
        SMP_RemoveSpecificEffect(EFFECT_TYPE_TURNED, oSelf);
    }

}

// Get the nearest valid creator of fear in the area.
object GetNearestPersonWhoCreatedFear(object oSelf)
{
    // Get fear creators
    effect eCheck = GetFirstEffect(oSelf);
    object oCreator, oFearReturn;
    object oArea = GetArea(oSelf);
    float fLowestDistance = 300.0;
    float fDistance;
    // Loop effects
    while(GetIsEffectValid(eCheck))
    {
        // Check for creators of fear
        if(GetEffectType(eCheck) == EFFECT_TYPE_FRIGHTENED)
        {
            // Get the creator
            oCreator = GetEffectCreator(eCheck);
            // Check if valid, and same area, but no seen/heard check
            if(GetIsObjectValid(oCreator) && GetArea(oCreator) == oArea &&
               GetObjectType(oCreator) == OBJECT_TYPE_CREATURE)
            {
                // Get distance to them
                fDistance = GetDistanceBetween(oCreator, oSelf);
                if(fDistance < fLowestDistance)
                {
                    // Now this is the one we fear most
                    oFearReturn = oCreator;
                    fLowestDistance = fDistance;
                }
            }
        }
    }
    return oFearReturn;
}
