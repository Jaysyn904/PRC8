/*:://////////////////////////////////////////////
//:: Spell Name Earthquake
//:: Spell FileName PHS_S_Earthquake
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Earth]
    Level: Clr 8, Destruction 8, Drd 8, Earth 7
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Long (40M)
    Area: 26.67-M.-radius spread (S)
    Duration: 1 round
    Saving Throw: See text
    Spell Resistance: No

    When you cast earthquake, an intense but highly localized tremor rips the
    ground. The shock knocks creatures down, collapses structures, opens cracks
    in the ground, and more. The specific effect of an earthquake spell depends
    on the nature of the terrain where it is cast.

    Natural Interior (cave) Man-Made interior (building): The spell collapses
    the roof or bring down supports and stonework, dealing 8d6 points of
    bludgeoning damage to any creature caught under the cave-in (Reflex DC 15
    half, and no pinning) and pinning that creature beneath the rubble (see
    below).

    Open Ground: Each creature standing in the area must make a DC 15 Reflex
    save or fall down for the round. Fissures open in the earth, and every
    creature on the ground has a 25% chance to fall into one (Reflex DC 20 to
    avoid a fissure). At the end of the spell, all fissures grind shut, killing
    any creatures still trapped within.

    Pinned beneath Rubble: Any creature pinned beneath rubble takes 1d6 points
    of bludgeoning damage per minute while pinned. A pinned creature is
    effectivly knocked down, and requires a DC 25 Strength Check to escape,
    each round.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    A massive AOE, and requires several saves.

    The effect depends on the status of the area - and if it can be collapsed
    at all! (no collapse = no damage, pinning or fissures, but the 1 round
    of being stopped still applies)

    The pinning is done via. delay command.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Call this to start pin checks
void WrapperDelayRemoval(float fDelay, object oTarget);
// This is called from WrapperDelayRemoval
// Does damage when nLastRound + 1 (the current round) is 10.
void PinCheck(int nSpellId, int nTimesCast, int nLastRound, object oTarget);

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_EARTHQUAKE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    object oArea = GetArea(oCaster);
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int bIndoors = GetIsAreaInterior(oArea);
    int bNatural = GetIsAreaNatural(oArea);
    //int bAboveGround = GetIsAreaAboveGround(oArea);
    int nEffect;
    int nDam;
    float fDelay;
    // 1 Round of duration
    float f1Round = 6.0;

    // Check if area can be earthquaked
    if(GetLocalInt(oArea, "PHS_EARTHQUAKE_IMMUNE")) return;

    // Declare Effects
    effect eVis;// = EffectVisualEffect(VFX_IMP_ROCKEXPLODE);
    effect eImpact;// = EffectVisualEffect(nVFX);
    effect eDeath = EffectDeath();
    effect ePin = EffectKnockdown();
    effect eDur = EffectVisualEffect(VFX_DUR_STONEHOLD);

    // Link effects
    effect eLink = EffectLinkEffects(ePin, eDur);

    // Get the right VFX based on indoors/outdoors
    if(bIndoors == TRUE)
    {
        // Declare indoor visual effects
        eVis = EffectVisualEffect(VFX_IMP_ROCKEXPLODE);
        if(bNatural == TRUE)
        {
            eImpact = EffectVisualEffect(PHS_VFX_FNF_EARTHQUAKE_INSIDE_NATURAL);
        }
        else
        {
            eImpact = EffectVisualEffect(PHS_VFX_FNF_EARTHQUAKE_INSIDE_NOT_NATURAL);
        }
    }
    else
    {
        // Declare outdoor visual effects
        eVis = EffectVisualEffect(PHS_VFX_IMP_EARTHQUAKE_FISSURE);
        eImpact = EffectVisualEffect(PHS_VFX_FNF_EARTHQUAKE_OUTSIDE);
    }

    // Apply AOE visual
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Get all targets in a sphere, 26.67M radius, creature objects.
    // - No LOS needed. This affects anyone in the AOE.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 26.67, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    // Loop targets
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            // Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_EARTHQUAKE);

            // Get a random small delay
            fDelay = PHS_GetRandomDelay(0.2, 1.6)/10;

            // If interior, we do damage and pinning
            if(bIndoors)
            {
                // Roll damage for each target. 8d6
                nDam = PHS_MaximizeOrEmpower(6, 8, nMetaMagic);

                // Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDam = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, nDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster, fDelay);

                // Need to do damage to apply visuals and pinning.
                if(nDam > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_BLUDGEONING));

                    // Apply the pinning
                    DelayCommand(fDelay, PHS_ApplyPermanent(oTarget, eDur));

                    // Delay a pin check
                    WrapperDelayRemoval(fDelay + f1Round, oTarget);
                }
            }
            // Else, exterior, special fissures.
            else
            {
    // Open Ground: Each creature standing in the area must make a DC 15 Reflex
    // save or fall down for the round. Fissures open in the earth, and every
    // creature on the ground has a 25% chance to fall into one (Reflex DC 20 to
    // avoid a fissure). At the end of the spell, all fissures grind shut, killing
    // any creatures still trapped within.

                // First: 25% of a fissure. If they die, they die!
                if(d100() <= 25)
                {
                    // Fissure!
                    PHS_ApplyLocationVFX(GetLocation(oTarget), eVis);

                    // Reflex save DC 20 or die
                    if(!PHS_SavingThrow(SAVING_THROW_REFLEX, oTarget, 20, SAVING_THROW_TYPE_NONE, oCaster, fDelay))
                    {
                        // Apply knockdown for 6 seconds, then do the death.
                        DelayCommand(fDelay, PHS_ApplyDuration(oTarget, ePin, f1Round - fDelay));

                        // Delay death
                        DelayCommand(f1Round, PHS_ApplyInstant(oTarget, eDeath));
                    }
                }
                // Failing that, we will do a reflex save just to stay upright
                else if(!PHS_SavingThrow(SAVING_THROW_REFLEX, oTarget, 15, SAVING_THROW_TYPE_NONE, oCaster, fDelay))
                {
                    // Apply knockdown for 6 seconds
                    DelayCommand(fDelay, PHS_ApplyDuration(oTarget, ePin, f1Round - fDelay));
                }
            }
        }
        // Get Next Target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 26.67, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }
}

void WrapperDelayRemoval(float fDelay, object oTarget)
{
    int nSpell = GetSpellId();
    int nCastTimes = GetLocalInt(OBJECT_SELF, "PHS_TIMES_CAST" + IntToString(nSpell));
    nCastTimes++; // Add one to cast times
    SetLocalInt(OBJECT_SELF, "TIMES_CAST" + IntToString(nSpell), nCastTimes);
    DelayCommand(fDelay, PinCheck(nSpell, nCastTimes, 0, oTarget));
}

void PinCheck(int nSpellId, int nTimesCast, int nLastRound, object oTarget)
{
    // Add one to current rounds
    int nThisRound = nLastRound + 1;

    if(!GetHasSpellEffect(nSpellId, oTarget) ||
       GetLocalInt(oTarget, "PHS_TIMES_CAST" + IntToString(nSpellId)) != nTimesCast ||
       PHS_AbilityCheck(oTarget, ABILITY_STRENGTH, 25))
    {
        effect eCheck = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eCheck))
        {
            if(GetEffectSpellId(eCheck) == nSpellId)
            {
                RemoveEffect(oTarget, eCheck);
            }
            eCheck = GetNextEffect(oTarget);
        }
    }
    // Every 10th round, we do damage
    else if(nThisRound == 10)
    {
        // reset it to 0
        nThisRound = 0;

        // Do damage
        PHS_ApplyDamageToObject(oTarget, d6(), DAMAGE_TYPE_BLUDGEONING);

        // Another delay
        DelayCommand(6.0, PinCheck(nSpellId, nTimesCast, nThisRound, oTarget));
    }
    else
    {
        // Another delay
        DelayCommand(6.0, PinCheck(nSpellId, nTimesCast, nThisRound, oTarget));
    }
}
