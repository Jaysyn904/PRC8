//::///////////////////////////////////////////////
//:: [Alienist Feats]
//:: [prc_alienist.nss]
//:://////////////////////////////////////////////
//:: Check to see which Alienist feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////

#include "prc_inc_clsfunc"

void main()
{
    int nEvent = GetRunningEvent();
    object oPC = OBJECT_SELF;

    if(nEvent == FALSE)
    {
        object oSkin = GetPCSkin(oPC);

        if(GetHasFeat(FEAT_ALIEN_BLESSING, oPC))
        {
            SetCompositeBonus(oSkin, "AlienSave", 1, ITEM_PROPERTY_SAVING_THROW_BONUS, IP_CONST_SAVEVS_UNIVERSAL);
            /*if(GetPersistantLocalInt(oPC, "NWNX_AlienistWis") != -2)
                SetCompositeBonus(oSkin, "AlienWis", 2, ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_WIS);*/
        }
        if(GetHasFeat(FEAT_MAD_CERTAINTY, oPC) || GetHasFeat(FEAT_INSANE_CERTAINTY, oPC))
        {
            int nPhobiaIPFeat = GetPhobiaFeat(GetPhobia(oPC));
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(nPhobiaIPFeat), oSkin);
        }
        if(GetHasFeat(FEAT_TRANSCENDENCE,oPC))
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_CHARM_PERSON), oSkin);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_DOMINATE_PERSON), oSkin);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_HOLD_PERSON), oSkin);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_MASS_CHARM), oSkin);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGERESIST_20), oSkin);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,IP_CONST_DAMAGESOAK_20_HP), oSkin);

/*             AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "prc_alienist", TRUE, FALSE);
            AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_alienist", TRUE, FALSE); */
        }
    }
/*     else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        object oItem = GetItemLastUnequipped();
        if(GetBaseItemType(oItem) != BASE_ITEM_HELMET)
            return;

        object oSkin = GetPCSkin(GetItemLastUnequippedBy());
        SetCompositeBonus(oSkin, "Trans_intimidate", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);
        SetCompositeBonus(oSkin, "Trans_animalem", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_ANIMAL_EMPATHY);
        SetCompositeBonus(oSkin, "Trans_bluff", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
        SetCompositeBonus(oSkin, "Trans_perform", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERFORM);
        SetCompositeBonus(oSkin, "Trans_persuade", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
        SetCompositeBonus(oSkin, "Trans_umd", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_USE_MAGIC_DEVICE);
        SetCompositeBonus(oSkin, "Trans_iaijutsu", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_IAIJUTSU_FOCUS);
    }
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        object oItem = GetItemLastEquipped();
        if(GetBaseItemType(oItem) != BASE_ITEM_HELMET)
            return;

        object oSkin = GetPCSkin(GetItemLastUnequippedBy());
        SetCompositeBonus(oSkin, "Trans_intimidate", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);
        SetCompositeBonus(oSkin, "Trans_animalem", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_ANIMAL_EMPATHY);
        SetCompositeBonus(oSkin, "Trans_bluff", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
        SetCompositeBonus(oSkin, "Trans_perform", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERFORM);
        SetCompositeBonus(oSkin, "Trans_persuade", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
        SetCompositeBonus(oSkin, "Trans_umd", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_USE_MAGIC_DEVICE);
        SetCompositeBonus(oSkin, "Trans_iaijutsu", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_IAIJUTSU_FOCUS);
    } */
}