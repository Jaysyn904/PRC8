//::///////////////////////////////////////////////
//:: NW_S3_Alcohol.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Makes beverages fun.
  May 2002: Removed fortitude saves. Just instant intelligence loss
*/
//:://////////////////////////////////////////////
//:: Created By:   Brent
//:: Created On:   February 2002
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
//:: Modified by Jeremiah Teague for
//:: Drunken Master Prestige Class
//:://////////////////////////////////////////////
#include "prc_inc_clsfunc"

void main()
{
	int nSpellID 		= PRCGetSpellId();
    int nDrunkenMaster 	= GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER);
		
    if(nDrunkenMaster)
    {
        if(nDrunkenMaster > 4)
        {
            RemoveAlcoholEffects();
            DrunkenRage();
        }
        else
            DrunkLikeDemon();

        DrunkenMasterSpeakString();
        DrunkenMasterCreateEmptyBottle(nSpellID);
    }

//:: Only overrides alcohol payload if PW hook script exists.    
	if(ResManGetAliasFor("prc_pwalcohol", RESTYPE_NSS) != "")
	{
		ExecuteScript("prc_pwalcohol");
	}
	
	else
		MakeDrunk(nSpellID);
	
}