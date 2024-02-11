//::///////////////////////////////////////////////
//:: Unsummon
//:: prc_tn_unsum.nss
//:://////////////////////////////////////////////
/*
    Unsummons a True Necromancer or Hathran summon.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: June 26 , 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_npc"

void main()
{
    object oTarget = PRCGetSpellTargetObject();
    string sRes = GetResRef(oTarget);
    object oMaster = GetMaster(oTarget);

    // If it has no master, it can be cleaned up as well
    if (OBJECT_SELF == oMaster || !GetIsObjectValid(oMaster))
    {
        if(sRes == "prc_sum_bonet"
        || sRes == "prc_sum_dbl"
        || sRes == "prc_sum_dk"
        || sRes == "prc_sum_grav"
        || sRes == "prc_sum_mohrg"
        || sRes == "prc_sum_sklch"
        || sRes == "prc_sum_vamp1"
        || sRes == "prc_sum_vamp2"
        || sRes == "prc_sum_wight"
        || sRes == "prc_sum_zlord"
        || sRes == "prc_tn_fthug"
        || sRes == "prc_hath_rash"
        || sRes == "prc_hath_rash2"
        || sRes == "prc_hath_rash3"
        || sRes == "prc_hath_rash4"
        || sRes == "prc_hath_rash5"
        || sRes == "prc_hath_rash6"
        || sRes == "prc_hath_rash7"
        || sRes == "prc_hath_rash8"
        || sRes == "prc_hath_rash9"
        || sRes == "prc_hath_rash10"
        || sRes == "prc_sum_unicorn"
        || sRes == "prc_sum_lammasu"
        || sRes == "prc_sum_andro")
        {
            DestroyObject(oTarget);
        }
    }
}
