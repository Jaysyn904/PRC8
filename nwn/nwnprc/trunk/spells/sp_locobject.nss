//::///////////////////////////////////////////////
//:: Locate Object
//:: sp_locobject.nss
//:://////////////////////////////////////////////
/*
    A spell that allows the caster to know the
    distance and facing to a single object
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: May 6, 2007
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
        object oPC = OBJECT_SELF;
        
DeleteLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_DIVINATION);

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	// Check if current area blocks scrying  
	if(GetLocalInt(GetArea(oPC), "SCRY_FROM_AREA_BLOCKED"))  
	{  
		FloatingTextStringOnCreature("This area prevents scrying.", oPC, FALSE);  
		return;  
	}
	
        //Declare major variables
        object oTarget;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nSpell = PRCGetSpellId();
        int nDC = PRCGetSaveDC(oTarget, oPC);
        float fDur = 60.0 * nCasterLvl;
        int nMetaMagic = PRCGetMetaMagicFeat();
    	//Make Metamagic check for extend
    	if ((nMetaMagic & METAMAGIC_EXTEND))
    	{
        	fDur = fDur * 2;
    	}                
        
        SetLocalInt(oPC, "ScryCasterLevel", nCasterLvl);
        SetLocalInt(oPC, "ScrySpellId", nSpell);
        SetLocalInt(oPC, "ScrySpellDC", nDC);
        SetLocalFloat(oPC, "ScryDuration", fDur);       
        
        StartDynamicConversation("prc_scry_conv", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);

DeleteLocalInt(oPC, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
