/*:://////////////////////////////////////////////
//:: Spell Name Rage
//:: Spell FileName PHS_S_Rage
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Brd 2, Sor/Wiz 3
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Targets: One ally/level within 10M (30-ft)
    Duration: Concentration + 1 round/level (D)
    Saving Throw: None
    Spell Resistance: Yes

    Each affected creature gains a +2 morale bonus to Strength and Constitution,
    a +1 morale bonus on Will saves, and a -2 penalty to AC. The effect is
    otherwise identical with a barbarian’s rage (ie cannot be dispelled) except
    that the subjects aren’t fatigued at the end of the rage.

    The effects last on targets for as long as you concentrate, plus one
    round/level.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    The rage is concentration based, and that is about all the special things
    about it - it does just apply the bonuses as normal (undispellable).
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
    if(PHS_ConcentatingContinueCheck(PHS_SPELL_RAGE, lTarget, PHS_AOE_TAG_PER_RAGE, 18.0, oCaster)) return;

    // Else, new spell!

    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_RAGE)) return;

    // Declare major variables
    object oTarget;
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCnt;
    float fDelay, fDistance;

    // Extra Duration in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // We set the "Concentration" thing to 18 seconds
    // This also returns the array we set people affected to, and does the new
    // action.
    string sArrayLocal = PHS_ConcentatingStart(PHS_SPELL_RAGE, 0, lTarget, PHS_AOE_PER_RAGE, fDuration);
    int nArrayCount;

    // Note on duration: We apply it permamently, however, it will definatly
    // be removed by the AOE.

    // Declare effects
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
    effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, 2);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, 1);
    effect eAC = EffectACDecrease(2, AC_DODGE_BONUS);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);

    // Link effects
    effect eLink = EffectLinkEffects(eStr, eCon);
    eLink = EffectLinkEffects(eLink, eSave);
    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Loop all allies in a 10M sphere, basically
    oTarget = oCaster;
    // 1 target/level, nearest to location within a huge radius
    while(GetIsObjectValid(oTarget) && nArrayCount < nCasterLevel &&
          GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) <= RADIUS_SIZE_FEET_30)
    {
        // Friendly check and that they do not have the effects of rage already
        if((oTarget == OBJECT_SELF || GetIsFriend(oTarget) ||
            GetFactionEqual(oTarget)) && !GetHasFeatEffect(FEAT_BARBARIAN_RAGE, oTarget))
        {
            // Get a random delay
            fDelay = PHS_GetRandomDelay(0.1, 0.9);

            // Add to the array
            nArrayCount++;
            SetLocalObject(oCaster, sArrayLocal + IntToString(nArrayCount), oTarget);

            // Signal the spell cast at event
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_RAGE, FALSE);

            // Remove this previous effects.
            PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_RAGE, oTarget);

            // Play voice chat
            DelayCommand(fDelay, PlayVoiceChat(VOICE_CHAT_BATTLECRY1, oTarget));

            // Apply effects and VFX to target
            DelayCommand(fDelay, PHS_ApplyPermanentAndVFX(oTarget, eVis, eLink));
        }
        // Get next target
        nCnt++;
        oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, nCnt);
    }
}
