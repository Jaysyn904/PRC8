// Written by Stratovarius
// Ends scrying.

#include "prc_inc_scry"

void main()
{
  object oPC = OBJECT_SELF;
  object oCopy = GetLocalObject(oPC, COPY_LOCAL_NAME);
  // Cancel out if the PC isn't scrying.
  if (!GetIsScrying(oPC)) return;
  FloatingTextStringOnCreature("Ending All Scrying Spells", oPC, FALSE);
  if (DEBUG) DoDebug("prc_scry_end: End Scry SpellId: " + IntToString(GetLocalInt(oPC, "ScrySpellId")));
  DoScryEnd(oPC, oCopy);
}