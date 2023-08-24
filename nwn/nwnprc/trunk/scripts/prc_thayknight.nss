//::///////////////////////////////////////////////
//:: Thayan Knight
//:://////////////////////////////////////////////
/*
    Applies passive bonuses of the Thayan Knight
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Aug 5, 2004
//:://////////////////////////////////////////////

#include "inc_newspellbook"
#include "prc_inc_core"

void HorrorOfThay(object oPC, object oSkin)
{ 

if(GetLocalInt(oSkin, "ThayHorror") == TRUE) return;

	if (GetHasFeat(FEAT_TK_HORROR_2, oPC))
	{
		SetCompositeBonus(oSkin, "ThayHorrorFear", 4, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_FEAR);
		SetCompositeBonus(oSkin, "ThayHorrorCharm",  2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_MINDAFFECTING);
	}
	else 
        {
		SetCompositeBonus(oSkin, "ThayHorrorFear", 2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_FEAR);
		SetCompositeBonus(oSkin, "ThayHorrorCharm",  1, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_MINDAFFECTING);
	}
	SetLocalInt(oSkin, "ThayHorror", TRUE);
}

void ZulkirFavour(object oPC ,object oSkin)
{

   if(GetLocalInt(oSkin, "ThayZulkFave") == TRUE) return;

    SetCompositeBonus(oSkin, "ThayZulkFaveSkill", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);
    SetCompositeBonus(oSkin, "ThayZulkFaveSave",  2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_REFLEX);
    SetLocalInt(oSkin, "ThayZulkFave", TRUE);
}

void ZulkirChampion(object oPC ,object oSkin)
{

   if(GetLocalInt(oSkin, "ThayZulkChamp") == TRUE) return;

    SetCompositeBonus(oSkin, "ThayZulkChampSkill", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);
    SetCompositeBonus(oSkin, "ThayZulkChampSave",  2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_REFLEX);
    SetLocalInt(oSkin, "ThayZulkChamp", TRUE);
}

void ZulkirDefender(object oPC)
{
        ActionCastSpellOnSelf(SPELL_THAYANKNIGHT_DAMAGE); // +2 to attack and damage rolls
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    
    SetCompositeAttackBonus(oPC, "ZulkirDefender", 0);
    
    if (GetHasFeat(FEAT_TK_HORROR_1, oPC)) HorrorOfThay(oPC, oSkin);
    if (GetHasFeat(FEAT_TK_ZULKIR_FAVOUR, oPC)) ZulkirFavour(oPC, oSkin);
    if (GetHasFeat(FEAT_TK_ZULKIR_CHAMP, oPC)) ZulkirChampion(oPC, oSkin);
    if (GetHasFeat(FEAT_TK_ZULKIR_DEFEND, oPC)) ZulkirDefender(oPC);
    
    
}