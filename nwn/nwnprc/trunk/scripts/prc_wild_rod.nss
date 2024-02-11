#include "prc_inc_burn"

void main()
{
    object oPC = OBJECT_SELF;
    if(!BurnSpell(oPC))
        return;

    // Rod of Wonder        
    AssignCommand(oPC, ActionCastSpell(499));
}