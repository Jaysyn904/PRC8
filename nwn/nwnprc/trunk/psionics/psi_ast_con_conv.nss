//::///////////////////////////////////////////////
//:: Astral Construct dialog start script
//:: psi_ast_con_conv
//:://////////////////////////////////////////////
/*
    Starts the Astral Construct options dialog
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 07.03.2005
//:://////////////////////////////////////////////
#include "psi_inc_core"

void main()
{
    //store the manifesting class for AC convo
    SetLocalInt(OBJECT_SELF, "AC_Class", GetManifestingClass());

    AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
    AssignCommand(OBJECT_SELF, ActionStartConversation(OBJECT_SELF, "psi_ast_con_conv", TRUE, FALSE));
}
