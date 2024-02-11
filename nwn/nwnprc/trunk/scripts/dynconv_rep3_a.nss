//:://////////////////////////////////////////////
//:: Dynamic Conversation: Reply chosen
//:: dynconv_rep3_a
//:://////////////////////////////////////////////
/** @file
    Runs the dynamic conversation script with
    reply value 3.

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"


void main()
{
    object oPC = GetPCSpeaker();
    _DynConvInternal_RunScript(oPC, 4); // Number passed is 1 greater than the actual, so that 0 can be used as a special case
}

