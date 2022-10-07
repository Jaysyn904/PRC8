/*:://////////////////////////////////////////////
//:: Spell Name Sleep
//:: Spell FileName PHS_S_Sleep
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Brd 1, Sor/Wiz 1
    Components: V, S, M
    Casting Time: 1 round
    Range: Medium (20M)
    Area: One or more living creatures within a 3.33-M.-radius burst
    Duration: 1 min./level
    Saving Throw: Will negates
    Spell Resistance: Yes

    A sleep spell causes a magical slumber to come upon 4 Hit Dice of creatures.
    Creatures with the fewest HD are affected first.

    Among creatures with equal HD, those who are closest to the spell’s point of
    origin are affected first. Hit Dice that are not sufficient to affect a
    creature are wasted.

    Sleeping creatures are helpless. Awakening a creature is a standard action,
    using your special character item to wake them.

    Sleep does not target unconscious creatures, constructs, or undead creatures.

    Material Component: A pinch of fine sand, rose petals, or a live cricket.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Uses an altered Bioware version to get the lowest HD. It also takes into
    account range.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SLEEP)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    string sSpellLocal = "PHS_SPELL_SLEEP" + ObjectToString(OBJECT_SELF);
    // 4 HD to affect with this spell
    int nHD = 4;
    float fDistance, fDelay;
    int bContinueLoop, nCurrentHD, nLow;
    object oLowest;

    // Duration in minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);
    effect eSleep = EffectSleep();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eSleep, eCessate);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_10);
    PHS_ApplyLocationVFX(lTarget, eImpact);

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
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, 3.33, lTarget, TRUE);
        }
        // Check to see if oLowest returned a valid object
        if(GetIsObjectValid(oLowest))
        {
            // Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oLowest, PHS_SPELL_SLEEP);

            // Set a local int to make sure the creature is not used twice in the
            // pass.  Destroy that variable in 0.1 seconds to remove it from
            // the creature
            SetLocalInt(oLowest, sSpellLocal, TRUE);
            DelayCommand(0.1, DeleteLocalInt(oLowest, sSpellLocal));

            // Delay based on range
            fDelay = fDistance/20;

            // Make SR check
            if(!PHS_SpellResistanceCheck(oCaster, oLowest, fDelay) &&
               !PHS_ImmunityCheck(oLowest, IMMUNITY_TYPE_SLEEP, fDelay) &&
               !PHS_ImmunityCheck(oLowest, IMMUNITY_TYPE_MIND_SPELLS, fDelay))
            {
                // Will saving throw
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oLowest, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay))
                {
                    // Apply effects
                    DelayCommand(fDelay, PHS_ApplyDurationAndVFX(oLowest, eVis, eLink, fDuration));
                }
            }
        }
        // Remove the HD of the creature from the total
        nHD = nHD - GetHitDice(oLowest);
        oLowest = OBJECT_INVALID;
    }
}
