#include "prc_inc_assoc"

void main()
{
    object oComp = OBJECT_SELF;

    ExecuteScript("nw_ch_ac9", oComp);
    ExecuteScript("prc_npc_spawn", oComp);

/*    if(GetAssociateTypeNPC(oComp) == ASSOCIATE_TYPE_ANIMALCOMPANION)
    {
        object oMaster = GetMasterNPC(oComp);
        object oCompSkin = GetPCSkin(oComp);

        //Exalted Companion
        if(GetHasFeat(FEAT_EXALTED_COMPANION, oMaster) && GetAlignmentGoodEvil(oMaster) == ALIGNMENT_GOOD)
            ApplyExaltedCompanion(oComp, oCompSkin);

        //Talontar Blightlord's Illmaster
        if(GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oMaster) >= 2)
            ApplyIllmaster(oComp, oCompSkin);
    }*/
}