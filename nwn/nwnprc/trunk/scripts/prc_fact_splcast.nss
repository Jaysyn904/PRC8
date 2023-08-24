//:://////////////////////////////////////////////
//:: Factotum Arcane Dilettante cast script
//:: prc_fact_splcast
//:://////////////////////////////////////////////
/*
    @author Stratovarius - 2019.12.21
*/

#include "prc_inc_factotum"

void main()
{
    object oPC = OBJECT_SELF;
    if (ExpendInspiration(oPC, 1))
    {
    	int nSpellID = GetFactotumSlot(oPC);
		int nCasterLevel = GetLevelByClass(CLASS_TYPE_FACTOTUM, oPC);    
    	int nTotalDC = 10 + StringToInt(Get2DACache("spells", "Wiz_Sorc", nSpellID)) + GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);

    	ActionDoCommand(SetLocalInt(oPC, "SpellIsSLA", TRUE));
    	ActionCastSpell(nSpellID, nCasterLevel, 0, nTotalDC, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, FALSE, OBJECT_INVALID, FALSE);
    	ActionDoCommand(DeleteLocalInt(oPC, "SpellIsSLA"));  
    	//return;
    }
    else
    {
    	IncrementRemainingFeatUses(oPC, StringToInt(Get2DACache("spells", "FeatID", PRCGetSpellId())));
    }
}