#include "prc_inc_castlvl"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int i, nClass;
    for(i = 1; i <= 3; i++)
    {
        nClass = GetClassByPosition(i, oPC);
        if(GetIsArcaneClass(nClass))
        {
            return FALSE;
        }
    }
    return TRUE;
}
