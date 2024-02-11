/*:://////////////////////////////////////////////
//:: Spell Name Awaken
//:: Spell FileName PHS_S_Awaken
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    This will awaken a tree (not in) or animal. Casting time is 24 hours!? well,
    is actually 10 rounds in NwN because it is a real time game.
    Will save of 10 + animals HD to suceeed.
    Awakened animal will be friendly, and will join your party as
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As it says (animals only).

    Permament duration and effects, like the spell says. Henchmen until it is
    attacked by the caster or released from its duty.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_AWAKEN)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Check we have the XP needed
    if(!PHS_ComponentXPCheck(250, oCaster)) return;

    // Remove the XP
    PHS_ComponentXPRemove(250, oCaster);

    // Check if the target is valid! (IE animal!)
    if(GetRacialType(oTarget) != RACIAL_TYPE_ANIMAL ||
       GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) >= 10)
    {
        SendMessageToPC(oCaster, "Your chosen target is either not an animal, or is already quite intelligent");
        return;
    }

    // Make sure they do not try and get another faction member's animal to come.
    if(GetIsObjectValid(GetMaster(oTarget)) && GetMaster(oTarget) != oCaster)
    {
        SendMessageToPC(oCaster, "You cannot awaken a creature who is summoned and not your own");
        return;
    }

    // Save DC is 10 + animals current HD
    int nWillDC = 10 + GetHitDice(oTarget);

    // Random Intelligence and charisma bonuses
    int nInt = PHS_MaximizeOrEmpower(6, 3, nMetaMagic);
    int nCha = PHS_MaximizeOrEmpower(3, 1, nMetaMagic);

    // Declare effects
    effect eVis = EffectVisualEffect(PHS_VFX_FNF_AWAKEN);
    effect eInt = EffectAbilityIncrease(ABILITY_INTELLIGENCE, nInt);
    effect eCha = EffectAbilityIncrease(ABILITY_CHARISMA, nCha);
    effect eAttack = EffectAttackIncrease(1);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects - they are just magical, mind you.
    effect eLink = EffectLinkEffects(eInt, eCha);
    eLink = EffectLinkEffects(eLink, eAttack);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Will save check
    if(PHS_NotSpellSavingThrow(SAVING_THROW_WILL, oCaster, nWillDC))
    {
        // Signal spell cast at
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_AWAKEN, FALSE);

        // Remove previous effects
        PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_AWAKEN, oTarget);

        // Apply VFX and permanent effect.
        PHS_ApplyPermanentAndVFX(oTarget, eVis, eLink);

        // Also add them as a henchmen if they can be
        if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS) &&
           !GetIsImmune(oTarget, IMMUNITY_TYPE_CHARM) &&
           !GetFactionEqual(oTarget, oCaster))
        {
            AddHenchman(oCaster, oTarget);
        }
    }
}
