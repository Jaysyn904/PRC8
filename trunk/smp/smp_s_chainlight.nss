/*:://////////////////////////////////////////////
//:: Spell Name Chain Lightning
//:: Spell FileName SMP_S_ChainLight
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Electricity]
    Level: Air 6, Sor/Wiz 6
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Long (40M)
    Targets: One primary target, plus one secondary target/level, within a 10M radius.
             Enemies only, Creatures first.
    Duration: Instantaneous
    Saving Throw: Reflex half
    Spell Resistance: Yes

    This spell creates an electrical discharge that begins as a single stroke
    commencing from your fingertips. Unlike lightning bolt, chain lightning
    strikes one object or creature initially, then arcs to other targets.

    The bolt deals 1d6 points of electricity damage per caster level (maximum
    20d6) to the primary target. After it strikes, lightning can arc to a number
    of secondary targets equal to your caster level (maximum 20). The secondary
    bolts each strike one target and deal half as much damage as the primary one
    did (rounded down).

    Each target can attempt a Reflex saving throw for half damage. You choose
    secondary targets as you like, but they must all be within 30 feet of the
    primary target, and no target can be struck more than once. You can choose
    to affect fewer secondary targets than the maximum.

    Focus: A bit of fur; a piece of amber, glass, or a crystal rod; plus one
    silver pin for each of your caster levels.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Say, 20d6 to primary target, it'd be 10d6 to all secondary ones.

    As spell, mainly copied a bit from bioware as its the same way Id to it.

    Note that it has more "advanced" targeting: if we target a door, all doors
    in the area are hit before other things, while the same is in the case of
    placables and creatures.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

// ZZaaapp! Returns the total targets affected of nTargetType's.
int ChainLightningTargets(location lTarget, float fDelay, int nDice, int nMetaMagic, object oCaster, int nSpellSaveDC, int nLimit, int nTargetTypes, object oFirstTarget);

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck()) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oFirstTarget = GetSpellTargetObject();
    location lTarget = GetLocation(oFirstTarget);
    int nCasterLevel = SMP_GetCasterLevel();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nDice = SMP_LimitInteger(nCasterLevel, 20);
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nTotalSecondaryAffected;

    // Delay increases by 0.1/target, from 0.0
    float fDelay = 0.0;

    // Declare effects
    int nDam;
    effect eLightningBeam = EffectBeam(VFX_BEAM_LIGHTNING, oCaster, BODY_NODE_HAND);
    effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);

    // Initial target damage
    if(GetIsObjectValid(oFirstTarget) && GetIsReactionTypeHostile(oFirstTarget) &&
      !GetFactionEqual(oFirstTarget))
    {
        // Apply lightning effect
        SMP_ApplyDuration(oFirstTarget, eLightningBeam, 0.5);

        // Signal spell cast at
        SMP_SignalSpellCastAt(oFirstTarget, SMP_SPELL_CHAIN_LIGHTNING);

        // Spell Resistance and Immunity check
        if(!SMP_SpellResistanceCheck(oCaster, oFirstTarget, fDelay))
        {
            // New damage
            nDam = SMP_MaximizeOrEmpower(6, nDice, nMetaMagic);

            // Reflex save
            nDam = SMP_GetAdjustedDamage(SAVING_THROW_REFLEX, nDam, oFirstTarget, nSpellSaveDC, SAVING_THROW_TYPE_ELECTRICITY, oCaster);

            // Apply damage if any
            if(nDam > 0)
            {
                DelayCommand(fDelay, SMP_ApplyDamageVFXToObject(oFirstTarget, eVis, nDam, DAMAGE_TYPE_ELECTRICAL));
            }
        }
    }
    else
    {
        // Stop if it can't work (PvP, etc)
        return;
    }
    // Now, we target all of that object type
    int nTargetType = GetObjectType(oFirstTarget);

    // Round dice by half
    nDice = SMP_LimitInteger(nDice/2, 10);

    // Do first one
    int nRemaining = ChainLightningTargets(lTarget, fDelay, nDice, nMetaMagic, oCaster, nSpellSaveDC, nCasterLevel, nTargetType, oFirstTarget);

    // If no targets left, stop
    if(nRemaining <= 0) return;

    // Next, do the other 2 at once!
    if(nTargetType == OBJECT_TYPE_CREATURE)
    {
        nTargetType = OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE;
    }
    else if(nTargetType == OBJECT_TYPE_DOOR)
    {
        nTargetType = OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE;
    }
    else //if(nTargetType == OBJECT_TYPE_PLACEABLE)
    {
        nTargetType = OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR;
    }

    // New loop of remaining targets, up to nRemaining
    ChainLightningTargets(lTarget, fDelay, nDice, nMetaMagic, oCaster, nSpellSaveDC, nRemaining, nTargetType, oFirstTarget);
}

int ChainLightningTargets(location lTarget, float fDelay, int nDice, int nMetaMagic, object oCaster, int nSpellSaveDC, int nLimit, int nTargetTypes, object oFirstTarget)
{
    // Total affected can be up to nLimit.
    int nTotalSecondaryAffected = FALSE;

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
    // No sound
    effect eLightningBeam = EffectBeam(VFX_BEAM_SILENT_LIGHTNING, oFirstTarget, BODY_NODE_CHEST);

    // Note: eLightningBeam will be silent every other beam, to lessen the
    // impact of it's sounds firing.
    int bBeam = FALSE;// When TRUE.

    // Damage
    int nDam;

    // Get objects with nTargetTypes as variable. 10M
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, nTargetTypes);
    while(GetIsObjectValid(oTarget) && nTotalSecondaryAffected <= nLimit)
    {
        // Faction check - Cannot hit original target neither
        if(oTarget != oFirstTarget && GetIsReactionTypeHostile(oTarget) &&
          !GetFactionEqual(oTarget))
        {
            // Visual effect of lightning for a short duration
            DelayCommand(fDelay, SMP_ApplyDuration(oTarget, eLightningBeam, 0.5));

            // Signal spell cast at event
            SMP_SignalSpellCastAt(oTarget, SMP_SPELL_CHAIN_LIGHTNING);

            // Spell Resistance and Immunity check
            if(!SMP_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // New damage
                nDam = SMP_MaximizeOrEmpower(6, nDice, nMetaMagic);

                // Reflex save
                nDam = SMP_GetAdjustedDamage(SAVING_THROW_REFLEX, nDam, oFirstTarget, nSpellSaveDC, SAVING_THROW_TYPE_ELECTRICITY, oCaster);

                // Apply damage if any
                if(nDam > 0)
                {
                    DelayCommand(fDelay, SMP_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_ELECTRICAL));
                }
            }
            // Make the lightning beam effect start from oTarget now
            // - Remember bBeam!
            if(bBeam == TRUE)
            {
                // LOUD
                eLightningBeam = EffectBeam(VFX_BEAM_LIGHTNING, oTarget, BODY_NODE_CHEST);
                bBeam = FALSE;
            }
            else //if(bBeam == FALSE)
            {
                // No sound
                eLightningBeam = EffectBeam(VFX_BEAM_SILENT_LIGHTNING, oTarget, BODY_NODE_CHEST);
                bBeam = TRUE;
            }
            // Increase delay by 0.1.
            fDelay += 0.1;
            // Increase targets by 1
            nTotalSecondaryAffected++;
        }
        // Next in 10M
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, nTargetTypes);
    }
    return nTotalSecondaryAffected;
}
