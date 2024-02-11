/*:://////////////////////////////////////////////
//:: Spell Name Ethereal Shock
//:: Spell FileName XXX_S_EtherealSh
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation
    Level: Sor/Wiz 4
    Components: V, S
    Casting Time: 1 standard action
    Range: Ethereal Plane in same location as self
    Area: 20M spread (60 ft.)
    Duration: Instant
    Saving Throw: Will Half
    Spell Resistance: Yes
    Source: Various (Arilou_skiff)

    This spell releases a shockwave of ethereal energy, disrupting the ethereal
    forms of  ethereal travellers and creatures.

    The shockwave emanates from the caster's location, although on the ethereal
    plane (if the caster is actually foolish enough to cast this while *on* the
    ethereal plane he suffers the same effects as anyone else caught in the area).
    Any ethereal creature caught in the blast suffers 1d6 points of damage per
    level of the caster (maximum 12d6) as their ethereal bodies are torn apart
    by the violent energies. Creatures on the Prime do not notice anything at all.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Cool spell, hits only ethereal people :-)

    And we can apply visuals to the people and no one else (of course) can
    see anything.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_ETHEREAL_SHOCK)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = SMP_GetCasterLevel();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nDam;
    float fDelay;

    // Limit dice to 12d6
    int nDice = SMP_LimitInteger(nCasterLevel, 12);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);

    // Get all targets in a sphere, 20M radius, creatures only.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    // Loop targets
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !SMP_TotalSpellImmunity(oTarget))
        {
            // Must be ethereal
            if(SMP_GetIsEthereal(oTarget))
            {
                // Fire cast spell at event for the specified target
                SMP_SignalSpellCastAt(oTarget, SMP_SPELL_ETHEREAL_SHOCK);

                // Get the distance between the explosion and the target to calculate delay
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

                // Spell resistance And immunity checking.
                if(!SMP_SpellResistanceCheck(oCaster, oTarget, fDelay))
                {
                    // Roll damage for each target
                    nDam = SMP_MaximizeOrEmpower(6, nDice, nMetaMagic);

                    // Adjust the damage based on the Will Save.
                    nDam = SMP_GetAdjustedDamage(SAVING_THROW_WILL, nDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster, fDelay);

                    // Need to do damage to apply visuals
                    if(nDam > 0)
                    {
                        // Apply effects to the currently selected target.
                        DelayCommand(fDelay, SMP_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_MAGICAL));
                    }
                }
            }
        }
        // Get Next Target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 20.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
