//::///////////////////////////////////////////////
//:: Summon Cohort
//:: Cohort
//:://////////////////////////////////////////////
/*
    Summons a Rashemen Barbarian as a Hathran cohort
*/
//:://////////////////////////////////////////////
//:: Created By: Sir Attilla
//:: Created On: January 3 , 2004
//:: Modified By: Stratovarius, bugfixes.
//:://////////////////////////////////////////////
#include "inc_persist_loca"
#include "prc_class_const"  
  
void main()  
{  
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_GATE);  
    string sSummon;  
    int i = 1;  
    object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, OBJECT_SELF, i);  
  
    while (GetIsObjectValid(oHench))  
    {  
        if (GetStringLeft(GetResRef(oHench), 8) == "prc_hath_")  
    	{  
            FloatingTextStringOnCreature("You already have a Rashemi Cohort", OBJECT_SELF, FALSE);  
            return;  
        }  
        i += 1;  
        oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, OBJECT_SELF, i);          
    }  
  
    int nClass = GetLevelByClass(CLASS_TYPE_HATHRAN, OBJECT_SELF);  
    int nCohortType = GetPersistantLocalInt(OBJECT_SELF, "PRC_HATHRAN_COHORT_TYPE");  
  
    if(nCohortType == 1) // Ethran  
    {  
        if (nClass > 27)        sSummon = "prc_hath_ethrn10";  
        else if (nClass > 24)   sSummon = "prc_hath_ethrn09";  
        else if (nClass > 21)   sSummon = "prc_hath_ethrn08";  
        else if (nClass > 18)   sSummon = "prc_hath_ethrn07";  
        else if (nClass > 15)   sSummon = "prc_hath_ethrn06";  
        else if (nClass > 12)   sSummon = "prc_hath_ethrn05";  
        else if (nClass > 9)    sSummon = "prc_hath_ethrn04";  
        else if (nClass > 6)    sSummon = "prc_hath_ethrn03";  
        else if (nClass > 3)    sSummon = "prc_hath_ethrn02";  
        else if (nClass > 0)    sSummon = "prc_hath_ethrn01";  
    }  
    else // Default Rashemi Barbarian  
    {  
        if (nClass > 27)        sSummon = "prc_hath_rash10";  
        else if (nClass > 24)   sSummon = "prc_hath_rash9";  
        else if (nClass > 21)   sSummon = "prc_hath_rash8";  
        else if (nClass > 18)   sSummon = "prc_hath_rash7";  
        else if (nClass > 15)   sSummon = "prc_hath_rash6";  
        else if (nClass > 12)   sSummon = "prc_hath_rash5";  
        else if (nClass > 9)    sSummon = "prc_hath_rash4";  
        else if (nClass > 6)    sSummon = "prc_hath_rash3";  
        else if (nClass > 3)    sSummon = "prc_hath_rash2";  
        else if (nClass > 0)    sSummon = "prc_hath_rash";  
    }  
  
    object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sSummon, GetSpellTargetLocation());  
    int nMaxHenchmen = GetMaxHenchmen();  
    SetMaxHenchmen(99);  
    AddHenchman(OBJECT_SELF, oCreature);  
    SetMaxHenchmen(nMaxHenchmen);  
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());  
}



