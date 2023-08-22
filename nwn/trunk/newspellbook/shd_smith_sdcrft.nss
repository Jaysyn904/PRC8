#include "inc_dynconv"
void main()
{
		AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
        StartDynamicConversation("shd_smith_craft", OBJECT_SELF, DYNCONV_EXIT_NOT_ALLOWED, TRUE, TRUE, OBJECT_SELF);
}