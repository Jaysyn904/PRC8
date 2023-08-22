#include "prc_alterations"
#include "prc_inc_assoc"

void main()
{
    object oFam = OBJECT_SELF;

    ExecuteScript("prc_npc_death", oFam);
    if(GetStringLeft(GetResRef(oFam), 11) == "prc_pnpfam_")
    {
        //raisable
        SetIsDestroyable(FALSE, TRUE, TRUE);
        SetLocalInt(oFam, "Familiar_Died", 1);

        //apply XP penalty
        object oPC = GetMasterNPC(oFam);
        int nFamLevel = GetHitDice(oFam);
        int nLostXP = 200*nFamLevel;
        //fort save for half xp loss
        if(FortitudeSave(oPC, 15))
            nLostXP /= 2;
        //check it wont loose a level
        int nSpareXP = GetXP(oPC)-(GetHitDice(oPC)*(GetHitDice(oPC)-1)*500);
        if(nSpareXP < nLostXP)
            nLostXP = nSpareXP;
        SetXP(oPC, GetXP(oPC) - nLostXP);
        //delete it from the database
        //DeleteCampaignVariable("prc_data", "Familiar", oPC);
    }
    else
        ExecuteScript("nw_ch_ac7", oFam);
}