#include "prc_alterations"
#include "prc_inc_scry"
#include "prc_inc_assoc"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oMaster = GetMaster();

    if(GetPRCSwitch(PRC_PNP_FAMILIARS))
    {
        object oFam = OBJECT_SELF;
        object oRealMaster = GetMasterNPC(oFam);

        if(oPC == oRealMaster
        && oMaster != oRealMaster
        && !GetIsScrying(oPC))
            AddAssociate(oPC, oFam);

        int nFamLevel = GetHitDice(oFam);
        if((nFamLevel < 5) && (oPC == oMaster))
        {
            return TRUE;
        }
    }

    return oPC != oMaster;
}
