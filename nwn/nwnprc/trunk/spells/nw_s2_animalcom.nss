//::///////////////////////////////////////////////
//:: Summon Animal Companion
//:: NW_S2_AnimalComp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons a Druid's animal companion
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_assoc"

void main()
{
    //Yep thats it
    SummonAnimalCompanion();

    object oPC = OBJECT_SELF;
    object oComp = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);//make sure it's bioware Animal Companion here
    object oCompSkin = GetPCSkin(oComp);

    //Exalted Companion
    if((GetHasFeat(FEAT_EXALTED_COMPANION, oPC) || GetPersistantLocalInt(oPC, "VoPFeat"+IntToString(FEAT_EXALTED_COMPANION)))
		&& GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
        ApplyExaltedCompanion(oComp, oCompSkin);

    //Talontar Blightlord's Illmaster
    if(GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oPC) >= 2)
        ApplyIllmaster(oComp, oCompSkin);
}
