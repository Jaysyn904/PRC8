/*:://////////////////////////////////////////////
//:: Spell Name Scintillating Pattern
//:: Spell FileName PHS_S_ScintPatte
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Illusion (Pattern) [Mind-Affecting]
    Level: Sor/Wiz 8
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Close (8M)
    Effect: Colorful lights in a 10M.-radius (30-ft.) spread
    Duration: Instantaneous; see text
    Saving Throw: None
    Spell Resistance: Yes

    A twisting pattern of discordant, coruscating colors weaves through the air,
    affecting creatures within it. The spell affects a total number of Hit Dice
    of creatures equal to your caster level (maximum 20). Creatures with the
    fewest HD are affected first; and, among creatures with equal HD, those who
    are closest to the spell’s point of origin are affected first. Hit Dice that
    are not sufficient to affect a creature are wasted. The spell affects each
    subject according to its Hit Dice.

    6 or less: Knocked Down for 1d4 rounds, then stunned for 1d4 rounds, and then
               confused for 1d4 rounds.
    7 to 12: Stunned for 1d4 rounds, then confused for 1d4 rounds.
    13 or more: Confused for 1d4 rounds.

    Sightless creatures are not affected by scintillating pattern.

    Material Component: A small crystal prism.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Changed to an instant effect - might change to concentration if need be or
    if it'll be easy.

    Effects are applied as normal, hell, durations or whatever. It just waits
    for the time, then applies the new effects (using those functions).

    To do: Maybe use cast times for things to do with

    The spell doens't overlap with itself. Nor does the Delayed things work if
    the casting times don't match.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SCINTILLATING_PATTERN)) return;

    // Delcare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    // Other locals
    string sSpellLocal = "PHS_SPELL_SLEEP" + ObjectToString(OBJECT_SELF);
    // Caster Level (Max 20) HD to affect with this spell
    int nHD = PHS_LimitInteger(nCasterLevel, 20);
    float fDistance;//, fDelay;
    int bContinueLoop, nCurrentHD, nLow;
    object oLowest;

    // Durations are different for each effect.
    float fDuration, fDuration2, fDuration3;

    // Delcare effects
    // Knockdown
    effect eKnockdown = EffectKnockdown();
    // Confusion
    effect eConfusion = EffectConfused();
    effect eConfusionVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eConfusionDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    // Stun
    effect eStun = EffectStunned();
    effect eStunVis = EffectVisualEffect(VFX_IMP_STUN);
    effect eStunDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);

    // Links
    effect eConfusionLink = EffectLinkEffects(eConfusion, eConfusionDur);
    effect eStunLink = EffectLinkEffects(eStun, eStunDur);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(PHS_VFX_FNF_SCINTILLATING_PATTERN);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE);
    // If no valid targets exists ignore the loop
    if(GetIsObjectValid(oTarget))
    {
        bContinueLoop = TRUE;
    }
    // The above checks to see if there is at least one valid target.
    while((nHD > 0) && (bContinueLoop))
    {
        nLow = 99;
        bContinueLoop = FALSE;
        //Get the first creature in the spell area
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE);
        while(GetIsObjectValid(oTarget))
        {
            // Already affected check
            if(!GetLocalInt(oTarget, sSpellLocal))
            {
                // Make faction check to ignore allies
                if(!GetIsReactionTypeFriendly(oTarget) &&
                // Make sure they are not immune to spells
                   !PHS_TotalSpellImmunity(oTarget) &&
                // Must be alive
                    PHS_GetIsAliveCreature(oTarget))
                {
                    //Get the current HD of the target creature
                    nCurrentHD = GetHitDice(oTarget);

                    // Check to see if the HD are lower than the current Lowest HD stored and that the
                    // HD of the monster are lower than the number of HD left to use up.
                    if(nCurrentHD <= nHD && ((nCurrentHD < nLow) ||
                      (nCurrentHD <= nLow &&
                       GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) <= fDistance)))
                    {
                        nLow = nCurrentHD;
                        fDistance = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget));
                        oLowest = oTarget;
                        bContinueLoop = TRUE;
                    }
                }
                else
                {
                    // Immune to it in some way, ignore on next pass
                    SetLocalInt(oTarget, sSpellLocal, TRUE);
                    DelayCommand(0.1, DeleteLocalInt(oTarget, sSpellLocal));
                }
            }
            //Get the next target in the shape
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE);
        }
        // Check to see if oLowest returned a valid object
        if(GetIsObjectValid(oLowest))
        {
            // Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oLowest, PHS_SPELL_SCINTILLATING_PATTERN);

            // Set a local int to make sure the creature is not used twice in the
            // pass.  Destroy that variable in 0.1 seconds to remove it from
            // the creature
            SetLocalInt(oLowest, sSpellLocal, TRUE);
            DelayCommand(0.1, DeleteLocalInt(oLowest, sSpellLocal));

            // Delay based on range
            //fDelay = fDistance/20;

            // Make SR check, immunity check, and must be able to see.
            if(!PHS_SpellResistanceCheck(oCaster, oLowest) &&
               !PHS_ImmunityCheck(oLowest, IMMUNITY_TYPE_MIND_SPELLS) &&
                PHS_GetCanSee(oLowest))
            {
                // No save! But effects based on HD
                if(nLow <= 6)
                {
                    // 1-6, Knockdown, Stun then Confusion.
                    fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 4, 1, nMetaMagic);
                    PHS_ApplyDuration(oLowest, eKnockdown, fDuration);
                    // Delay the next one
                    fDuration2 = PHS_GetRandomDuration(PHS_ROUNDS, 4, 1, nMetaMagic);
                    DelayCommand(fDuration, PHS_ApplyDurationAndVFX(oLowest, eConfusionVis, eConfusionLink, fDuration2));
                    // Delay the next one
                    fDuration3 = PHS_GetRandomDuration(PHS_ROUNDS, 4, 1, nMetaMagic);
                    DelayCommand(fDuration + fDuration2, PHS_ApplyDurationAndVFX(oLowest, eConfusionVis, eConfusionLink, fDuration3));
                }
                else if(nLow <= 12)
                {
                    // 7-12 Stunned for 1d4 rounds, then confused for 1d4 rounds
                    fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 4, 1, nMetaMagic);
                    PHS_ApplyDurationAndVFX(oLowest, eStunVis, eStunLink, fDuration);
                    // Delay the next one
                    fDuration2 = PHS_GetRandomDuration(PHS_ROUNDS, 4, 1, nMetaMagic);
                    DelayCommand(fDuration, PHS_ApplyDurationAndVFX(oLowest, eConfusionVis, eConfusionLink, fDuration2));
                }
                else //if(nLow >= 13)
                {
                    // 13+ Confused 1d4 rounds
                    fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 4, 1, nMetaMagic);
                    PHS_ApplyDurationAndVFX(oLowest, eConfusionVis, eConfusionLink, fDuration);
                }
            }
        }
        // Remove the HD of the creature from the total
        nHD = nHD - GetHitDice(oLowest);
        oLowest = OBJECT_INVALID;
    }
}
