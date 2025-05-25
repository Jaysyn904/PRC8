#include "prc_inc_clsfunc"
#include "psi_inc_soulkn"
#include "prc_inc_combat"


// Sanctify_Feat(iType);

int Sanctify_Feat_Wrapper(int nType, object oPC, object oItem)
{
    return Sanctify_Feat(nType) ||
           (GetHasFeat(FEAT_SANCTIFY_MARTIAL_MINDBLADE) && GetIsMindblade(oItem));
}

int Vile_Feat_Wrapper(int nType, object oPC, object oItem)
{
    return Vile_Feat(nType) ||
           (GetHasFeat(FEAT_VILE_MARTIAL_MINDBLADE) && GetIsMindblade(oItem));
}

//const int SKILL_JUMP = 28; Moved to prc_misc_const

void Sanctify()
{

    object oItem;
    object oPC = OBJECT_SELF;
    int iType;
    int iEquip = GetLocalInt(oPC,"ONEQUIP");


    if (GetLocalInt(oItem,"MartialStrik")) return;

    if (iEquip==2)
    {
        if(GetHasFeat(FEAT_HOLY_MARTIAL_STRIKE)) return;

        oItem=GetItemLastEquipped();
        iType= GetBaseItemType(oItem);

        if(GetLocalInt(oItem,"SanctMar")) return ;

        switch (iType)
        {
            case BASE_ITEM_BOLT:
            case BASE_ITEM_BULLET:
            case BASE_ITEM_ARROW:
                iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
                break;
            case BASE_ITEM_SHORTBOW:
            case BASE_ITEM_LONGBOW:
                oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
                break;
            case BASE_ITEM_LIGHTCROSSBOW:
            case BASE_ITEM_HEAVYCROSSBOW:
                oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
                break;
            case BASE_ITEM_SLING:
                oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
                break;
        }

        if(!Sanctify_Feat_Wrapper(iType, oPC, oItem)) return;
				   
        itemproperty ip1 = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1);
					 ip1 = TagItemProperty(ip1,"Sanctify1");
		AddItemProperty(DURATION_TYPE_TEMPORARY,ip1,oItem,9999.0);
		itemproperty ip2 = ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1d4);
					 ip2 = TagItemProperty(ip2,"Sanctify2");
		AddItemProperty(DURATION_TYPE_TEMPORARY,ip2,oItem,9999.0);
		itemproperty ip3 = ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1d4);
					 ip3 = TagItemProperty(ip3,"Sanctify3");
		AddItemProperty(DURATION_TYPE_TEMPORARY,ip3,oItem,9999.0);
		itemproperty ip4 = ItemPropertyVisualEffect(ITEM_VISUAL_HOLY);
					 ip4 = TagItemProperty(ip4,"Sanctify4");
		AddItemProperty(DURATION_TYPE_TEMPORARY,ip4,oItem,9999.0);
        SetLocalInt(oItem,"SanctMar",1);
		
    }
    else if (iEquip==1)
    {
        if(GetHasFeat(FEAT_HOLY_MARTIAL_STRIKE)) return;

        oItem=GetItemLastUnequipped();
        iType= GetBaseItemType(oItem);

        switch (iType)
        {
            case BASE_ITEM_BOLT:
            case BASE_ITEM_BULLET:
            case BASE_ITEM_ARROW:
                iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
                break;
            case BASE_ITEM_SHORTBOW:
            case BASE_ITEM_LONGBOW:
                oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
                break;
            case BASE_ITEM_LIGHTCROSSBOW:
            case BASE_ITEM_HEAVYCROSSBOW:
                oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
                break;
            case BASE_ITEM_SLING:
                oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
                break;
        }

        //    if (!Sanctify_Feat(iType)) return;


        if(GetLocalInt(oItem,"SanctMar"))
        {
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_1, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
            DeleteLocalInt(oItem,"SanctMar");
        }

    }
    else
    {

        oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
        iType= GetBaseItemType(oItem);

        if (GetHasFeat(FEAT_HOLY_MARTIAL_STRIKE))
        {
            object oItem2=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

            switch (iType)
            {

                case BASE_ITEM_SHORTBOW:
                case BASE_ITEM_LONGBOW:
                    oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
                    break;
                case BASE_ITEM_LIGHTCROSSBOW:
                case BASE_ITEM_HEAVYCROSSBOW:
                    oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
                    break;
                case BASE_ITEM_SLING:
                    oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
                    break;
            }

            if ( GetLocalInt(oItem,"SanctMar"))
            {
                RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_1, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
                RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
                RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
                RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
                DeleteLocalInt(oItem,"SanctMar");
            }
            if ( GetLocalInt(oItem2,"SanctMar"))
            {
                RemoveSpecificProperty(oItem2,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_1, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
                RemoveSpecificProperty(oItem2,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
                RemoveSpecificProperty(oItem2,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
                RemoveSpecificProperty(oItem2,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
                DeleteLocalInt(oItem2,"SanctMar");
            }
            return;
        }

        switch (iType)
        {
            case BASE_ITEM_BOLT:
            case BASE_ITEM_BULLET:
            case BASE_ITEM_ARROW:
                iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
                break;
            case BASE_ITEM_SHORTBOW:
            case BASE_ITEM_LONGBOW:
                oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
                break;
            case BASE_ITEM_LIGHTCROSSBOW:
            case BASE_ITEM_HEAVYCROSSBOW:
                oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
                break;
            case BASE_ITEM_SLING:
                oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
                break;
        }

        if(Sanctify_Feat_Wrapper(iType, oPC, oItem) &&  (!GetLocalInt(oItem,"SanctMar")))
        {
			itemproperty ip1 = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1);
						 ip1 = TagItemProperty(ip1,"Sanctify1");
			AddItemProperty(DURATION_TYPE_TEMPORARY,ip1,oItem,9999.0);
			itemproperty ip2 = ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1d4);
						 ip2 = TagItemProperty(ip2,"Sanctify2");
			AddItemProperty(DURATION_TYPE_TEMPORARY,ip2,oItem,9999.0);
			itemproperty ip3 = ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1d4);
						 ip3 = TagItemProperty(ip3,"Sanctify3");
			AddItemProperty(DURATION_TYPE_TEMPORARY,ip3,oItem,9999.0);
			itemproperty ip4 = ItemPropertyVisualEffect(ITEM_VISUAL_HOLY);
						 ip4 = TagItemProperty(ip4,"Sanctify4");
			AddItemProperty(DURATION_TYPE_TEMPORARY,ip4,oItem,9999.0);
			SetLocalInt(oItem,"SanctMar",1);
        }

        oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
        iType= GetBaseItemType(oItem);
        if(Sanctify_Feat_Wrapper(iType, oPC, oItem) &&  (!GetLocalInt(oItem,"SanctMar")))
        {
			itemproperty ip1 = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1);
						 ip1 = TagItemProperty(ip1,"Sanctify1");
			AddItemProperty(DURATION_TYPE_TEMPORARY,ip1,oItem,9999.0);
			itemproperty ip2 = ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1d4);
						 ip2 = TagItemProperty(ip2,"Sanctify2");
			AddItemProperty(DURATION_TYPE_TEMPORARY,ip2,oItem,9999.0);
			itemproperty ip3 = ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1d4);
						 ip3 = TagItemProperty(ip3,"Sanctify3");
			AddItemProperty(DURATION_TYPE_TEMPORARY,ip3,oItem,9999.0);
			itemproperty ip4 = ItemPropertyVisualEffect(ITEM_VISUAL_HOLY);
						 ip4 = TagItemProperty(ip4,"Sanctify4");
			AddItemProperty(DURATION_TYPE_TEMPORARY,ip4,oItem,9999.0);
			SetLocalInt(oItem,"SanctMar",1);
        }
    }

}

void Vile()
{

    object oItem;
    object oPC = OBJECT_SELF;
    int iType;

    //   if (GetLocalInt(oPC,"ONENTER")) return;

    int iEquip=GetLocalInt(oPC,"ONEQUIP");


    //if (GetLocalInt(oItem,"UnholyStrik")) return;

    if (iEquip==2)
    {
        //if (GetHasFeat(FEAT_UNHOLY_STRIKE)) return;

        oItem=GetItemLastEquipped();
        iType= GetBaseItemType(oItem);

        if ( GetLocalInt(oItem,"USanctMar")) return ;

        switch (iType)
        {
            case BASE_ITEM_BOLT:
            case BASE_ITEM_BULLET:
            case BASE_ITEM_ARROW:
                iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
                break;
            case BASE_ITEM_SHORTBOW:
            case BASE_ITEM_LONGBOW:
                oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
                break;
            case BASE_ITEM_LIGHTCROSSBOW:
            case BASE_ITEM_HEAVYCROSSBOW:
                oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
                break;
            case BASE_ITEM_SLING:
                oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
                break;
        }

        if(!Vile_Feat_Wrapper(iType, oPC, oItem)) return;

        int nAlign = GetGoodEvilValue(oPC);
        if(nAlign > 7)
            AdjustAlignment(oPC, ALIGNMENT_EVIL, 7, FALSE);

        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1),oItem,9999.0);
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVisualEffect(ITEM_VISUAL_EVIL),oItem,9999.0);
        SetLocalInt(oItem,"USanctMar",1);
    }
    else if (iEquip==1)
    {
        //if (GetHasFeat(FEAT_UNHOLY_STRIKE)) return;

        oItem=GetItemLastUnequipped();
        iType= GetBaseItemType(oItem);

        switch (iType)
        {
            case BASE_ITEM_BOLT:
            case BASE_ITEM_BULLET:
            case BASE_ITEM_ARROW:
            iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
            break;
            case BASE_ITEM_SHORTBOW:
            case BASE_ITEM_LONGBOW:
            oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
            break;
            case BASE_ITEM_LIGHTCROSSBOW:
            case BASE_ITEM_HEAVYCROSSBOW:
            oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
            break;
            case BASE_ITEM_SLING:
            oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
            break;
        }

        //    if (!Sanctify_Feat(iType)) return;


        if ( GetLocalInt(oItem,"USanctMar"))
        {
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1,1,"",-1,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_EVIL,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
            DeleteLocalInt(oItem,"USanctMar");
        }

    }
    else
    {

        oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
        iType= GetBaseItemType(oItem);

        switch (iType)
        {
            case BASE_ITEM_BOLT:
            case BASE_ITEM_BULLET:
            case BASE_ITEM_ARROW:
                iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
                break;
            case BASE_ITEM_SHORTBOW:
            case BASE_ITEM_LONGBOW:
                oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
                break;
            case BASE_ITEM_LIGHTCROSSBOW:
            case BASE_ITEM_HEAVYCROSSBOW:
                oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
                break;
            case BASE_ITEM_SLING:
                oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
                break;
        }

        if (Vile_Feat_Wrapper(iType, oPC, oItem) && (!GetLocalInt(oItem,"USanctMar")))
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1),oItem,9999.0);
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVisualEffect(ITEM_VISUAL_EVIL),oItem,9999.0);
            SetLocalInt(oItem,"USanctMar",1);
            int nAlign = GetGoodEvilValue(OBJECT_SELF);
            if (nAlign>7)
                AdjustAlignment(oPC,ALIGNMENT_EVIL,7, FALSE);

        }

        oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
        iType= GetBaseItemType(oItem);
        if(Vile_Feat_Wrapper(iType, oPC, oItem) && (!GetLocalInt(oItem,"USanctMar")))
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1),oItem,9999.0);
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyVisualEffect(ITEM_VISUAL_EVIL),oItem,9999.0);
            SetLocalInt(oItem,"USanctMar",1);
            int nAlign = GetGoodEvilValue(OBJECT_SELF);
            if (nAlign>7)
                AdjustAlignment(oPC,ALIGNMENT_EVIL,7, FALSE);
        }
    }

}

void Pwatk(object oPC)
{
	object oSkin = GetPCSkin(oPC);
	int n = 47 - 12 - 19 - 6;
	int i = 9 * 2;
    SetCompositeBonus(oSkin, "898y4546", 50, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, i);
    SetCompositeBonus(oSkin, "fghjklh", 50, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, n);
    if (GetLocalInt(oPC,"ONEQUIP")!= 2 ) return;

    object oItem = GetItemLastEquipped();

    // don't run this if the equipped item is not a weapon
    if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) != oItem) return;

    if (!GetWeaponRanged(oItem))
    {
        int iSpell = GetHasSpellEffect(SPELL_PA_POWERSHOT,oPC)     ||
        GetHasSpellEffect(SPELL_PA_IMP_POWERSHOT,oPC) ||
        GetHasSpellEffect(SPELL_PA_SUP_POWERSHOT,oPC);

        if(iSpell)
        {
            PRCRemoveSpellEffects(iSpell,oPC,oPC);

            string nMes = "*Power Shot Mode Deactivated*";
            FloatingTextStringOnCreature(nMes, oPC, FALSE);
        }
    }

}

void main()
{
    object oPC = OBJECT_SELF;

    Pwatk(oPC);

    object oSkin = GetPCSkin(oPC);

    if (GetAlignmentGoodEvil(oPC)!= ALIGNMENT_GOOD)
    {

        object oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
        int iType= GetBaseItemType(oItem);

        switch (iType)
        {
            case BASE_ITEM_BOLT:
            case BASE_ITEM_BULLET:
            case BASE_ITEM_ARROW:
            iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
            break;
            case BASE_ITEM_SHORTBOW:
            case BASE_ITEM_LONGBOW:
            oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
            break;
            case BASE_ITEM_LIGHTCROSSBOW:
            case BASE_ITEM_HEAVYCROSSBOW:
            oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
            break;
            case BASE_ITEM_SLING:
            oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
            break;
        }


        if ( GetLocalInt(oItem,"SanctMar"))
        {
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_1, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
            DeleteLocalInt(oItem,"SanctMar");
        }

        if (GetLocalInt(oItem,"MartialStrik"))
        {
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_2d6, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
            DeleteLocalInt(oItem,"MartialStrik");
        }
        oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
        iType= GetBaseItemType(oItem);

        if ( GetLocalInt(oItem,"SanctMar"))
        {
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_1, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_UNDEAD,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGEBONUS_1d4, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
            DeleteLocalInt(oItem,"SanctMar");
        }

        if ( GetLocalInt(oItem,"MartialStrik"))
        {
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_2d6, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_HOLY,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
            DeleteLocalInt(oItem,"MartialStrik");
        }
        if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
        {
            //Vile();
            UnholyStrike();
        }
    }
    else if (GetAlignmentGoodEvil(oPC)!= ALIGNMENT_EVIL)
    {

        object oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
        int iType= GetBaseItemType(oItem);

        switch (iType)
        {
            case BASE_ITEM_BOLT:
            case BASE_ITEM_BULLET:
            case BASE_ITEM_ARROW:
            iType=GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
            break;
            case BASE_ITEM_SHORTBOW:
            case BASE_ITEM_LONGBOW:
            oItem=GetItemInSlot(INVENTORY_SLOT_ARROWS);
            break;
            case BASE_ITEM_LIGHTCROSSBOW:
            case BASE_ITEM_HEAVYCROSSBOW:
            oItem=GetItemInSlot(INVENTORY_SLOT_BOLTS);
            break;
            case BASE_ITEM_SLING:
            oItem=GetItemInSlot(INVENTORY_SLOT_BULLETS);
            break;
        }

        /*
        if ( GetLocalInt(oItem,"USanctMar"))
        {
        RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1,1,"",-1,DURATION_TYPE_TEMPORARY);
        RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_EVIL,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
        DeleteLocalInt(oItem,"USanctMar");
        }
        */
        if (GetLocalInt(oItem,"UnholyStrik"))
        {
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_GOOD,IP_CONST_DAMAGEBONUS_2d6, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_EVIL,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
            DeleteLocalInt(oItem,"UnholyStrik");
        }

        oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
        iType= GetBaseItemType(oItem);
        /*
        if ( GetLocalInt(oItem,"USanctMar"))
        {
        RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1,1,"",-1,DURATION_TYPE_TEMPORARY);
        RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_EVIL,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
        DeleteLocalInt(oItem,"USanctMar");
        }
        */
        if ( GetLocalInt(oItem,"UnholyStrik"))
        {
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_GOOD,IP_CONST_DAMAGEBONUS_2d6, 1,"",IP_CONST_DAMAGETYPE_DIVINE,DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_VISUALEFFECT,ITEM_VISUAL_EVIL,-1,1,"",-1,DURATION_TYPE_TEMPORARY);
            DeleteLocalInt(oItem,"UnholyStrik");
        }

        if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
        {
            Sanctify();
            MartialStrike();
        }
		
		if(GetIsUnarmed(oPC))
		{
			effect eCheckEffect = GetFirstEffect(oPC);
			while (GetIsEffectValid(eCheckEffect))
			{
				if(GetEffectTag(eCheckEffect) == "VoPFeat"+IntToString(FEAT_SANCTIFYKISTRIKE))   SetLocalInt(oPC,"VoPFeat"+IntToString(FEAT_SANCTIFYKISTRIKE),1);
				if(GetEffectTag(eCheckEffect) == "VoPFeat"+IntToString(FEAT_HOLYKISTRIKE))       SetLocalInt(oPC,"VoPFeat"+IntToString(FEAT_HOLYKISTRIKE),1);
				eCheckEffect = GetNextEffect(oPC);
			}
			// Sanctify Strike
			if (GetHasFeat(FEAT_SANCTIFYKISTRIKE, oPC) || GetLocalInt(oPC, "VoPFeat"+IntToString(FEAT_SANCTIFYKISTRIKE)))
			{	
				effect eEffect1 = VersusAlignmentEffect(EffectDamageIncrease(DAMAGE_BONUS_1,DAMAGE_TYPE_POSITIVE),ALIGNMENT_ALL,ALIGNMENT_EVIL);
				effect eEffect2 = VersusRacialTypeEffect(EffectDamageIncrease(DAMAGE_BONUS_1d4,DAMAGE_TYPE_POSITIVE),RACIAL_TYPE_OUTSIDER);
				effect eLink    = EffectLinkEffects(eEffect1,eEffect2);
					   eLink    = TagEffect(eLink,"SanctifyKiStrike");
				
				//Remove any prior bonus to avoid duplication
				effect eCheckEffect = GetFirstEffect(oPC);
				while (GetIsEffectValid(eCheckEffect))
				{
					if(GetEffectTag(eCheckEffect) == "SanctifyKiStrike") RemoveEffect(oPC, eCheckEffect);
					eCheckEffect = GetNextEffect(oPC);
				}
				
				//Give player the bonus
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC); 	
			}
			
			// Holy Ki Strike
			if (GetHasFeat(FEAT_HOLYKISTRIKE, oPC) || GetLocalInt(oPC, "VoPFeat"+IntToString(FEAT_HOLYKISTRIKE)))
			{
				effect eEffect1 = VersusAlignmentEffect(EffectDamageIncrease(DAMAGE_BONUS_2d6,DAMAGE_TYPE_POSITIVE),ALIGNMENT_ALL,ALIGNMENT_EVIL);
					   eEffect1 = TagEffect(eEffect1,"HolyKiStrike");
				
				//Remove any prior bonus to avoid duplication and remove Sanctify Ki Strike
				effect eCheckEffect = GetFirstEffect(oPC);
				while (GetIsEffectValid(eCheckEffect))
				{
					if(GetEffectTag(eCheckEffect) == "SanctifyKiStrike" || GetEffectTag(eCheckEffect) == "HolyKiStrike") RemoveEffect(oPC, eCheckEffect);
					eCheckEffect = GetNextEffect(oPC);
				}
				
				//Give player the bonus
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect1, oPC); 	
			}
		}
		else
		{
			effect eCheckEffect = GetFirstEffect(oPC);
			while (GetIsEffectValid(eCheckEffect))
			{
				if(GetEffectTag(eCheckEffect) == "SanctifyKiStrike" || GetEffectTag(eCheckEffect) == "HolyKiStrike") RemoveEffect(oPC, eCheckEffect);
				eCheckEffect = GetNextEffect(oPC);
			}
		}
    }

    Vile();
    //WeapEnh();
}