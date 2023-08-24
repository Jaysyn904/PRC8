#include "prc_alterations"
#include "prc_inc_smite"

void main()
{
    //decrements and stuff is automatic

    DoSmite(OBJECT_SELF, PRCGetSpellTargetObject(), SMITE_TYPE_UNDEAD);
}

