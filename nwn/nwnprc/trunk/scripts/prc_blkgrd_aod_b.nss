#include "prc_feat_const"

void main()
{
    object oPC = GetAreaOfEffectCreator();
    int nPen = 2;
    if (GetHasFeat(FEAT_IMPROVED_AURA_OF_DESPAIR, oPC)) nPen += 2;
    effect eLink = EffectSavingThrowDecrease(SAVING_THROW_ALL, nPen);

    object oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
        // Apply the Aura of Despair penalties.
        // Doesn't affect allies
        if(!GetIsFriend(oTarget, oPC))
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }
}