//An example OnHB script for an invisible placeable to spawn a ground trap
#include "prc_alterations"
#include "prgt_inc"
void main()
{
    struct trap tTrap;
    //this will use 5 as the CR for the trap
    tTrap = CreateRandomTrap(5);
    //add code in here to change things if you want to
    //for example, to set the detect DC to be 25 use:
    //tTrap.nDetectDC = 25;
    PRGT_CreateTrapAtLocation(GetLocation(OBJECT_SELF), tTrap);
    DestroyObject(OBJECT_SELF);
}