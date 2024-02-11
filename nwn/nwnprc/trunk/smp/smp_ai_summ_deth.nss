/*:://////////////////////////////////////////////
//:: Name Summon Monster - On Death
//:: FileName SMP_AI_Summ_Deth
//:://////////////////////////////////////////////
    On Death.

    Does an unsummoned visual effect, and instantly destroys us.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_AI_INCLUDE"

void main()
{
    // Delcare major variables
    object oSelf = OBJECT_SELF;

    // Set ourselves to be destroyable (just in case) and destroy ourselves
    // instantly.
    SetIsDestroyable(TRUE, FALSE, FALSE);
    DestroyObject(OBJECT_SELF);
}
