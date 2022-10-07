//::///////////////////////////////////////////////
//:: Orc Warlord
//:://////////////////////////////////////////////
/*
Release Horde - Unsummon orc henchmen
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:://////////////////////////////////////////////
#include "prc_alterations"
void main()
{

    SendMessageToPC(OBJECT_SELF, "Release Horde Called");

    object oTarget = PRCGetSpellTargetObject();
    string sRes = GetResRef(oTarget);
    object oMaster = GetMaster(oTarget);


    effect eDam = EffectDamage(9999, DAMAGE_TYPE_POSITIVE);

    if (OBJECT_SELF == oMaster)
    {

        SendMessageToPC(OBJECT_SELF, "You are target's master");

        if (sRes == "ow_sum_axe_1" || sRes == "ow_sum_axe_2" || sRes == "ow_sum_axe_3" || sRes == "ow_sum_axe_4" || sRes == "ow_sum_axe_5" ||
        sRes == "ow_sum_axe_6" || sRes == "ow_sum_axe_7" || sRes == "ow_sum_axe_8" || sRes == "ow_sum_axe_9" || sRes == "ow_sum_axe_10" ||
        sRes == "ow_sum_axe_11" || sRes == "ow_sum_axe_12" || sRes == "ow_sum_barb_1" || sRes == "ow_sum_barb_2" || sRes == "ow_sum_barb_3" ||
        sRes == "ow_sum_barb_4" || sRes == "ow_sum_barb_5" || sRes == "ow_sum_barb_6" || sRes == "ow_sum_barb_7" || sRes == "ow_sum_barb_8" ||
        sRes == "ow_sum_barb_9" || sRes == "ow_sum_barb_10" || sRes == "ow_sum_barb_11" || sRes == "ow_sum_barb_12" || sRes == "ow_sum_fght_1" ||
        sRes == "ow_sum_fght_2" || sRes == "ow_sum_fght_3" || sRes == "ow_sum_fght_4" || sRes == "ow_sum_fght_5" || sRes == "ow_sum_fght_6" ||
        sRes == "ow_sum_fght_7" || sRes == "ow_sum_fght_8" || sRes == "ow_sum_fght_9" || sRes == "ow_sum_fght_10" || sRes == "ow_sum_fght_11" ||
        sRes == "ow_sum_fght_12" || sRes == "ow_sum_sham_1" || sRes == "ow_sum_sham_2" || sRes == "ow_sum_sham_3" || sRes == "ow_sum_sham_4" ||
        sRes == "ow_sum_sham_5" || sRes == "ow_sum_sham_6" || sRes == "ow_sum_sham_7" || sRes == "ow_sum_sham_8" || sRes == "ow_sum_sham_9" ||
        sRes == "ow_sum_sham_10" || sRes == "ow_sum_sham_11" || sRes == "ow_sum_sham_12")
        {
            SendMessageToPC(OBJECT_SELF, "Target is a Horde Orc");
            DestroyObject(oTarget);
            //ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        }

    }
}