/*:://////////////////////////////////////////////
//:: Spell Name Blink
//:: Spell FileName PHS_S_Blink
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Personal/You spell. 1 round/level duration. Changed description:

    You “blink” back and forth between the Material Plane and the Ethereal Plane.
    Youlook as though you’re winking in and out of reality very quickly and at
    random.

    Blinking has several effects, as follows.

    Physical attacks against you have a 25% miss chance, you get 25% consealment
    against phisical attacks. Likewise, your own attacks have a 20% miss chance,
    since you sometimes go ethereal just as you are about to strike.

    Any individually targeted spell has a 50% chance to fail against you while
    you’re blinking unless your attacker can target invisible, ethereal
    creatures. Your own spells have a 20% chance to activate just as you go
    ethereal, in which case they typically do not affect the Material Plane.

    While blinking, you strike as an invisible creature (with a +2 bonus on
    attack rolls).

    While blinking, every alternate 6 seconds you can walk through solid
    creatures, as an incorporeal creature.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This does this:

    1. Apply blur effect.
    2. Apply miss chance of 20% (We miss 20% of the time)
    3. Apply a 20% spell failure.
    4. Apply a consealment of 25%
    5. Jump them around a lot :-)

    And:

    6. Any spells that may hit the caster (IE the blinking person) will have a
       50% chance of not working at all. This only affects single target
       spells, so it will only be handled in the spell handle, checking
       GetSpellTargetObject

    It is very simplified - it is only a level 3 spell after all, and NWN doesn't
    handle the Ethereal plane (or any plane) very well.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Blink the target...every 6 seconds.
// nTimesCast must equal PHS_BLINK_TIME_CAST, as to not have 2 of these running
// at once.
void Blink(object oTarget, int nTimesCast, vector vOld, object oArea);

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck()) return;

    // Delcare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    vector vPosition = GetPosition(oTarget);
    object oArea = GetArea(oTarget);

    // Duration is in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Declare effects
    effect eDur = EffectVisualEffect(VFX_DUR_BLUR);
    effect eMiss = EffectMissChance(20);
    effect eFail = EffectSpellFailure(20);
    effect eConseal = EffectConcealment(25);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eMiss);
    eLink = EffectLinkEffects(eFail, eLink);
    eLink = EffectLinkEffects(eConseal, eLink);

    // Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_BLINK, FALSE);

    // Remove previous effects
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_BLINK, oTarget);

    // We add one to the times it has been cast
    int nTimesCast = PHS_IncreaseStoredInteger(oTarget, "PHS_BLINK_TIME_CAST", 1);

    // Apply VFX and effects.
    PHS_ApplyDuration(oTarget, eLink, fDuration);

    // Blink the target...every 6 seconds.
    DelayCommand(6.0, Blink(oTarget, nTimesCast, vPosition, oArea));
}

void Blink(object oTarget, int nTimesCast, vector vOld, object oArea)
{
    if(GetHasSpellEffect(PHS_SPELL_BLINK, oTarget) &&
       GetLocalInt(oTarget, "PHS_BLINK_TIME_CAST") == nTimesCast)
    {
        // Message.
        SendMessageToPC(oTarget, "You blink to a new place between planes!");

        vector vOld = GetPosition(oTarget);
        // +0 to + 6.0 (4.32, 2.64 etc.)
        float fNewX = vOld.x + (IntToFloat(Random(600))/100);
        float fNewY = vOld.y + (IntToFloat(Random(600))/100);
        vector vNew = Vector(fNewX, fNewY, vOld.z);
        // 1-360 degrees.
        float fFacing = IntToFloat(Random(359) + 1);
        // Set location, and jump!
        location lTarg = Location(oArea, vNew, fFacing);
        AssignCommand(oTarget, JumpToLocation(lTarg));
        // Delay next jump
        DelayCommand(6.0, Blink(oTarget, nTimesCast, vNew, oArea));
    }
}
