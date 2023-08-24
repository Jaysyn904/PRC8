#include "true_inc_trufunc"
//#include "prc_alterations"
#include "inc_dynconv"

void main()
{
    object oTrueSpeaker = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();

    StartDynamicConversation("true_saynam_conv", oTrueSpeaker, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oTrueSpeaker);
}
