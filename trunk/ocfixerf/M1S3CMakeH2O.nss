#include "prc_inc_castlvl"

void main()
{
    object oPC = GetLastOpenedBy();
    if(!GetIsObjectValid(GetItemPossessedBy(OBJECT_SELF, "M1S03IFLASK"))
    && !GetIsObjectValid(GetItemPossessedBy(oPC, "M1S03IFLASK")))
    {
        int i, nClass;
        for(i = 1; i <= 3; i++)
        {
            nClass = GetClassByPosition(i, oPC);
            if(GetIsArcaneClass(nClass))
            {
                CreateItemOnObject("M1S03IFLASK", OBJECT_SELF);
                return;
            }
        }
    }
}