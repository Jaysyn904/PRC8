#include "x2_inc_spellhook"
#include "prc_inc_scry"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ILLUSION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/
    if (!X2PreSpellCastCode())
    {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    int nDuration = GetLevelByTypeArcane();

    SetLocalInt(OBJECT_SELF, "ScryCasterLevel", nDuration);
    SetLocalInt(OBJECT_SELF, "ScrySpellId", MYST_EPHEMERAL_IMAGE); // This is deliberate, lets things happen based on Project Image
    SetLocalInt(OBJECT_SELF, "ScrySpellDC", -1);
    SetLocalFloat(OBJECT_SELF, "ScryDuration", RoundsToSeconds(nDuration));  
     
    ScryMain(OBJECT_SELF, OBJECT_SELF);

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Getting rid of the local integer storing the spellschool name
}
