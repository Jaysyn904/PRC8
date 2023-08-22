#include "prc_inc_spells"
#include "prc_inc_domain"
int GetIsBlessingHourValid()
{
    if(GetTimeHour()>=12 || GetTimeHour()<MOD_DAWN_START_HOUR)
    {
        return FALSE;
    }
    return TRUE;
}

void CheckBlessingOfDawn(object oPC, object oSkin)
{
    object oArea = GetArea(oPC);
    int bValidHour = GetIsBlessingHourValid();
    if(!bValidHour || GetIsAreaInterior(oArea))
    {
        //SendMessageToPC(GetFirstPC(),"Blessing of Dawn Removed");
        DelayCommand(15.0,CheckBlessingOfDawn(oPC, oSkin));
        return;
    }
    float fInterval = INTERVAL_BLESSING_OF_DAWN;
    SetCompositeBonus(oSkin, "MLWillSave", 2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);
    DelayCommand(fInterval,CheckBlessingOfDawn(oPC, oSkin));
}

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    
    int nMorninglordLevel = GetLevelByClass(CLASS_TYPE_MORNINGLORD, oPC);
    SetCompositeBonus(oSkin, "SkillMLCA", nMorninglordLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_CRAFT_ARMOR);
    SetCompositeBonus(oSkin, "SkillMLCT", nMorninglordLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_CRAFT_TRAP);
    SetCompositeBonus(oSkin, "SkillMLPer", nMorninglordLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERFORM);
    SetCompositeBonus(oSkin, "SkillMLCW", nMorninglordLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_CRAFT_WEAPON);
    SetCompositeBonus(oSkin, "SkillMLCG", nMorninglordLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_CRAFT_GENERAL);
    SetCompositeBonus(oSkin, "SkillMLCA", nMorninglordLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_CRAFT_ALCHEMY);
    SetCompositeBonus(oSkin, "SkillMLPoi", nMorninglordLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_CRAFT_POISON);
    
    if (nMorninglordLevel >= 6)
        CheckBlessingOfDawn(oPC, oSkin);
}
