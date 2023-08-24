/*:://////////////////////////////////////////////
//:: Spell Name Spike Growth - On Heartbeat
//:: Spell FileName PHS_S_SpikeGrowC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    On Heartbeat.

    Gets the distance traveled, and must be over 1M to do damage, at 1d4 damage
    per meter.

    If any damage is done, they will have to have 50% speed deduction for 24
    hours. Note: This doesn't overlap.

    The any remaining/old locations are deleted On Exit.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oTarget;
    object oCaster = GetAreaOfEffectCreator();
    int nMetaMagic = PHS_GetAOEMetaMagic();
    int nSpellSaveDC = PHS_GetAOESpellSaveDC();
    int nDamage, nDice;
    float fDelay, fDistance;
    string sLocal = "PHS_SPIKE_GROWTH_LOCATION";
    location lPrevious, lNew;
    object oArea = GetArea(OBJECT_SELF);

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

    // Start cycling through the AOE Object for viable targets
    oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster))
        {
            // Get the distance traveled.
            lPrevious = GetLocalLocation(oTarget, sLocal);
            // Get current location
            lNew = GetLocation(oTarget);

            // Must be same area, this location and what is set.
            if(GetAreaFromLocation(lPrevious) != oArea)
            {
                // Not same area - we set new location on them
                SetLocalLocation(oTarget, sLocal, lNew);
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

                    // Set new location
                    SetLocalLocation(oTarget, sLocal, lNew);

                    // Change the distance to an integer (so it will round)
                    nDice = FloatToInt(fDistance);

                    // Get a very small delay
                    fDelay = PHS_GetRandomDelay(0.1, 0.5);

                    // This is one of the very few AOE spells which allow Spell Resistance.
                    if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
                    {
                        // Get damage
                        nDamage = PHS_MaximizeOrEmpower(4, nDice, nMetaMagic);

                        // Reflex Save
                        nDamage = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, nDamage, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster, fDelay);

                        if(nDamage > 0)
                        {
                            // Apply damage and visuals
                            DelayCommand(fDelay, PHS_ApplyDamageToObject(oTarget, nDamage, DAMAGE_TYPE_PIERCING));

                            // Apply reduction in speed for 24 hours
                            // * Remove previous too
                            // * Also note: Applied instantly, to prevent errors.
                            PHS_RemoveSpecificEffectFromSpell(EFFECT_TYPE_MOVEMENT_SPEED_DECREASE, PHS_SPELL_SPIKE_GROWTH, oTarget, SUBTYPE_IGNORE);
                            PHS_ApplyDuration(oTarget, eLink, fDuration);
                        }
                    }
                }
                //else
                //{
                    // There is NOT 1M difference between locations, so we
                    // just use old location, and set nothing.
                //}
            }
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    }
}
