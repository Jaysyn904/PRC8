/*:://////////////////////////////////////////////
//:: Spell Name Hypnotism
//:: Spell FileName PHS_S_Hypnotism
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Brd 1, Sor/Wiz 1
    Components: V, S
    Casting Time: 1 round
    Range: Close (8M)
    Area: Several living enemy creatures in a 5M-radius sphere
    Duration: 2d4 rounds (D)
    Saving Throw: Will negates
    Spell Resistance: Yes

    Your gestures and droning incantation fascinate nearby creatures, causing
    them to stop and stare blankly at you. In addition, you can use their rapt
    attention to make your suggestions and requests seem more plausible. Roll
    2d4 to see how many total Hit Dice of creatures you affect. Creatures with
    fewer HD are affected before creatures with more HD. Only creatures that can
    see or hear you are affected, but they do not need to understand you to be
    fascinated.

    If you use this spell in combat, each target gains a +2 bonus on its saving
    throw.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Uses confusion effect.

    This will, in the confusion heartbeat, make them face the effect creator :-)

    Similar to sleep otherwise, and the +2 saving throw is true if the caster
    is in combat.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_HYPNOTISM)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    string sSpellLocal = "PHS_SPELL_HYPNOTISM" + ObjectToString(OBJECT_SELF);
    // 2d4 HD to affect with this spell
    int nHD = PHS_MaximizeOrEmpower(4, 2, nMetaMagic);
    float fDistance, fDelay;
    int bContinueLoop, nCurrentHD, nLow;
    object oLowest;
    int bSee, bHeard, bCanHear, bCanSee;

    // Alter nSpellSaveDC based on GetIsInCombat()
    if(GetIsInCombat(oCaster))
    {
        nSpellSaveDC -= 2;
    }

    // Duration in (2d4) rounds, per target
    float fDuration;// = PHS_GetRandomDuration(PHS_MINUTES, 4, 2, nMetaMagic);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eConfuse = EffectConfused();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eConfuse, eCessate);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_10);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, lTarget, TRUE);
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
        // Get the first creature in the spell area
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, lTarget, TRUE);
        while(GetIsObjectValid(oTarget))
        {
            bSee = GetObjectSeen(oCaster, oTarget);
            bHeard = GetObjectHeard(oCaster, oTarget);
            bCanHear = PHS_GetCanHear(oTarget);
            bCanSee = PHS_GetCanSee(oTarget);

            // Already affected check
            if(!GetLocalInt(oTarget, sSpellLocal))
            {
                // Make faction check to get enemies
                if(GetIsReactionTypeHostile(oTarget) &&
                // Make sure they are not immune to spells
                   !PHS_TotalSpellImmunity(oTarget) &&
                // Must be alive
                    PHS_GetIsAliveCreature(oTarget) &&
                // Must be able to see or hear the target, and in general!
                   ((bCanHear && bHeard) || (bCanSee && bSee)) &&
                // Cannot have the spell effects already
                    !GetHasSpellEffect(PHS_SPELL_HYPNOTISM, oTarget))
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
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, 5.0, lTarget, TRUE);
        }
        // Check to see if oLowest returned a valid object
        if(GetIsObjectValid(oLowest))
        {
            // Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oLowest, PHS_SPELL_HYPNOTISM);

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
                    // Get random duration
                    fDuration = PHS_GetRandomDuration(PHS_MINUTES, 4, 2, nMetaMagic);
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
