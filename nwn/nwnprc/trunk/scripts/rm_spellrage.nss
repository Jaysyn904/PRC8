#include "prc_inc_spells"

void ApplyFatigue(object oPC)
{
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(EffectFatigue(), eDur);

    eLink = ExtraordinaryEffect(eLink);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(5));
}

void main()
{
    object oPC = OBJECT_SELF;
    int iAC = 2;

    if(GetHasSpellEffect(SPELL_SPELL_RAGE, oPC))
    {
		PRCRemoveSpellEffects(SPELL_SPELL_RAGE, oPC, oPC);  
		IncrementRemainingFeatUses(oPC, FEAT_SPELL_RAGE); 
        return;
    }
    if(GetHasSpellEffect(SPELLABILITY_BARBARIAN_RAGE, oPC))
    {
        IncrementRemainingFeatUses(oPC, FEAT_SPELL_RAGE);
        FloatingTextStringOnCreature("You can't use Barbarian Rage and Spell Rage at the same time.", oPC, FALSE);
        return;
    }

    // Removes effects of being winded
    effect eWind = GetFirstEffect(oPC);
    while (GetIsEffectValid(eWind))
    {
        if (GetEffectType(eWind) == EFFECT_TYPE_ABILITY_DECREASE || GetEffectType(eWind) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
            if (GetEffectSpellId(eWind) == PRCGetSpellId())
                RemoveEffect(oPC, eWind);
        eWind = GetNextEffect(oPC);
    }

    // play a random voice chat instead of just VOICE_CHAT_BATTLECRY1
    int iVoiceConst = 0;
    int iVoice = d3(1);
    switch(iVoice)
    {
         case 1: iVoice = VOICE_CHAT_BATTLECRY1;
                 break;
         case 2: iVoice = VOICE_CHAT_BATTLECRY2;
                 break;
         case 3: iVoice = VOICE_CHAT_BATTLECRY3;
                 break;
    }
    PlayVoiceChat(iVoice);

    int nCon = 3 + GetAbilityModifier(ABILITY_CONSTITUTION);
    if(GetHasFeat(FEAT_EXTENDED_RAGE, oPC))
        nCon += 5;
    effect eAC = EffectACDecrease(iAC, AC_DODGE_BONUS);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eAC, eDur);
    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_SPELL_RAGE, FALSE));

    eLink = ExtraordinaryEffect(eLink);
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);

    if (nCon > 0)
    {
        PRCRemoveEffectsFromSpell(oPC, SPELL_SPELL_RAGE);
        IncrementRemainingFeatUses(oPC, FEAT_SPELL_FURY);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nCon));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
        if(!GetHasFeat(FEAT_TIRELESS_RAGE, oPC))
            DelayCommand(RoundsToSeconds(nCon), ApplyFatigue(oPC));
    }
}