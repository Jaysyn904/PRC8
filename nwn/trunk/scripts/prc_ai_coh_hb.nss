//Cohort HB script

#include "prc_alterations"
#include "prc_inc_leadersh"
void main()
{
    object oCohort = OBJECT_SELF;
    object oPC = GetMaster(oCohort);
    object oMaster = GetLocalObject(oCohort, "MasterObject");
    if(!GetIsObjectValid(oPC) && GetIsObjectValid(oMaster))
    {
        //must have become disconnected from master
        //re-add it as a cohort, but dont re-setup it
        AddCohortToPlayerByObject(oCohort, oMaster, FALSE);
        //dont continue this script, allow next HB to kick in instead
        return;
    }
    else if(!GetIsObjectValid(oPC) && !GetIsObjectValid(oMaster))
    {
        //master no longer exists
        RemoveCohortFromPlayer(oCohort, oPC);
        return;
    }    
    //if it doesnt have a tag, abort
    if(GetTag(OBJECT_SELF) == "")
        return;

    //cohort XP gain
    //get the amount the PC has gained
    int XPGained = GetXP(oPC)-GetLocalInt(OBJECT_SELF, "MastersXP");
    //correct for simple LA XP penalty
    if(GetPRCSwitch(PRC_XP_USE_SIMPLE_LA))
    {
        int iPCLvl = GetHitDice(oPC);
        int nRace = GetRacialType(oPC);
        int iLvlAdj = StringToInt(Get2DACache("ECL", "LA", nRace));
        if(GetPRCSwitch(PRC_XP_INCLUDE_RACIAL_HIT_DIE_IN_LA))
            iLvlAdj += StringToInt(Get2DACache("ECL", "RaceHD", nRace));
        float fRealXPToLevel = IntToFloat(GetXPForLevel(iPCLvl+1));
        float fECLXPToLevel = IntToFloat(GetXPForLevel(iPCLvl+1+iLvlAdj));
        float fXPRatio = fECLXPToLevel/fRealXPToLevel;
        XPGained = FloatToInt(IntToFloat(XPGained)*fXPRatio);
    }
    //store the amount the PC now has for the next HB
    SetLocalInt(OBJECT_SELF, "MastersXP", GetXP(oPC));
    //work out proportion based on relative ECLs
    int nPCECL = GetECL(oPC);
    int nCohortECL = GetECL(oCohort);
    int nCohortLag = GetLocalInt(oCohort, "CohortLevelLag");
    int nCohortMaxHD = nPCECL-nCohortLag-StringToInt(Get2DACache("ECL", "LA", GetRacialType(oCohort)));
    if(GetPRCSwitch(PRC_XP_INCLUDE_RACIAL_HIT_DIE_IN_LA))
        nCohortMaxHD -= StringToInt(Get2DACache("ECL", "RaceHD", GetRacialType(oCohort)));
    float ECLRatio = IntToFloat(nPCECL)/IntToFloat(nCohortECL);
    //get the amount to gain
    int nCohortXPGain = FloatToInt(IntToFloat(XPGained)*ECLRatio);
    //get the current amount
    int nCohortXP = GetXP(oCohort);
    //work out the new amount
    int nCohortNewXP = nCohortXP+nCohortXPGain;
    //get the cap based on PC level and cohort LA
    int nCohortXPCap = ((nCohortMaxHD)*(nCohortMaxHD+1)*500)-1;
    //this is how much XP the next levelup will be at
    int nCohortXPLevel = nCohortECL*(nCohortECL+1)*500;
//DoDebug("XPGained = "+IntToString(XPGained));
//DoDebug("nPCECL = "+IntToString(nPCECL));
//DoDebug("nCohortECL = "+IntToString(nCohortECL));
//DoDebug("nCohortXPGain = "+IntToString(nCohortXPGain));
//DoDebug("nCohortXP = "+IntToString(nCohortXP));
//DoDebug("nCohortNewXP = "+IntToString(nCohortNewXP));
//DoDebug("nCohortXPCap = "+IntToString(nCohortXPCap));
//DoDebug("nCohortXPLevel = "+IntToString(nCohortXPLevel));
    //apply the cap
    if(nCohortNewXP > nCohortXPCap)
        nCohortNewXP = nCohortXPCap;
    //give the XP   
    SetXP(oCohort, nCohortNewXP); 
    //handle levelup
    if(nCohortNewXP >= nCohortXPLevel)
    {
        //standard
        if(GetResRef(oCohort) != "")
        {
            LevelUpHenchman(oCohort, CLASS_TYPE_INVALID, TRUE);    
        }
        else
        {
            //custom
            //resummon it but dont decrease XP as much
            int nCohortID = GetLocalInt(oCohort, "CohortID");
			
			//Call creation of new cohort
            object oNewCohort = AddCohortToPlayer(nCohortID, oPC);
            object oTest;
            //copy its equipment & inventory
            // object oTest = GetFirstItemInInventory(oCohort);
           //  while(GetIsObjectValid(oTest))
           //  {
            //    if(!GetLocalInt(oTest, "CohortCopied"))
            //        object oNewTest = CopyItem(oTest, oNewCohort, TRUE);
            //    SetLocalInt(oTest, "CohortCopied", TRUE);
            //    DestroyObject(oTest, 0.01);
            //    oTest = GetNextItemInInventory(oCohort);
            //}
			
			//Delete new cohorts items (todo: prevent having them added in first place)
			object currItem = GetFirstItemInInventory(oNewCohort);
			while(GetIsObjectValid(currItem)){
				DestroyObject(currItem, 0.01);
				currItem = GetNextItemInInventory(oNewCohort);
			}
			
			//Copy Inventory Items
			currItem = GetFirstItemInInventory(oCohort);
			while(GetIsObjectValid(currItem)){
				CopyItem(currItem,oNewCohort,TRUE);
				DestroyObject(currItem, 0.01);
				currItem = GetNextItemInInventory(oCohort);
			}
			
			//Copy Equiped items (todo: fix equipping)
            int nSlot;
			for(nSlot = 0;nSlot<14;nSlot++)
            {
                oTest = GetItemInSlot(nSlot, OBJECT_SELF);  
                object oTest2 = CopyItem(oTest, oNewCohort, TRUE);
				//currently isn't equiping it
				AssignCommand(oNewCohort, ClearAllActions());
                AssignCommand(oNewCohort, ActionEquipItem(oTest2, nSlot));
                DestroyObject(oTest, 0.01);
            }
			
            //destroy old cohort
            SetIsDestroyable(TRUE, FALSE, FALSE);
            DestroyObject(OBJECT_SELF, 0.1);
        }
    }/*
    
    //and now for some intelligence to the AI
    //if you have a familiar, summon it
    if(GetHasFeat(FEAT_SUMMON_FAMILIAR, oCohort)
        //&& !GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oCohort))
        )
        ActionUseFeat(FEAT_SUMMON_FAMILIAR, oCohort);
        //SummonFamiliar(oCohort);
    //if you have an animal companion, summon it
    if(GetHasFeat(FEAT_ANIMAL_COMPANION, oCohort)
        //&& !GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oCohort))
        )
        ActionUseFeat(FEAT_ANIMAL_COMPANION, oCohort);
        //SummonAnimalCompanion(oCohort);*/
}   