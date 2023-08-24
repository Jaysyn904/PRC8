//:://////////////////////////////////////////////
//:: Factotum Cunning Brilliance cast script
//:: prc_fact_cunbri
//:://////////////////////////////////////////////
/*
    @author Stratovarius - 2021.11.05
*/

#include "prc_inc_factotum"

void main()
{
    object oPC = OBJECT_SELF;
    if (ExpendInspiration(oPC, 4))
    {
    	int nAbil = GetFactotumSlot(oPC);
		FactotumTriggerAbil(oPC, nAbil);
    }
    else
    {
    	IncrementRemainingFeatUses(oPC, StringToInt(Get2DACache("spells", "FeatID", PRCGetSpellId())));
    }
}