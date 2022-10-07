// Killoren Aspect of the Ancient

#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    
    int nBonus = GetHitDice(oPC);
    
    if (GetHasFeat(FEAT_KILLOREN_ANCIENT, oPC)) nBonus += 4;

    effect eLore = SupernaturalEffect(EffectSkillIncrease(SKILL_LORE, nBonus));
    SetLocalInt(oPC, "KillorenAncient", TRUE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLore, oPC, HoursToSeconds(24));
    
    DecrementRemainingFeatUses(oPC, FEAT_KILLOREN_ASPECT_H);
    DecrementRemainingFeatUses(oPC, FEAT_KILLOREN_ASPECT_D);
}