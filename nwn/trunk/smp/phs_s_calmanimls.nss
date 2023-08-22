/*:://////////////////////////////////////////////
//:: Spell Name Calm Animals
//:: Spell FileName PHS_S_CalmAnimls
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Animal 1, Drd 1, Rgr 1
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Targets: Hostile Animals in a 5M-radius sphere
    Duration: 1 min./level
    Saving Throw: Will negates; see text
    Spell Resistance: Yes

    This spell soothes and quiets animals, rendering them docile and harmless.
    Only ordinary animals (those with Intelligence scores of 3) can be affected
    by this spell. All the subjects must be within a 5M-radius sphere. The
    maximum number of Hit Dice of animals you can affect is equal to 2d4 +
    caster level. A dire animal or an animal trained to attack or guard is
    allowed a saving throw; other animals are not.

    The affected creatures remain where they are and do not attack or flee.
    They are not helpless and defend themselves normally if attacked. Any
    threat breaks the spell on the threatened creatures.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This spell Confuses animals, making them stand still basically (not
    attack or flee).

    However, if they have a valid last hostile actor, they will have this
    effect removed.

    For all "Calming" spells, or those which are broken after being attacked,
    a new hostile actor will apply 1 damage and then heal it (or the other
    way around to not kill it).

    If a creature fails its save, the spell is considered "Friendly" and so the
    last hostile actor isn't then replaced with the caster again.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"
#include "PHS_INC_CALM"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck()) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    string sSpellLocal = "PHS_SPELL_CALM_ANIMALS" + ObjectToString(OBJECT_SELF);
    // 2d4 + Caster Leve HD to affect with this spell
    int nHD = PHS_MaximizeOrEmpower(4, 2, nMetaMagic, nCasterLevel);
    float fDistance, fDelay;
    int bContinueLoop, nCurrentHD, nLow, nRace, bSaveResult;
    object oLowest;

    // Duration - 1 minute/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eStop = EffectCutsceneImmobilize();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eStop, eCessate);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
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
        //Get the first creature in the spell area
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, lTarget, TRUE);
        while(GetIsObjectValid(oTarget))
        {
            // Already affected check
            if(!GetLocalInt(oTarget, sSpellLocal))
            {
                nRace = GetRacialType(oTarget);
                // Make faction check to ignore allies
                if(!GetIsReactionTypeFriendly(oTarget) &&
                // Make sure they are not immune to spells
                   !PHS_TotalSpellImmunity(oTarget) &&
                // Must be alive
                    PHS_GetIsAliveCreature(oTarget) &&
                // Must be an animal
                   (nRace == RACIAL_TYPE_ANIMAL ||
                    nRace == RACIAL_TYPE_MAGICAL_BEAST))
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
            // Set a local int to make sure the creature is not used twice in the
            // pass.  Destroy that variable in 0.1 seconds to remove it from
            // the creature
            SetLocalInt(oLowest, sSpellLocal, TRUE);
            DelayCommand(0.1, DeleteLocalInt(oLowest, sSpellLocal));

            // Delay based on range
            fDelay = fDistance/20;

            // Make SR check
            if(!PHS_SpellResistanceCheck(oCaster, oLowest, fDelay) &&
               !PHS_ImmunityCheck(oLowest, IMMUNITY_TYPE_MIND_SPELLS, fDelay))
            {
                // Do they get a save?
                bSaveResult = FALSE;
                nRace = GetRacialType(oTarget);

                // If magical beast, yes.
                if(nRace == RACIAL_TYPE_MAGICAL_BEAST)
                {
                    // Will saving throw
                    bSaveResult = PHS_SavingThrow(SAVING_THROW_WILL, oLowest, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay);
                }
                // Check result.
                if(bSaveResult == FALSE)
                {
                    // Friendly Signal Spell Cast At.
                    PHS_SignalSpellCastAt(oLowest, PHS_SPELL_CALM_ANIMALS, FALSE);

                    // Apply effects
                    PHS_SetCalm(oLowest);
                    PHS_ApplyDurationAndVFX(oLowest, eVis, eLink, fDuration);
                }
                else
                {
                    // Hostile Signal Spell Cast At.
                    PHS_SignalSpellCastAt(oLowest, PHS_SPELL_CALM_ANIMALS);
                }
            }
        }
        // Remove the HD of the creature from the total
        nHD = nHD - GetHitDice(oLowest);
        oLowest = OBJECT_INVALID;
    }
}
