/*:://////////////////////////////////////////////
//:: Spell Name Spike Growth - On Exit
//:: Spell FileName PHS_S_SpikeGrowB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    On Exit.

    Does any additional damage missed by the last heartbeat, and might apply
    the speed decrease of course.

    Also deletes the locals for location setting.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare major variables
    object oTarget = GetExitingObject();
    object oCaster = GetAreaOfEffectCreator();

    // Big note: If the caster is not valid, we do not do this event
    // Basically, no opposing person to do the save and resistance against, I'm afraid.
    if(!GetIsObjectValid(oCaster)) return;

    int nMetaMagic = PHS_GetAOEMetaMagic();
    int nSpellSaveDC = PHS_GetAOESpellSaveDC();
    int nDamage, nDice;
    float fDistance;
    string sLocal = "PHS_SPIKE_GROWTH_LOCATION";
    location lPrevious, lNew;
    object oArea = GetArea(OBJECT_SELF);

    // oTarget needs to be in the same area
    if(GetArea(oTarget) != oArea) return;

    // Get duration of speed decrease - 24 hours
    float fDuration = PHS_GetDuration(PHS_HOURS, 24, nMetaMagic);

    // Declare effects
    effect eDur = EffectVisualEffect(VFX_DUR_ENTANGLE);
    effect eSpeed = EffectMovementSpeedDecrease(50);

    // Link eDur and eSpeed
    effect eLink = EffectLinkEffects(eDur, eSpeed);

    // Note: Make eLink supernatural. Dispel cannot affect it (but as it is only
    // 24 hours, rest should remove it).
    eLink = SupernaturalEffect(eLink);

    // PvP check
    if(!GetIsReactionTypeFriendly(oTarget, oCaster))
    {
        // Get the distance traveled.
        lPrevious = GetLocalLocation(oTarget, sLocal);
        // Get current location
        lNew = GetLocation(oTarget);

        // NOTE: always delete lPrevious. We also never set lNew
        DeleteLocalLocation(oTarget, sLocal);

        // Must be same area, this location and what is set.
        if(GetAreaFromLocation(lPrevious) != oArea)
        {
            // Not same area
        }
        else
        {
            // Same area - we can do damage

            // Check distance.
            fDistance = GetDistanceBetweenLocations(lPrevious, lNew);

            // Must be at least 1M distance, else, we will just keep old
            // location.
            if(fDistance >= 1.0)
            {
                // Fire cast spell at event for the affected target
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SPIKE_GROWTH);

                // Change the distance to an integer (so it will round)
                nDice = FloatToInt(fDistance);

                // This is one of the very few AOE spells which allow Spell Resistance.
                if(!PHS_SpellResistanceCheck(oCaster, oTarget))
                {
                    // Get damage
                    nDamage = PHS_MaximizeOrEmpower(4, nDice, nMetaMagic);

                    // Reflex Save
                    nDamage = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, nDamage, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster);

                    if(nDamage > 0)
                    {
                        // Apply damage and visuals
                        PHS_ApplyDamageToObject(oTarget, nDamage, DAMAGE_TYPE_PIERCING);

                        // Apply reduction in speed for 24 hours
                        // * Remove previous too
                        // * Also note: Applied instantly, to prevent errors.
                        PHS_RemoveSpecificEffectFromSpell(EFFECT_TYPE_MOVEMENT_SPEED_DECREASE, PHS_SPELL_SPIKE_GROWTH, oTarget, SUBTYPE_IGNORE);
                        PHS_ApplyDuration(oTarget, eLink, fDuration);
                    }
                }
                //else
                //{
                    // There is NOT 1M difference between locations
                //}
            }
        }
    }
}
