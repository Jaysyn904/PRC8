#include "prc_inc_burn"
#include "moi_inc_moifunc"
#include "psi_inc_psifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    if (GetLocalInt(oMeldshaper, "DistillDelay")) return;
    if (GetPrimaryArcaneClass(oMeldshaper))
    {
    	int nType = GetPrimaryArcaneClass(oMeldshaper);   
       	int nMax = GetMaxSpellLevelForCasterLevel(nType, GetLevelByTypeArcane(oMeldshaper));
       	//FloatingTextStringOnCreature("Soul 1", oMeldshaper);
       	//int nMax = PRCGetSpellLevel(oMeldshaper, GetBestAvailableSpell(oMeldshaper));
       	//FloatingTextStringOnCreature("Soul 2", oMeldshaper);
    	SetLocalInt(oMeldshaper, "BurnSpellLevel", nMax);
    	//int nMax = PRCGetSpellLevel(oMeldshaper, BurnBestSpell(oMeldshaper));
    	if (BurnSpell(oMeldshaper)) // Burn a spell of the appropriate level
    	{
    		FloatingTextStringOnCreature("Expending a level "+IntToString(nMax)+" spell to grant "+IntToString(nMax)+" temporary essentia", oMeldshaper);
    	    DeleteLocalInt(oMeldshaper, "BurnSpellLevel"); 
        	SetTemporaryEssentia(oMeldshaper, nMax);
        	DelayCommand(6.0, SetTemporaryEssentia(oMeldshaper, nMax*-1)); 
        	SetLocalInt(oMeldshaper, "DistillDelay", TRUE);
        	DelayCommand(6.0, DeleteLocalInt(oMeldshaper, "DistillDelay"));
    	}
    }
    else // Psionic goes here
    { 
       	int nMax = GetMaxPowerLevel(oMeldshaper);
       	int nCost = (nMax * 2) - 1;
    	if (GetCurrentPowerPoints(oMeldshaper) >= nCost)
    	{
    		LosePowerPoints(oMeldshaper, nCost, FALSE);
    		FloatingTextStringOnCreature("Expending a "+IntToString(nCost)+" power points to grant "+IntToString(nMax)+" temporary essentia", oMeldshaper);
        	SetTemporaryEssentia(oMeldshaper, nMax);
        	DelayCommand(6.0, SetTemporaryEssentia(oMeldshaper, nMax*-1)); 
        	SetLocalInt(oMeldshaper, "DistillDelay", TRUE);
        	DelayCommand(6.0, DeleteLocalInt(oMeldshaper, "DistillDelay"));
    	}    
    }
}