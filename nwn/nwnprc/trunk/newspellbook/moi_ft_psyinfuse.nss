//::///////////////////////////////////////////////
//:: Psycarnum Blade spellscript
//:: moi_ft_psyblade
//:://////////////////////////////////////////////
/*
    To use this feat, you must expend your psionic focus. 
    For one round, the next soulmeld you invest essentia 
    into is filled with temporary essentia to its maximum 
    essentia capacity.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 22.01.2020
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"
#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    effect eDummy;

    if(!UsePsionicFocus(oMeldshaper))
    {
        SendMessageToPC(oMeldshaper, "You must be psionically focused to use this feat");
        return;
    }
    int nEssentia = GetMaxEssentiaCapacity(oMeldshaper, CLASS_TYPE_INCARNATE, -1);
    SetTemporaryEssentia(oMeldshaper, nEssentia);
    DelayCommand(6.0, SetTemporaryEssentia(oMeldshaper, nEssentia * -1));
}