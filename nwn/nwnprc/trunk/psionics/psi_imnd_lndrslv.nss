//::///////////////////////////////////////////////
//:: Lend Resolve
//:: psi_imnd_lndrslv
//::///////////////////////////////////////////////
/*
    Allows a user to expend focus to give an ally a bonus on Will saves
    equal to the Iron Mind's class level. This lasts for 1 round.

    Using Lend Resolve requires expending psionic focus.
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 14.02.2006
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nIron = GetLevelByClass(CLASS_TYPE_IRONMIND, oPC);

    if(!UsePsionicFocus(oPC))
    {
        SendMessageToPC(oPC, "You must be psionically focused to use this feat");
        return;
    }
    
    // Add the AC as a will save bonus
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, nIron);
    // One round duration
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSave, oTarget, 6.0);

}