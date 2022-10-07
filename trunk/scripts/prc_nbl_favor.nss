
#include "prc_class_const"
#include "inc_dynconv"

void main()
{
	object oPC = OBJECT_SELF;
	
	int nBonus = 0;
	if (GetLevelByClass(CLASS_TYPE_NOBLE, oPC) >= 16) nBonus = 4;
	else if (GetLevelByClass(CLASS_TYPE_NOBLE, oPC) >= 12) nBonus = 3;
	else if (GetLevelByClass(CLASS_TYPE_NOBLE, oPC) >= 7) nBonus = 2;
	else if (GetLevelByClass(CLASS_TYPE_NOBLE, oPC) >= 3) nBonus = 1;
	
	int nRoll = d20() + 1 + nBonus;
	int nMessage = FALSE;
        object oDM = GetFirstPC();
        while (GetIsObjectValid(oDM))
        {
                if ( GetIsDM(oDM) || GetIsDMPossessed(oDM) )
                {
                    FloatingTextStringOnCreature(GetName(oPC) + " has made a favor roll of " + IntToString(nRoll), oDM, FALSE);
                    nMessage = TRUE;
                }
            oDM = GetNextPC();
        }

    	if (!nMessage) StartDynamicConversation("prc_nbl_favorcnv", oPC, DYNCONV_EXIT_NOT_ALLOWED, TRUE, FALSE, oPC);
}
