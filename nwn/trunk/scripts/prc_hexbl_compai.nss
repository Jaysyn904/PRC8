/**
 * Hexblade: Dark Companion
 * 14/09/2005
 * Stratovarius
 * Type of Feat: Class Specific
 * Prerequisite: Hexblade level 4.
 * Specifics: The Hexblade gains a dark companion. It is an illusionary creature that does not engage in combat, but all monsters near it take a -2 penalty to AC and Saves.
 * Use: Selected.
 *
 * This just tells it to follow the master and do nothing else.
 */

#include "inc_debug"

void main()
{
    object oMaster = GetMaster();

    if(!GetIsObjectValid(oMaster))
    {
        SetIsDestroyable(TRUE, FALSE, FALSE);
        DestroyObject(OBJECT_SELF, 0.2);
    }

    // Forces it to move to the master's attack target so it take the penalty.
    if(GetIsInCombat(oMaster))
    {
        object oMove = GetAttackTarget(oMaster);
        if(GetIsObjectValid(oMove))
        {
            ClearAllActions(TRUE);
            ActionForceFollowObject(GetAttackTarget(oMaster), 1.0f);
        }
    }
    else
    {
        ClearAllActions(TRUE);
        ActionForceFollowObject(oMaster, 4.0f);
    }
}