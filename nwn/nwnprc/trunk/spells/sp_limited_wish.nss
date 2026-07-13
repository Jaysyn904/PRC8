//:: sp_limited_wish
 
#include "inc_dynconv"
 
void main()
{
    object oPC = OBJECT_SELF;
 
    int nClass = GetLastSpellCastClass();
    WriteTimestampedLogEntry("sp_limited_wish: storing LW_CastingClass=" + IntToString(nClass));
    SetLocalInt(oPC, "LW_CastingClass", nClass);
 
    StartDynamicConversation(
        "cv_limited_wish",
        oPC,
        DYNCONV_EXIT_ALLOWED_SHOW_CHOICE,
        TRUE,
        TRUE
    );
}