/*
    Henshin Mystic class functions.
    These are all the funstions that the Henshin Mystic pr class
    uses.

    Jeremiah Teague

    Rewritten by Stratovarius to use CompositeBonus
    
    Fixed by Jaysyn to work more like PnP
*/
#include "prc_inc_unarmed"

void main ()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nLvl = GetLevelByClass(CLASS_TYPE_HENSHIN_MYSTIC, oPC);

    //UnarmedFeats(oPC);
    //UnarmedFists(oPC);
    SetLocalInt(oPC, CALL_UNARMED_FEATS, TRUE);
    SetLocalInt(oPC, CALL_UNARMED_FISTS, TRUE);

    // HappoZanshin - Immune to Sneak Attacks
    if(nLvl > 2)
    {
        if(GetLocalInt(oSkin, "Happo"))
            return;
		
		effect eHappo = EffectBonusFeat(FEAT_PRESTIGE_DEFENSIVE_AWARENESS_2);
		effect eLink = EffectLinkEffects(eLink, eHappo);
		
		eLink = ExtraordinaryEffect(eLink);
		
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
		
        //AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB), oSkin);
        //SetLocalInt(oSkin, "Happo", TRUE);
    }

    // Interaction - +4 to Taunt, Persuade, Bluff, and Intimidate
    if(nLvl > 3)
    {
        if(GetLocalInt(oSkin, "InterP") == 4)
            return;

        SetCompositeBonus(oSkin, "InterP", 4, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
        SetCompositeBonus(oSkin, "InterS", 4, ITEM_PROPERTY_SKILL_BONUS,SKILL_SENSE_MOTIVE);
        SetCompositeBonus(oSkin, "InterB", 4, ITEM_PROPERTY_SKILL_BONUS,SKILL_BLUFF);
        SetCompositeBonus(oSkin, "InterI", 4, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
    }

    // Invulerability
    if(nLvl > 9)
    {
        if(GetLocalInt(oSkin, "HMInvul"))
            return;

        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_20_HP), oSkin);
        SetLocalInt(oSkin, "HMInvul", TRUE);
    }
}