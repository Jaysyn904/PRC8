/*:://////////////////////////////////////////////
//:: Name Calm monsters include file
//:: FileName SMP_INC_CALM
//:://////////////////////////////////////////////
//:: Notes
//:://////////////////////////////////////////////
    How calming works:

    - If something is calmed (or other similar things) it is probably meant to
      do something and ignore battle
    - However, if attacked, it'll react back.

    Without a way of having a "If attacked" effect - the best would be "if
    damaged" which doesn't, of course, include spells like Domination or Paralsis,
    which could possibly be cast on it many times until it works.

    Therefore, the functions "SMP_SetCalm()" will
    apply eApply, and also make the return value got via
    GetLastHostileActor() a creature in the SMP area (or newly created if
    not found, immortal with 1 HP who of course cannot die) the last hostile
    actor, as it'll apply some quick damage to the object.

    Then, if the last hostile actor ever changes from being the creature set
    in the HB function, it'll remove the effect (Allows for invalid objects, plot
    objects etc. attacking the monster).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_APPLY"

// SMP_INC_CALM. Will set oCreature to "Calm", start a special heartbeat. If the creature is
// ever attacked by something, it'll remove all effects done by nSpellId
// (Got via. GetSpellId() to be totally accurate).
void SMP_SetCalm(object oCreature, object oCaster = OBJECT_SELF);

// SMP_INC_CALM. Acts like a heartbeat for Acid Arrow. If oCreature or oCaster is invalid,
// stops.
// If GetLastHostileActor() is not oHostileActor, this removes all effects
// from the spell nSpellId on oCreature.
void SMP_CalmHeartBeat(object oCreature, object oHostileActor, int nSpellId, object oCaster);

// SMP_INC_CALM. Will set oCreature to "Calm", start a special heartbeat and
// apply eApply to them. If the creature is ever attacked by something, it'll remove
// all effects done by nSpellId (Got via. GetSpellId() to be totally accurate)
void SMP_SetCalm(object oCreature, object oCaster = OBJECT_SELF)
{
    // Effects already applied.

    // Get the creature to be our new "Hostile Actor"
    object oHostileActor = GetObjectByTag("smp_host_act");

    // Create a new one if not present
    if(!GetIsObjectValid(oHostileActor))
    {
        oHostileActor = CreateObject(OBJECT_TYPE_CREATURE, "smp_host_act", GetLocation(oCreature));
    }
    // This is a member of the largely unused (or used for summons) Merchant
    // faction. Should work OK.
    // (Clears reaction too)
    int nRep = GetStandardFactionReputation(STANDARD_FACTION_MERCHANT, oCreature);
    // No personal stuff getting in the way.
    ClearPersonalReputation(oHostileActor, oCreature);
    // Delay changing it back to orignal.
    DelayCommand(0.01, SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, nRep, oCreature));

    // Get it to apply some effects. using this instead of EventSignalEvent() for
    // spell Id's, because it is not as "instant". Damage is instant.
    effect eHeal = EffectHeal(1);
    effect eDam = EffectDamage(1);
    if(GetCurrentHitPoints(oCreature) == 1)
    {
        // Heal first
        AssignCommand(oHostileActor, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oCreature));
        AssignCommand(oHostileActor, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oCreature));
    }
    else
    {
        // Heal last (could be at max HP)
        AssignCommand(oHostileActor, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oCreature));
        AssignCommand(oHostileActor, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oCreature));
    }

    // Get spell Id
    int nSpellId = GetSpellId();

    // Assign the calm heartbeat onto oCreature
    AssignCommand(oCreature, DelayCommand(3.0, SMP_CalmHeartBeat(oCreature, oHostileActor, nSpellId, oCaster)));
}

// SMP_INC_CALM. Acts like a heartbeat for Acid Arrow. If oCreature or oCaster is invalid,
// stops.
// If GetLastHostileActor() is not oHostileActor, this removes all effects
// from the spell nSpellId on oCreature.
void SMP_CalmHeartBeat(object oCreature, object oHostileActor, int nSpellId, object oCaster)
{
    // Check for validness
    if(!GetIsObjectValid(oCreature)) return;

    // Check if nSpellId is still present anyway
    if(!GetHasSpellEffect(nSpellId, oCreature)) return;

    // Check caster, hostile actor and spell Id
    if(!GetIsObjectValid(oCaster) || GetLastHostileActor() != oHostileActor)
    {
        // Remove effects, stop
        SendMessageToPC(oCreature, "You were attacked and released from some spell effect");
        SMP_RemoveSpellEffectsFromTarget(nSpellId, oCreature);
        return;
    }
    // New heartbeat again
    DelayCommand(3.0, SMP_CalmHeartBeat(oCreature, oHostileActor, nSpellId, oCaster));
}
