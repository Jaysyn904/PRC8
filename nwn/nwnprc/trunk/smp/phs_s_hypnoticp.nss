/*:://////////////////////////////////////////////
//:: Spell Name Hypnotic Pattern
//:: Spell FileName PHS_S_HypnoticP
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Illusion (Pattern) [Mind-Affecting]
    Level: Brd 2, Sor/Wiz 2
    Components: V (Brd only), S, M; see text
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Colorful lights in a 3.33-M.-radius spread
    Duration: Concentration + 2 rounds
    Saving Throw: Will negates
    Spell Resistance: Yes

    A twisting pattern of subtle, shifting colors weaves through the air,
    fascinating creatures within it. Roll 2d4 and add your caster level (maximum
    10) to determine the total number of Hit Dice of creatures affected.
    Creatures with the fewest HD are affected first; and, among creatures with
    equal HD, those who are closest to the spell’s point of origin are affected
    first. Hit Dice that are not sufficient to affect a creature are wasted.
    Affected creatures become fascinated by the pattern of colors and are
    stunned. Sightless creatures are not affected.

    You need to concentrate while carrying out this spell, else it will only last
    2 rounds. This will be done automatically, however, of course, any canclation
    of the concentration will mean the spells duration will end after 2 additional
    rounds.

    A wizard or sorcerer need not utter a sound to cast this spell, but a bard
    must sing, play music, or recite a rhyme as a verbal component, and so cannot
    be silenced.

    Material Component: A glowing stick of incense or a crystal rod filled with
    phosphorescent material.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is done as so:

    - Creates an AOE after applying the effects. The application is for
      ever, the AOE will remove the effects.
    - Uses EffectStun() (after facing), and check immunity to mind spells.
    - Will only affect those in the AOE.
    - Will call a new "hypnotic pattern" spell. If they have a local set to 7
      seconds, and am targeting the same location, it will carry on with the
      AOE effects.

    AOE checks the integer which is needed on the caster, and that they are not
    dead or invalid.

    This now uses the same things as Calm Emotions will.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_CONCENTR"

void main()
{
    // If we are concentrating, and cast at the same spot, we set the integer
    // for the hypnotic pattern up by one.
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();

    // Check the function
    if(PHS_ConcentatingContinueCheck(PHS_SPELL_HYPNOTIC_PATTERN, lTarget, PHS_AOE_TAG_PER_HYPNOTIC_PATTERN, 18.0, oCaster)) return;

    // Else, new spell!

    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_HYPNOTIC_PATTERN)) return;

    // Declare major variables
    object oTarget;
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    float fDelay, fDistance;
    int bContinueLoop, nCurrentHD, nLow;
    object oLowest;
    string sSpellLocal = "PHS_SPELL_HYPN_PATT" + ObjectToString(OBJECT_SELF);

    // We set the "Concentration" thing to 18 seconds
    // This also returns the array we set people affected to, and does the new
    // action.
    string sArrayLocal = PHS_ConcentatingStart(PHS_SPELL_HYPNOTIC_PATTERN, nCasterLevel, lTarget, PHS_AOE_PER_HYPNOTIC_PATTERN, 18.0, oCaster);
    int nArrayCount;

    // Limit caster bonus to +10
    int nBonus = PHS_LimitInteger(nCasterLevel, 10);

    // 2d4 + Caster level of HD creatures affected
    int nHD = PHS_MaximizeOrEmpower(4, 2, nMetaMagic, nBonus);

    // Note on duration: We apply it permamently, however, it will definatly
    // be removed by the AOE.

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_STUN);
    effect eStun = EffectStunned();
    effect eStunDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eStun, eStunDur);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 3.33, lTarget, TRUE);
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
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 3.33, lTarget, TRUE);
        while(GetIsObjectValid(oTarget))
        {
            // Already affected check
            if(!GetLocalInt(oTarget, sSpellLocal))
            {
                // Make faction check to ignore allies
                if(!GetIsReactionTypeFriendly(oTarget) &&
                // Make sure they are not immune to spells
                   !PHS_TotalSpellImmunity(oTarget) &&
                // Must be able to see
                    PHS_GetCanSee(oTarget))
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
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, 3.33, lTarget, TRUE);
        }
        // Check to see if oLowest returned a valid object
        if(GetIsObjectValid(oLowest))
        {
            // Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oLowest, PHS_SPELL_HYPNOTIC_PATTERN);

            // Set a local int to make sure the creature is not used twice in the
            // pass.  Destroy that variable in 0.1 seconds to remove it from
            // the creature
            SetLocalInt(oLowest, sSpellLocal, TRUE);
            DelayCommand(0.1, DeleteLocalInt(oLowest, sSpellLocal));

            // Delay based on range
            fDelay = fDistance/20;

            // Make SR check
            if(!PHS_SpellResistanceCheck(oCaster, oLowest, fDelay) &&
               !PHS_ImmunityCheck(oLowest, IMMUNITY_TYPE_STUN, fDelay) &&
               !PHS_ImmunityCheck(oLowest, IMMUNITY_TYPE_MIND_SPELLS, fDelay))
            {
                // Will saving throw
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oLowest, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay))
                {
                    // Add to the array
                    nArrayCount++;
                    SetLocalObject(oCaster, sArrayLocal + IntToString(nArrayCount), oLowest);

                    // Apply effects
                    PHS_ApplyPermanentAndVFX(oLowest, eVis, eLink);
                }
            }
        }
        // Remove the HD of the creature from the total
        nHD = nHD - GetHitDice(oLowest);
        oLowest = OBJECT_INVALID;
    }
    // Set the max people in the array
    SetLocalInt(oCaster, sArrayLocal, nArrayCount);
}
