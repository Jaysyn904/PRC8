#include "psi_inc_psifunc"

void main()
{
    // Don't stack
    PRCRemoveSpellEffects(POWER_DANGERSENSE, OBJECT_SELF, OBJECT_SELF);
    SetLocalInt(OBJECT_SELF, "PsyRogueDanger", TRUE);
    UsePower(POWER_DANGERSENSE, CLASS_TYPE_INVALID, TRUE, 20);
    DeleteLocalInt(OBJECT_SELF, "PsyRogueDanger");
}