//::///////////////////////////////////////////////
//:: Metabreath options conversation
//:: prc_metabrth_con
//:://////////////////////////////////////////////
/** @file
    Starts the Metabreath Config Dialog


    @author Fox
    @date   Created  - 2008.1.23
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_dynconv"

void main()
{
    if(DEBUG) DoDebug("prc_metabrth_con: performing conversation for " + IntToString(GetSpellId()));
    SetLocalInt(OBJECT_SELF, "MetabreathSpellId", GetSpellId());
    AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
    StartDynamicConversation("prc_metabrth_cnv", OBJECT_SELF, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE);
}
