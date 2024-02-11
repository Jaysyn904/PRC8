#include "prc_alterations"
#include "inc_prc_poly"

void main()
{
    object oPC = OBJECT_SELF;
    if (GetIsPC(oPC))
    {
        if (PRC_Polymorph_Check(oPC))
        {
            PRC_UnPolymorph(oPC);
        }
        else
        {
            PRC_Polymorph_ResRef(oPC, "nw_demon", TRUE);
        }
    }
}