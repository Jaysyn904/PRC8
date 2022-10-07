/*:://////////////////////////////////////////////
//:: Spell Name Deathwatch
//:: Spell FileName PHS_S_Deathwatch
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    30ft range (10M), Instant duration. Cone-shaped emanation.

    Using the foul sight granted by the powers of unlife, you can determine the
    condition of creatures near death within the spell’s range. You instantly
    know whether each creature within the area is dead, fragile (alive and
    wounded, with 3 or fewer hit points left), fighting off death (alive with 4
    or more hit points), undead, or neither alive nor dead (such as a construct).

    Deathwatch sees through any spell or ability that allows creatures to feign
    death.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    I think the duration part can be removed.

    As above:
    dead <= -10
    fragile <= 3
    fighting off death >= 4
    undead = undead
    construct = construct
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_DEATHWATCH)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    float fDelay;
    string sString;
    int nHP;

    // Get the first target in the area - 30ft, 10M range.
    object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        // Start string as name
        sString = GetName(oTarget);
        // Determine race
        switch(GetRacialType(oTarget))
        {
            // Undead
            case RACIAL_TYPE_UNDEAD:
            {
                // Add on: " is an undead creature"
                sString += " is an undead creature.";
            }
            break;

            // Constructs
            case RACIAL_TYPE_CONSTRUCT:
            {
                // Add on: " is an construct"
                sString += " is an construct.";
            }
            break;

            // Anything else
            default:
            {
                // 3 states: "dead, dying, not dead"
                nHP = GetCurrentHitPoints(oTarget);
                // Dead: Must be actually dead (not dying!)
                if(nHP <= -10)
                {
                    sString += " is a dead creature.";
                }
                // Fragile - 3 or less, but not dead, can be dying.
                else if(nHP <= 3)
                {
                    sString += " is a fragile creature.";
                }
                // fighting off death - everything else, oddly enough.
                else
                {
                    sString += " is a creature fighting off death.";
                }
            }
            break;
        }
        // Get delay - quite a big one.
        fDelay = GetDistanceToObject(oTarget)/2.0;
        // Send message to PC based on range.
        DelayCommand(fDelay, SendMessageToPC(oCaster, "[Deathwatch] " + GetName(oTarget) + " is " + sString));

        // Get next target
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, TRUE);
    }
}
