/*:://////////////////////////////////////////////
//:: Spell Name Color Spray
//:: Spell FileName PHS_S_ColorSpray
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Illusion (Pattern) [Mind-Affecting]
    Level: Sor/Wiz 1
    Components: V, S, M
    Casting Time: 1 standard action
    Range: 15 ft.
    Area: Cone-shaped burst
    Duration: Instantaneous; see text
    Saving Throw: Will negates
    Spell Resistance: Yes

    A vivid cone of clashing colors springs forth from your hand, causing
    creatures to become stunned, perhaps also blinded, and possibly knocking
    them unconscious.

    Each creature within the cone is affected according to its Hit Dice. Effects
    are concurrent.

    2 HD or less: The creature is put asleep for 2d4 rounds, blinded for 3d4
        rounds and stunned for 3d4 + 1 rounds. (Only living creatures are
        put to sleep.)
    3 or 4 HD: The creature is blinded for 1d4 rounds, stunned for 1d4 + 1rounds.
    5 or more HD: The creature is stunned for 1 round.

    Sightless creatures are not affected by color spray.

    Material Component: A pinch each of powder or sand that is colored red,
    yellow, and blue.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell says.

    The odd "then blinded and stunned..." bits really just means the blinind
    and stunning lasts for longer.

    Apply the 3 (2, or even 1) effect seperatly, and within DelayCommand's so
    that they can all be applied seperatly.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Apply the color spray effects to oTarget. Will save ETC.
void ColorSprayEffects(object oTarget, object oCaster, int nSpellSaveDC, int nMetaMagic, effect eSleep, effect eBlind, effect eStun);

// Apply the Sleep, Blind and Stun
void ApplySleepBlindStun(object oTarget, effect eSleep, float fSleep, effect eBlind, float fBlind, effect eStun, float fStun);
// Apply the Blind and Stun
void ApplyBlindStun(object oTarget, effect eBlind, float fBlind, effect eStun, float fStun);
// Apply the Stun
void ApplyStun(object oTarget, effect eStun, float fStun);

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_COLOR_SPRAY)) return;

    // Delcare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Durations are different for each HD.

    // Delcare effects
    // Sleep
    effect eSleep = EffectSleep();
    effect eSleepVis = EffectVisualEffect(VFX_IMP_SLEEP);
    // Blindness
    effect eBlind = EffectBlindness();
    effect eBlindVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eBlindDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    // Stun
    effect eStun = EffectStunned();
    effect eStunVis = EffectVisualEffect(VFX_IMP_STUN);
    effect eStunDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);

    // Links
    effect eSleepLink = EffectLinkEffects(eSleep, eSleepVis);
    effect eBlindLink = EffectLinkEffects(eBlind, eBlindVis);
    eBlindLink = EffectLinkEffects(eBlindLink, eBlindDur);
    effect eStunLink = EffectLinkEffects(eStun, eStunVis);
    eStunLink = EffectLinkEffects(eStunLink, eStunDur);

    // Loop targets in cone (Use width of 10.0 for range 5)
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        // Check reaction type
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Signal event
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_COLOR_SPRAY);

            // Check If they can see!
            if(PHS_GetCanSee(oTarget))
            {
                // Do spray effects
                ColorSprayEffects(oTarget, oCaster, nSpellSaveDC, nMetaMagic, eSleepLink, eBlindLink, eStunLink);
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, TRUE);
    }
}

// Apply the color spray effects to oTarget. Will save ETC.
void ColorSprayEffects(object oTarget, object oCaster, int nSpellSaveDC, int nMetaMagic, effect eSleep, effect eBlind, effect eStun)
{
    // Get HD
    int nHD = GetHitDice(oTarget);
    float fDelay = GetDistanceBetween(oCaster, oTarget)/20;
    float fSleep, fBlind, fStun;

    // Spell resistance and immunity
    if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay) &&
       !PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS, fDelay, oCaster))
    {
        // Mind-affecting, will Save
        if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay))
        {
            // Apply effects based on level
            // 2 HD or less: The creature is made unconscious for 2d4 rounds, is blinded
            // for 3d4 rounds, and stunned for 3d4 + 1 rounds. (Only living creatures are
            // knocked unconsciously asleep.)
            if(nHD <= 2)
            {
                // Sleep - 2d4
                fSleep = PHS_GetRandomDuration(PHS_ROUNDS, 4, 2, nMetaMagic);
                // Blind - 3d4
                fBlind = PHS_GetRandomDuration(PHS_ROUNDS, 4, 3, nMetaMagic);
                // Stun - 3d4 + 1
                fStun = PHS_GetRandomDuration(PHS_ROUNDS, 4, 3, nMetaMagic, 1);

                // Delay application
                DelayCommand(fDelay, ApplySleepBlindStun(oTarget, eSleep, fSleep, eBlind, fBlind, eStun, fStun));
            }
            // 3 or 4 HD: The creature is blinded for 1d4 rounds, and stunned for 1d4 + 1
            // rounds.
            else if(nHD <= 4)
            {
                // Blind - 1d4
                fBlind = PHS_GetRandomDuration(PHS_ROUNDS, 4, 1, nMetaMagic);
                // Stun - 1d4 + 1
                fStun = PHS_GetRandomDuration(PHS_ROUNDS, 4, 1, nMetaMagic, 1);

                // Delay application
                DelayCommand(fDelay, ApplyBlindStun(oTarget, eBlind, fBlind, eStun, fStun));
            }
            // 5 or more HD: The creature is stunned for 1 round.
            else
            {
                // Stun - 1 round
                fStun = PHS_GetDuration(PHS_ROUNDS, 1, nMetaMagic);

                // Delay application
                DelayCommand(fDelay, ApplyStun(oTarget, eStun, fStun));
            }
        }
    }
}

// Apply the Sleep, Blind and Stun
void ApplySleepBlindStun(object oTarget, effect eSleep, float fSleep, effect eBlind, float fBlind, effect eStun, float fStun)
{
    // Apply them all.
    PHS_ApplyDuration(oTarget, eSleep, fSleep);
    PHS_ApplyDuration(oTarget, eBlind, fBlind);
    PHS_ApplyDuration(oTarget, eStun, fStun);
}
// Apply the Blind and Stun
void ApplyBlindStun(object oTarget, effect eBlind, float fBlind, effect eStun, float fStun)
{
    // Apply them all.
    PHS_ApplyDuration(oTarget, eBlind, fBlind);
    PHS_ApplyDuration(oTarget, eStun, fStun);
}
// Apply the Stun
void ApplyStun(object oTarget, effect eStun, float fStun)
{
    // Apply it
    PHS_ApplyDuration(oTarget, eStun, fStun);
}
