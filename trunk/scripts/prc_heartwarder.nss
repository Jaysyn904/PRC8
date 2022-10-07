#include "prc_feat_const"
#include "prc_misc_const"
#include "inc_item_props"

////    bonus CHA    ////
void CharBonus(object oPC ,object oSkin ,int iLevel)
{
    int iTest = GetPersistantLocalInt(oPC, "NWNX_HeartWardCha");
    int nDiff = iLevel - iTest;

    if(nDiff != 0)//only part of the bouns was applied permanently or not applied at all
        SetCompositeBonus(oSkin, "HeartWardCharBonus", nDiff, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_CHA);
}

/// +2 on CHA based skill /////////
void Heart_Passion(object oPC ,object oSkin ,int iLevel)
{
    int iTest = GetPersistantLocalInt(oPC, "NWNX_HeartWardSkill");

    if(!iTest)
    {
        SetCompositeBonus(oSkin, "HeartPassionA", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_ANIMAL_EMPATHY);
        SetCompositeBonus(oSkin, "HeartPassionP", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERFORM);
        SetCompositeBonus(oSkin, "HeartPassionPe", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
        SetCompositeBonus(oSkin, "HeartPassionT", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_SENSE_MOTIVE);
        SetCompositeBonus(oSkin, "HeartPassionUMD", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_USE_MAGIC_DEVICE);
        SetCompositeBonus(oSkin, "HeartPassionB", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_BLUFF);
        SetCompositeBonus(oSkin, "HeartPassionI", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
    }
}

//// subtype Fey   ////
void Fey_Type(object oPC ,object oSkin )
{
   if(GetLocalInt(oSkin, "FeyType") == 1) return;

   AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_CHARM_PERSON),oSkin);
   AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_DOMINATE_PERSON),oSkin);
   AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_HOLD_PERSON),oSkin);
   AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_MASS_CHARM),oSkin);

   SetLocalInt(oSkin, "FeyType",1);
}

void main()
{

     //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int bChar=GetHasFeat(FEAT_CHARISMA_INC1, oPC) ? 1 : 0;
        bChar=GetHasFeat(FEAT_CHARISMA_INC2, oPC) ? 2 : bChar;
        bChar=GetHasFeat(FEAT_CHARISMA_INC3, oPC) ? 3 : bChar;
        bChar=GetHasFeat(FEAT_CHARISMA_INC4, oPC) ? 4 : bChar;
        bChar=GetHasFeat(FEAT_CHARISMA_INC5, oPC) ? 5 : bChar;

    int bHeartP = GetHasFeat(FEAT_HEART_PASSION, oPC) ? 2 : 0;
    int bFey    = GetHasFeat(FEAT_FEY_METAMORPH, oPC) ? 1 : 0;

    //if (bChar>0)   DelayCommand(0.2, CharBonus(oPC, oSkin, bChar));
    if (bHeartP>0) DelayCommand(0.2, Heart_Passion(oPC, oSkin,bHeartP));
    if (bFey>0)    DelayCommand(0.2, Fey_Type(oPC ,oSkin ));
}
