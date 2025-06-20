#include "prc_feat_const"

void main()
{
    object oPC = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    // Apply the Aura of Despair penalties to hostiles only.
    if (GetIsReactionTypeHostile(oTarget, oPC))
    {
        int nPen = 2;
        if (GetHasFeat(FEAT_IMPROVED_AURA_OF_DESPAIR, oPC)) nPen += 2;
        effect eLink = EffectSavingThrowDecrease(SAVING_THROW_ALL, nPen);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
    }
}


/* void main()
{
    object oPC = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    // Apply the Aura of Despair penalties.
    // Doesn't affect allies
    if(!GetIsFriend(oTarget, oPC))
    {
        int nPen = 2;
        if (GetHasFeat(FEAT_IMPROVED_AURA_OF_DESPAIR, oPC)) nPen += 2;
        effect eLink = EffectSavingThrowDecrease(SAVING_THROW_ALL, nPen);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
    }
} */