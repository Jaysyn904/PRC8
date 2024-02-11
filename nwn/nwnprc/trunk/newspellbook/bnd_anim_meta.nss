#include "bnd_inc_bndfunc"

void main()
{
	object oBinder = OBJECT_SELF;
	if (GetBindCount(oBinder))
	{
    	AssignCommand(oBinder, ClearAllActions(TRUE));
   		StartDynamicConversation("bnd_anim_metacnv", oBinder, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oBinder);   
   	}
   	else 
   		IncrementRemainingFeatUses(oBinder, FEAT_ANIMA_VESTIGE_METAMAGIC);
}
