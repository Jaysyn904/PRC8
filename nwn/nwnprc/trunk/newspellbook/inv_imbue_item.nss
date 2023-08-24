//:://////////////////////////////////////////////
//:: Imbue Item - Start crafting conversation
//:: inv_imbue_item
//:://////////////////////////////////////////////
/** @file
    Toggles imbue item flag

    @author Shane Hennessy
    @date   Modified - 2006.10.08 - rewritten by Ornedan - modified by Fox
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//#include "inc_dynconv"
//#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    int bImbue = !GetLocalInt(oPC, "UsingImbueItem");

    SetLocalInt(oPC, "UsingImbueItem", bImbue);
    if(bImbue)
        FloatingTextStringOnCreature("*Imbue Item On*", oPC);
    else
        FloatingTextStringOnCreature("*Imbue Item Off*", oPC);
}
