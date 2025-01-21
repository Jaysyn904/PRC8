#include "prc_inc_assoc"

void main()
{
    object oPC = OBJECT_SELF;
    object oComp = GetAssociateNPC(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC, NPC_SHAMAN_COMPANION);
    string sResRef = "prc_shamn_cat";

    //remove previously summoned companion
    if(GetIsObjectValid(oComp))
        DestroyAssociate(oComp);

    oComp = CreateLocalNPC(oPC, ASSOCIATE_TYPE_ANIMALCOMPANION, sResRef, GetSpellTargetLocation(), NPC_SHAMAN_COMPANION, sResRef);
    AddAssociate(oPC, oComp);

    int nLevel = GetLevelByClass(CLASS_TYPE_SHAMAN, oPC);
        //nLevel += (GetHitDice(oPC) - nLevel) / 2;
    int n;
    for(n = 1; n < nLevel; n++)
        LevelUpHenchman(oComp, CLASS_TYPE_INVALID, TRUE);

    // Disable inventory
    SetLocalInt(oComp, "X2_JUST_A_DISABLEEQUIP", TRUE);
    SetNaturalWeaponDamage(oComp);

    object oCompSkin = GetPCSkin(oComp);

    //Exalted Companion
    if((GetHasFeat(FEAT_EXALTED_COMPANION, oPC) || GetPersistantLocalInt(oPC, "VoPFeat"+IntToString(FEAT_EXALTED_COMPANION))) 
	  && GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
        ApplyExaltedCompanion(oComp, oCompSkin);

    //Talontar Blightlord's Illmaster
    if(GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oPC) >= 2)
        ApplyIllmaster(oComp, oCompSkin);
}