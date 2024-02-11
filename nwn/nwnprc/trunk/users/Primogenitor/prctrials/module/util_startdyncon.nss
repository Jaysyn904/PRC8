
#include "prc_alterations"
#include "inc_dynconv"

void main()
{
    string sConv = GetLocalString(OBJECT_SELF, "DynamicConvResRef");
    object oPC = GetLastUsedBy();
    StartDynamicConversation(sConv, oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE,
        TRUE, FALSE, OBJECT_SELF);
}
