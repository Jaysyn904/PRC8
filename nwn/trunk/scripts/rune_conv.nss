

#include "inc_dynconv"

void main()
{
    object oPC = OBJECT_SELF;
    StartDynamicConversation("rune_convb", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, oPC);
}
