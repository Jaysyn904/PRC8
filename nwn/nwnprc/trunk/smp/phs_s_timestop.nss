/*:://////////////////////////////////////////////
//:: Spell Name Time Stop
//:: Spell FileName SMP_S_TimeStop
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Sor/Wiz 9, Trickery 9
    Components: V
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1d4+1 rounds (apparent time); see text

    This spell seems to make time cease to flow for everyone but you. In fact,
    you speed up so greatly that all other creatures seem frozen, though they
    are actually still moving at their normal speeds. You are free to act for
    1d4+1 rounds of apparent time. While the time stop is in effect, other
    creatures are invulnerable to your attacks and spells; you cannot target
    such creatures with any attack or spell. A spell that affects an area and
    has a duration longer than the remaining duration of the time stop have
    their normal effects on other creatures once the time stop ends. Most
    spellcasters use the additional time to improve their defenses, summon
    allies, or flee from combat.

    You cannot move or harm items held, carried, or worn by a creature stuck in
    normal time, but you can affect any item that is not in another creature’s
    possession.

    You are undetectable while time stop lasts. You cannot enter an area
    protected by an antimagic field while under the effect of time stop.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Applies the normal 1d4 + 1 rounds. Of course, module builders may want to
    remove the spell (so they can change the 2da is best, honestly :-) ).

    Uses bioware visual effect, looks good and works fine IMHO :-)

    And also, big thing:

    - Just before the effect is applied, the whole area has creatures made to
      PLOT - if they are not already (local integers secure this)!
    - The plot lasts until just a little after the end of time stop. This mainly
      stops instant spells (EG: Harm) and attacks in time stop - they won't
      do anything!
    - Spells cast on anyone but the caster or a location in time stop will
      have no effect.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

// Sets all creatures in the area to "plot" (using effects) for 0.1 seconds.
void SetAreaPlot(object oCaster);

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_TIME_STOP)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); // Should be OBJECT_SELF.
    location lTarget = GetLocation(oTarget);
    int nMetaMagic = SMP_GetMetaMagicFeat();

    // Make the duration rounds to seconds. 1d4 + 1.
    float fDuration = SMP_GetRandomDuration(SMP_ROUNDS, 4, 1, nMetaMagic, 1);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_FNF_TIME_STOP);
    effect eTime = EffectTimeStop();

    // Fire cast spell at event for the specified target
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_TIME_STOP, FALSE);

    // Set plot flags to the area (excluding the caster) for 0.1 seconds.
    SetAreaPlot(oCaster);

    // Apply the VFX impact and effects.
    SMP_ApplyLocationVFX(lTarget, eVis);
    // Apply the time stop effect immediantly.
    SMP_ApplyDuration(oTarget, eTime, fDuration);
}


// Sets all creatures in the area to plot
void SetAreaPlot(object oCaster)
{
    int nCnt = 1;
    object oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oTarget, nCnt);
    // Declare the "plot"
    effect ePlot = SMP_AllImmunitiesLink();
    // Make it undispellable
    ePlot = SupernaturalEffect(ePlot);

    // We set "plot" to everything - placeables, doors and so on. Local
    // integer will remove it later
    while(GetIsObjectValid(oTarget))
    {
        // Make sure they are not already plot, no need then, and that it isn't the caster
        if(!GetPlotFlag(oTarget) && oTarget != oCaster)
        {
            // Apply it for 0.1 seconds
            SMP_ApplyDuration(oTarget, ePlot, 0.1);
        }
        nCnt++;
        oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oTarget, nCnt);
    }
}
