/*:://////////////////////////////////////////////
//:: Name Fear Heartbeat
//:: FileName SMP_ail_fear
//:://////////////////////////////////////////////
    This is the fear heartbeat, for PCs and NPCs, who have this effect on them:

    // Create a Frighten effect
    effect EffectFrightened()

    Ok, lowdown:
    - Fear can be applied multiple times from multiple spells
    - It stops all movement dispite any SetCommandable's. Might work after a
      short delay somehow.
    - Can be commandable after the fear, whatever happens.

    Description:

Shaken: A shaken character takes a -2 penalty on attack rolls, saving throws, skill
    checks, and ability checks.
    Shaken is a less severe state of fear than frightened or panicked.

Frightened: A frightened creature flees from the source of its fear as best it can.
    If unable to flee, it may fight. A frightened creature takes a -2 penalty on all
    attack rolls, saving throws, skill checks, and ability checks. A frightened
    creature can use special abilities, including spells, to flee; indeed, the
    creature must use such means if they are the only way to escape.
    Frightened is like shaken, except that the creature must flee if possible.
    Panicked is a more extreme state of fear.

Panicked: A panicked creature must drop anything it holds and flee at top speed
    from the source of its fear, as well as any other dangers it encounters, along
    a random path. It can’t take any other actions. In addition, the creature takes
    a -2 penalty on all saving throws, skill checks, and ability checks. If cornered,
    a panicked creature cowers and does not attack, typically using the total
    defense action in combat. A panicked creature can use special abilities,
    including spells, to flee; indeed, the creature must use such means if they are
    the only way to escape.
    Panicked is a more extreme state of fear than shaken or frightened.

    In NWN:

* 1 = Shaken: Characters who are shaken take a -2 penalty on attack rolls,
        saving throws, skill checks, and ability checks.)
* 2 = Frightened: Characters who are frightened are shaken, and in addition
        they flee from the source of their fear as quickly as they can. They
        can choose the path of their flight. Other than that stipulation, once
        they are out of sight (or hearing) of the source of their fear, they
        can act as they want. However, if the duration of their fear continues,
        characters can be forced to flee once more if the source of their fear
        presents itself again. Characters unable to flee can fight (though they
        are still shaken).
* 3 = Panicked: Characters who are panicked are shaken, and they run away
        from the source of their fear as quickly as they can. Other than running
        away from the source, their path is random. They flee from all other
        dangers that confront them rather than facing those dangers. Panicked
        characters cower if they are prevented from fleeing.

    Note: SMP_SPELL_REMOVE_FEAR will surpress any effects!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: July+
//::////////////////////////////////////////////*/

#include "SMP_INC_AILMENT"
#include "SMP_INC_EFFECTS"


// Get the nearest valid creator of fear in the area.
// Must be seen or heard, else they are not a source of fear visible to us (we
// are unaware of them, so we can just do things normally)
object GetNearestPersonWhoCreatedFear(object oSelf);
// When panicked and need to cower, this does it.
void Cower(object oSelf);

const string SMP_FEAR_LAST_LOCATION = "SMP_FEAR_LAST_LOCATION";
const string SMP_LAST_FEAR = "SMP_LAST_FEAR";
const int SMP_FEAR_INVALID = 0;
const int SMP_FEAR_SHAKEN = 1;
const int SMP_FEAR_FRIGHTENED = 2;
const int SMP_FEAR_FRIGHTENED_OK = 3;
const int SMP_FEAR_COWER = 4;
const int SMP_FEAR_PANIC = 5;

void main()
{
    // Allow the target to recieve commands for the round
    SetCommandable(TRUE);

    // Get self
    object oSelf = OBJECT_SELF;
    object oFear, oNearestFearer;

    // We need to check Calm Emotions
    // - If TRUE, surpress
    if(SMP_AilmentCheckCalmEmotions())
    {
        SendMessageToPC(OBJECT_SELF, "Your calm emotions blocks fear.");
        DelayCommand(0.0, SetCommandable(TRUE, oSelf));
        return;
    }

    // Set/Get location now
    location lLastLocation = GetLocalLocation(oSelf, SMP_FEAR_LAST_LOCATION);
    location lOurLocation = GetLocation(oSelf);
    SetLocalLocation(oSelf, SMP_FEAR_LAST_LOCATION, lOurLocation);

    // If we are under the effects of SMP_SPELL_REMOVE_FEAR, this heartbeat
    // fails.
    if(GetHasSpellEffect(SMP_SPELL_REMOVE_FEAR, oSelf))
    {
        // We surpress our fear!
        SendMessageToPC(oSelf, "You suppress your fear due to the effects of Remove Fear!");
        DelayCommand(0.0, SetCommandable(TRUE, oSelf));
        SetLocalInt(oSelf, SMP_LAST_FEAR, SMP_FEAR_INVALID);
        return;
    }

    // Apply an amount of 6 second "Shaken"
    effect eShaken = SMP_CreateShakenEffectsLink();
    eShaken = ExtraordinaryEffect(eShaken);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShaken, oSelf, 6.0);

    // Get fear number, 0-3.
    effect eCheck = GetFirstEffect(oSelf);
    int nSpellId, nFearAmount;
    // Loop effects
    while(GetIsEffectValid(eCheck))
    {
        // Check for stacked fear effects.
        if(GetEffectType(eCheck) == EFFECT_TYPE_FRIGHTENED)
        {
            nSpellId = GetEffectSpellId(eCheck);
            switch(nSpellId)
            {
                // Causes SHAKEN alone (1)
                case SMP_SPELL_DOOM:
                {
                    nFearAmount += 1;
                }
                break;
                // Causes FRIGHTENED alone (2)
                //case :
                //{
                //    nFearAmount += 2;
                //}
                //break;
                // Causes PANICKED alone (3)
                case SMP_SPELL_CHILL_TOUCH:
                case SMP_SPELL_SYMBOL_OF_FEAR:
                {
                    nFearAmount += 3;
                }
                break;
                // Special
                // - Eyebite. Applies 1d4 rounds of panic (local int is 1)
                //   else will be just shaken.
                case SMP_SPELL_EYEBITE:
                {
                    if(GetLocalInt(oSelf, "SMP_SPELL_EYEBITE_FEAR") == 1)
                    {
                        nFearAmount += 3;
                    }
                    else
                    {
                        nFearAmount += 1;
                    }
                }
                break;
                // - Fear. normally Panic. If local integer, it means the
                //   panic, else shaken.
                case SMP_SPELL_FEAR:
                {
                    if(GetLocalInt(oSelf, "SMP_SPELL_FEAR_FEAR") == 1)
                    {
                        // Normal panic
                        nFearAmount += 3;
                    }
                    else
                    {
                        // Mearly shaken
                        nFearAmount += 1;
                    }
                }
                break;
                // Cause fear + scare - normally Frightned, but could be normal
                // shaken.
                case SMP_SPELL_CAUSE_FEAR:
                {
                    if(GetLocalInt(oSelf, "SMP_SPELL_CAUSE_FEAR_FEAR") == 1)
                    {
                        // Normal fright
                        nFearAmount += 2;
                    }
                    else
                    {
                        // Mearly shaken
                        nFearAmount += 1;
                    }
                }
                break;
                case SMP_SPELL_SCARE:
                {
                    if(GetLocalInt(oSelf, "SMP_SPELL_SCARE_FEAR") == 1)
                    {
                        // Normal fright
                        nFearAmount += 2;
                    }
                    else
                    {
                        // Mearly shaken
                        nFearAmount += 1;
                    }
                }
                break;
                // Anything created by anything else will be Frightened.
                default:
                {
                    nFearAmount += 2;
                }
                break;
            }
        }
        eCheck = GetNextEffect(oSelf);
    }
    // Make sure it isn't over 3
    if(nFearAmount > 3)
    {
        nFearAmount = 3;
    }

    // Ok, fear effects:
    switch(nFearAmount)
    {
// * 1 = Shaken: Characters who are shaken take a -2 penalty on attack rolls,
//       saving throws, skill checks, and ability checks.)
        case 1:
        {
            // We are only shaken. We should be able to revieve commands
            SendMessageToPC(oSelf, "You are shaken, the panic implies penalities but there in no need to run.");
            DelayCommand(0.0, SetCommandable(TRUE, oSelf));
            SetLocalInt(oSelf, SMP_LAST_FEAR, SMP_FEAR_SHAKEN);
        }
        break;
// * 2 = Frightened: Characters who are frightened are shaken, and in addition
//       they flee from the source of their fear as quickly as they can. They
//       can choose the path of their flight. Other than that stipulation, once
//       they are out of sight (or hearing) of the source of their fear, they
//       can act as they want. However, if the duration of their fear continues,
//       characters can be forced to flee once more if the source of their fear
//       presents itself again. Characters unable to flee can fight (though they
//       are still shaken).
        case 2:
        {
            // Get the nearest person who created any of our fear effects
            oNearestFearer = GetNearestPersonWhoCreatedFear(oSelf);

            // If valid, we run from it
            if(GetIsObjectValid(oNearestFearer))
            {
                // Were we frightened like this before?
                if(GetLocalInt(oSelf, SMP_LAST_FEAR) == SMP_FEAR_FRIGHTENED)
                {
                    if(VectorMagnitude(GetPositionFromLocation(lLastLocation) - GetPositionFromLocation(lOurLocation)) < 0.5)
                    {
                        // If we havn't been able to move more then 0.5M away from
                        // our previous location, we'll fight!
                        SendMessageToPC(oSelf, "You are frightened and cornored! Fight!");
                        DelayCommand(0.0, SetCommandable(TRUE, oSelf));
                        SetLocalInt(oSelf, SMP_LAST_FEAR, SMP_FEAR_FRIGHTENED_OK);
                        return;
                    }
                }
                // Want to add a flee move
                SetCommandable(TRUE, oSelf);

                // Move, and notify
                ClearAllActions();
                SendMessageToPC(oSelf, "You are frightened! You flee from " + GetName(oNearestFearer));
                ActionMoveAwayFromObject(oNearestFearer, TRUE, 60.0);

                // Unable to change this action
                SetCommandable(FALSE, oSelf);
                SetLocalInt(oSelf, SMP_LAST_FEAR, SMP_FEAR_FRIGHTENED);
            }
            else
            {
                SendMessageToPC(oSelf, "You are frightened, however, you do not seem to see the creature you fear and can do as you wish...");
                DelayCommand(0.0, SetCommandable(TRUE, oSelf));
                SetLocalInt(oSelf, SMP_LAST_FEAR, SMP_FEAR_FRIGHTENED_OK);
            }
        }
        break;
// * 3 = Panicked: Characters who are panicked are shaken, and they run away
//       from the source of their fear as quickly as they can. Other than running
//       away from the source, their path is random. They flee from all other
//       dangers that confront them rather than facing those dangers. Panicked
//       characters cower if they are prevented from fleeing.
        case 3:
        {
            // Get the nearest person who created any of our fear effects
            oNearestFearer = GetNearestPersonWhoCreatedFear(oSelf);

            // If valid, we run from it
            if(!GetIsObjectValid(oNearestFearer))
            {
                // Get nearest enemy to run from
                oNearestFearer = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, oSelf, 1, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, CREATURE_TYPE_IS_ALIVE, TRUE);
                // No valid seen? try heard
                if(!GetIsObjectValid(oNearestFearer))
                {
                    // Nearest heard
                    oNearestFearer = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, oSelf, 1, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, CREATURE_TYPE_IS_ALIVE, TRUE);
                }
            }
            // Not valid? urg..cower!
            if(!GetIsObjectValid(oNearestFearer))
            {
                Cower(oSelf);
                return;
            }
            else
            {
                // Were we frightened like this before?
                if(GetLocalInt(oSelf, SMP_LAST_FEAR) == SMP_FEAR_PANIC)
                {
                    if(VectorMagnitude(GetPositionFromLocation(lLastLocation) - GetPositionFromLocation(lOurLocation)) < 0.5)
                    {
                        // If we havn't been able to move more then 0.5M away from
                        // our previous location - cower
                        Cower(oSelf);
                        return;
                    }
                }
                // Want to move away
                SetCommandable(TRUE, oSelf);
                SendMessageToPC(oSelf, "You are panicked! You flee from " + GetName(oNearestFearer));
                ActionMoveAwayFromObject(oNearestFearer, TRUE, 60.0);
                // Unable to change this action
                SetCommandable(FALSE, oSelf);
                SetLocalInt(oSelf, SMP_LAST_FEAR, SMP_FEAR_PANIC);
            }
        }
        break;
    }
}

// Get the nearest valid creator of fear in the area.
// Must be seen or heard, else they are not a source of fear visible to us (we
// are unaware of them, so we can just do things normally)
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
            // Check if valid, and same area, and they are seen or heard
            if(GetIsObjectValid(oCreator) && GetArea(oCreator) == oArea &&
               GetObjectType(oCreator) == OBJECT_TYPE_CREATURE &&
              (GetObjectSeen(oCreator, oSelf) || GetObjectHeard(oCreator, oSelf)))
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

// When panicked and need to cower, this does it.
void Cower(object oSelf)
{
    // Want to cower
    SetCommandable(TRUE, oSelf);
    // Cower, and notify
    SendMessageToPC(oSelf, "You are panicked! You Cower in fear!");
    // Check if we were "cowereing" before
    if(GetLocalInt(oSelf, SMP_LAST_FEAR) != SMP_FEAR_COWER)
    {
        ClearAllActions();
        ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 999999.0);
    }
    // Unable to change this action
    SetCommandable(FALSE, oSelf);

    SetLocalInt(oSelf, SMP_LAST_FEAR, SMP_FEAR_COWER);
}
