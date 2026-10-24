#include "moonpath_inc"

void main()
{
    // Preserve the PRC/HakInstaller module-load chain. The portable path owns
    // its own controllers; single-player modules need no NWNX registration.
    ExecuteScript("hif_onmoduleload", OBJECT_SELF);

    SetLocalInt(GetModule(), MPATH_DEBUG_FLAG, FALSE);
    SetLocalInt(GetModule(), MPATH_ENFORCE_FLAG, TRUE);
    DeleteLocalInt(GetModule(), MPATH_DISABLE_FLAG);

    WriteTimestampedLogEntry(
        "[Moon Path] Portable spell, breath and ranged-attack protection enabled.");
}
