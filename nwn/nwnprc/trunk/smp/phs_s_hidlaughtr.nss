/*:://////////////////////////////////////////////
//:: Spell Name Hideous Laughter
//:: Spell FileName PHS_S_HidLaughtr
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Brd 1, Sor/Wiz 2
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One creature; see text
    Duration: 1 round/level
    Saving Throw: Will negates
    Spell Resistance: Yes

    This spell afflicts the subject with uncontrollable laughter. It collapses
    into gales of manic laughter, falling prone. The subject can take no actions
    while laughing, but is not considered helpless. After the spell ends, it can
    act normally.

    A creature with an Intelligence score of 3 or lower is not affected. A
    creature whose race is different from the caster’s receives a +4 bonus on
    its saving throw, because humor doesn’t “translate” well.

    Material Component: Tiny tarts that are thrown at the target and a feather
    that is waved in the air.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Easy peasy.

    It does it similar to Bioware's, and plays an animation.

    It also has a random-timed lauging thing, like a Melfs recalled function.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Must still have the spells effect, and nSpellTimesCastOn integer must match, it
// will PlayVoiceChat(VOICE_CHAT_LAUGH, oTarget).
void Laugh(object oTarget, int nSpellTimesCastOn);

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_HIDEOUS_LAUGHTER)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration is 1 round/level.
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare Effects
    effect eVis = EffectVisualEffect(PHS_VFX_IMP_HIDEOUS_LAUGHTER);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eKnockdown = EffectKnockdown();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eMind, eKnockdown);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Must check reaction type for PvP
    if(!GetIsReactionTypeFriendly(oTarget) &&
    // Make sure they are not immune to spells
       !PHS_TotalSpellImmunity(oTarget))
    {
        // Always fire spell cast at event
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_HIDEOUS_LAUGHTER, TRUE);

        // Check spell resistance and immunities.
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            //Make Will Save to negate effect
            if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                // Make them laugh
                AssignCommand(oTarget, ClearAllActions());
                AssignCommand(oTarget, PlayVoiceChat(VOICE_CHAT_LAUGH));
                AssignCommand(oTarget, PlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING));

                // Apply VFX Impact and knockdown effect
                DelayCommand(3.0, PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration - 3.0));

                // Delay a laugh. Note: We also will set increment a spell cast
                // on integer on the target
                int nSpellTimesCastOn = PHS_IncreaseStoredInteger(oTarget, "PHS_SPELL_HEDIOUS_LAUGHTER_TIMES_CAST");
                // 6 second delay.
                DelayCommand(6.0, Laugh(oTarget, nSpellTimesCastOn));
            }
        }
    }
}

// Must still have the spells effect, and nSpellTimesCastOn integer must match, it
// will PlayVoiceChat(VOICE_CHAT_LAUGH, oTarget).
void Laugh(object oTarget, int nSpellTimesCastOn)
{
    if(GetHasSpellEffect(PHS_SPELL_HIDEOUS_LAUGHTER, oTarget) &&
       GetLocalInt(oTarget, "PHS_SPELL_HEDIOUS_LAUGHTER_TIMES_CAST") == nSpellTimesCastOn)
    {
        // Laugh
        PlayVoiceChat(VOICE_CHAT_LAUGH, oTarget);
        // Get a random delay
        float fDelay = IntToFloat(Random(50) + 1)/10 + 3.0;
        DelayCommand(fDelay, Laugh(oTarget, nSpellTimesCastOn));
        return;
    }
}
