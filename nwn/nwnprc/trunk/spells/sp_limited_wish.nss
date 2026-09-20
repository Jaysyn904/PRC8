//:: sp_limited_wish
 
#include "inc_dynconv"
#include "prc_inc_spells"
 
void main()
{
    object oPC = OBJECT_SELF;

    if(!X2PreSpellCastCode()) return;
 
    int nClass = PRCGetLastSpellCastClass();
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
