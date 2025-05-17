//::///////////////////////////////////////////////
//:: [Oozemaster Feats]
//:: [prc_oozemstr.nss]
//:://////////////////////////////////////////////
//:: Check to see which Oozemaster feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: DarkGod (Modified by Aaon Graywolf)
//:: Created On: Jan 7, 2004
//:://////////////////////////////////////////////
#include "prc_inc_spells"

// * Applies the Oozemasters's immunities on the object's skin.
// * iType = IP_CONST_IMMUNITYMISC_*
// * sFlag = Flag to check whether the property has already been added
void OozemasterImmunity(object oPC, object oSkin, int iType, string sFlag)
{
    if(GetLocalInt(oSkin, sFlag) == TRUE) return;

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(iType), oSkin);
    SetLocalInt(oSkin, sFlag, TRUE);
}

// * Applies the Oozemasters's charisma penalty as a composite on the object's skin.
void OozemasterCharismaPenatly(object oPC, object oSkin)
{
    int iPenalty = GetLevelByClass(CLASS_TYPE_OOZEMASTER, oPC) / 2;
    int iTest = GetPersistantLocalInt(oPC, "NWNX_OozemasterCha");
    int nDiff = iPenalty + iTest;

    if(nDiff != 0)
        SetCompositeBonus(oSkin, "OozeChaPen", nDiff, ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_CHA);
}

void main()
{
    //Declare main variables.
    int nEvent = GetRunningEvent();
    object oPC;
    switch(nEvent)
    {
        case EVENT_ONHEARTBEAT:         oPC = OBJECT_SELF;               break;

        default:
            oPC = OBJECT_SELF;
    }
    object oSkin = GetPCSkin(oPC);
	
	AddEventScript(oPC, EVENT_ONHEARTBEAT, "prc_oozemstr", TRUE, FALSE);

    //Determine which Oozemaster feats the character has
    int bIdAnat  = GetHasFeat(FEAT_INDISCERNIBLE_ANATOMY, oPC);
    int bChaPen = GetHasFeat(FEAT_CHARISMA_PENALITY, oPC);
    int bOneOz = GetHasFeat(FEAT_ONE_WITH_THE_OOZE, oPC);

	int nClass = GetLevelByClass(CLASS_TYPE_OOZEMASTER, oPC);
	
	if(nEvent == EVENT_ONHEARTBEAT)
	{	
	    //Apply bonuses accordingly
		if(bIdAnat)
		{
			if (nClass > 5 && nClass < 10)
			{
				int bFortification = GetLocalInt(oPC, "LIGHT_FORTIFCATION_ACTIVE");
			
				if (!bFortification)
				{
					DoFortification(oPC, FORTIFICATION_LIGHT);
					SetLocalInt(oPC, "LIGHT_FORTIFCATION_ACTIVE", 1);
					if(DEBUG) DoDebug("prc_oozemstr >> DoFortification() activated.");			
				}
			}
		}		
			
/*     if(bIdAnat){
        OozemasterImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_CRITICAL_HITS, "IndiscernibleCrit");
        OozemasterImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_BACKSTAB, "IndiscernibleBS");
    }
 */
	}
	else
	{
		if(bOneOz)
		{
			OozemasterImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_MINDSPELLS, "OneOozeMind");
			OozemasterImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_POISON, "OneOozePoison");
			OozemasterImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_PARALYSIS, "OneOozePoison");
			OozemasterImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_CRITICAL_HITS, "IndiscernibleCrit");
			OozemasterImmunity(oPC, oSkin, IP_CONST_IMMUNITYMISC_BACKSTAB, "IndiscernibleBS");
		}
    //if(bChaPen) OozemasterCharismaPenatly(oPC, oSkin);
	}	
}