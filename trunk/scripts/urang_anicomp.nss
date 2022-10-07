#include "prc_inc_assoc"

void main()
{
    object oPC = OBJECT_SELF;
    object oComp = GetAssociateNPC(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC, NPC_UR_COMPANION);
    string sTag = "hen_winterwolf";

    //remove previously summoned companion
    if(GetIsObjectValid(oComp))
        DestroyAssociate(oComp);

    int nClass = GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER, oPC);
    string sRef = nClass >= 30 ? "acomep_winwolf" : "acomp_winwolf";

    oComp = CreateLocalNPC(oPC, ASSOCIATE_TYPE_ANIMALCOMPANION, sRef, GetSpellTargetLocation(), NPC_UR_COMPANION, sTag);
    AddAssociate(oPC, oComp);

    int i;
    for(i = 1; i < nClass; i++)
        LevelUpHenchman(oComp, CLASS_TYPE_MAGICAL_BEAST, TRUE, PACKAGE_ANIMAL);

    // Disable inventory
    SetLocalInt(oComp, "X2_JUST_A_DISABLEEQUIP", TRUE);
    SetNaturalWeaponDamage(oComp);
    WinterWolfProperties(oComp, nClass);

    object oCompSkin = GetPCSkin(oComp);

    //Exalted Companion
    if(GetHasFeat(FEAT_EXALTED_COMPANION, oPC) && GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
        ApplyExaltedCompanion(oComp, oCompSkin);

    //Talontar Blightlord's Illmaster
    if(GetLevelByClass(CLASS_TYPE_BLIGHTLORD, oPC) >= 2)
        ApplyIllmaster(oComp, oCompSkin);
}
