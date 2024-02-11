/*:://////////////////////////////////////////////
//:: Spell Name Rainbow Pattern
//:: Spell FileName PHS_S_RainbowPa
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Illusion (Pattern) [Mind-Affecting]
    Level: Brd 4, Sor/Wiz 4
    Components: V (Brd only), S, M, F; see text
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Colorful lights with a 6.67M-radius (20-ft.) spread
    Duration: Concentration +1 round/ level (D)
    Saving Throw: Will negates
    Spell Resistance: Yes

    A glowing, rainbow-hued pattern of interweaving colors fascinates those
    within it. Rainbow pattern fascinates a maximum of 24 Hit Dice of creatures.
    Creatures with the fewest HD are affected first. Among creatures with equal
    HD, those who are closest to the spell’s point of origin are affected first.
    An affected creature that fails its saves is fascinated by the pattern.

    All fascinated creatures move to the rainbow pattern for as long as the
    spell lasts, ignoring other dangers, acting as if confused (and thusly
    cannot move in cirtain circumstances). The spell does not affect sightless
    creatures.

    Verbal Component: A wizard or sorcerer need not utter a sound to cast this
    spell, but a bard must sing, play music, or recite a rhyme as a verbal
    component.

    Material Component: A piece of phosphor.

    Focus: A crystal prism.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Ok, so it works like Calm Emotions/Rage for the concentration part.

    Its a confusion effect.

    This is the only spell (currently) that uses more then one spells.2da entry
    for the main spell effect.

    One is the bard (With a verbal component) and one is the Rest, without one.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"
#include "PHS_INC_CONCENTR"

void main()
{
    // If we are concentrating, and cast at the same spot, we set the integer
    // for the hypnotic pattern up by one.
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();

    // Check the function
    if(PHS_ConcentatingContinueCheck(PHS_SPELL_RAINBOW_PATTERN, lTarget, PHS_AOE_TAG_PER_RAINBOW_PATTERN, 18.0, oCaster)) return;

    // Else, new spell!

    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_RAGE)) return;

    // Declare major variables
    object oTarget;
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    string sSpellLocal = "PHS_SPELL_RAINBOW_PATTERN" + ObjectToString(OBJECT_SELF);
    // 24 HD to affect with this spell
    int nHD = 24;
    float fDistance, fDelay;
    int bContinueLoop, nCurrentHD, nLow;
    object oLowest;

    // Extra Duration in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // We set the "Concentration" thing to 18 seconds
    // This also returns the array we set people affected to, and does the new
    // action.
    string sArrayLocal = PHS_ConcentatingStart(PHS_SPELL_RAGE, 0, lTarget, PHS_AOE_PER_RAINBOW_PATTERN, fDuration);
    int nArrayCount;

    // Note on duration: We apply it permamently, however, it will definatly
    // be removed by the AOE.

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eConfuse = EffectConfused();
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link duration VFX and confusion effects
    effect eLink = EffectLinkEffects(eDur, eConfuse);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_20, lTarget, TRUE);
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
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_20, lTarget, TRUE);
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
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_20, lTarget, TRUE);
        }
        // Check to see if oLowest returned a valid object
        if(GetIsObjectValid(oLowest))
        {
            // Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oLowest, PHS_SPELL_RAINBOW_PATTERN);

            // Set a local int to make sure the creature is not used twice in the
            // pass.  Destroy that variable in 0.1 seconds to remove it from
            // the creature
            SetLocalInt(oLowest, sSpellLocal, TRUE);
            DelayCommand(0.1, DeleteLocalInt(oLowest, sSpellLocal));

            // Delay based on range
            fDelay = fDistance/20;

            // Make SR check
            if(!PHS_SpellResistanceCheck(oCaster, oLowest, fDelay) &&
               !PHS_ImmunityCheck(oLowest, IMMUNITY_TYPE_CONFUSED, fDelay) &&
               !PHS_ImmunityCheck(oLowest, IMMUNITY_TYPE_MIND_SPELLS, fDelay))
            {
                // Will saving throw
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oLowest, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay))
                {
                    // Apply effects
                    PHS_ApplyDurationAndVFX(oLowest, eVis, eLink, fDuration);
                }
            }
        }
        // Remove the HD of the creature from the total
        nHD = nHD - GetHitDice(oLowest);
        oLowest = OBJECT_INVALID;
    }
}
