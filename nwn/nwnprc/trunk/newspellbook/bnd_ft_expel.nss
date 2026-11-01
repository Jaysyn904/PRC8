#include "bnd_inc_bndfunc"
#include "inc_dynconv"

void main()
{
    object oBinder = OBJECT_SELF;
    if (GetHasFeat(FEAT_EPIC_EXPEL_VESTIGE, oBinder))
        IncrementRemainingFeatUses(oBinder, FEAT_EXPEL_VESTIGE);
    AssignCommand(oBinder, ClearAllActions(TRUE));
    StartDynamicConversation("bnd_expelcnv", oBinder, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, TRUE, oBinder);
}
