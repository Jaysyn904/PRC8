#include "xchst_inc"

void main()
{
    // dismiss chest if player left the game or left chests area
    object oChest = OBJECT_SELF;
    if(GetArea(oChest) != GetArea(GetLocalObject(oChest, XCHST_OWN)))
    {
        DismissChest(oChest);
    }
}