//::///////////////////////////////////////////////
//:: Strength of Two
//:: psi_g_stroftwo
//::///////////////////////////////////////////////
/*
    Expends the Psionic Focus and 1 PP for 
    +4 additional bonus to Will saves for 1 round
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: 2008.2.14
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"
#include "psi_inc_psifunc"


void main()
{
    object oManifester = OBJECT_SELF;
    
    if(!UsePsionicFocus(oManifester)){
        SendMessageToPC(oManifester, "You must be psionically focused to use this feat");
        return;
    }

    //subtract 1 PP, add 4 to Will saves for 1 round
    
    //Don't need to check PP total, you can only have focus if you have PP
    LosePowerPoints(oManifester, 1);
    
    effect eWillBonus = EffectSavingThrowIncrease(SAVING_THROW_WILL, 5);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWillBonus, oManifester, RoundsToSeconds(1));
}
