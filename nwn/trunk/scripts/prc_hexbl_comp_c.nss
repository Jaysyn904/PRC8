/**
 * Hexblade: Dark Companion
 * 14/09/2005
 * Stratovarius
 * Type of Feat: Class Specific
 * Prerequisite: Hexblade level 4.
 * Specifics: The Hexblade gains a dark companion. It is an illusionary creature that does not engage in combat, but all monsters near it take a -2 penalty to AC and Saves.
 * Use: Selected.
 */

#include "prc_class_const"

void main()
{
    //Declare major variables
    object oPC = GetAreaOfEffectCreator();
    int nPen = GetLevelByClass(CLASS_TYPE_HEXBLADE, oPC) > 20 ? 4 : 2;
    effect eLink = EffectSavingThrowDecrease(SAVING_THROW_ALL, nPen);
           eLink = EffectLinkEffects(eLink, EffectACDecrease(nPen));

    object oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
        // Apply the loss
        // Doesn't affect allies
        if(!GetIsFriend(oTarget, oPC))
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }
}