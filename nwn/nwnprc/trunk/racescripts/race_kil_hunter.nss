// Killoren Aspect of the Hunter

#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    
    itemproperty iKill = PRCItemPropertyBonusFeat(IP_CONST_FEAT_BLOODED);
    AddItemProperty(DURATION_TYPE_TEMPORARY, iKill, oSkin, HoursToSeconds(24));

    effect eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_HIDE, 2), EffectSkillIncrease(SKILL_MOVE_SILENTLY, 2));
           eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_LISTEN, 2), eLink);
    effect eLore = SupernaturalEffect(eLink);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLore, oPC, HoursToSeconds(24));
    
    DecrementRemainingFeatUses(oPC, FEAT_KILLOREN_ASPECT_A);
    DecrementRemainingFeatUses(oPC, FEAT_KILLOREN_ASPECT_D);
    SetLocalInt(oPC, "KillorenHunter", TRUE);
}