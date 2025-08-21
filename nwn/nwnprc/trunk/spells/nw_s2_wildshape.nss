//::///////////////////////////////////////////////
//:: Wild Shape
//:: NW_S2_WildShape
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allows the Druid to change into animal forms.

    Updated: Sept 30 2003, Georg Z.
      * Made Armor merge with druid to make forms
        more useful.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 22, 2002
//:://////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified Date: January 15th-16th, 2008
//:://////////////////////////////////////////////
/*
    Modified to insure no shapeshifting spells are castable upon
    mounted targets.  This prevents problems that can occur due
    to dismounting after shape shifting, or other issues that can
    occur due to preserved appearances getting out of synch.

    This can additional check can be disabled by setting the variable
    X3_NO_SHAPESHIFT_SPELL_CHECK to 1 on the module object.  If this
    variable is set then this script will function as it did prior to
    this modification.

*/

//#include "x3_inc_horse"
#include "prc_alterations"
#include "pnp_shft_poly"

void wild_shape_shift(object oPC, int nShape)
{
    string sResRef = Get2DACache("prc_polymorph", "ResRef", nShape);
    StoreCurrentAppearanceAsTrueAppearance(oPC, TRUE);
    ShiftIntoResRef(oPC, SHIFTER_TYPE_DRUID, sResRef);
}

void main()
{
    //Declare major variables
    int nSpell = GetSpellId();
    object oTarget = PRCGetSpellTargetObject();
    object oPC = OBJECT_SELF;
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly;
    int nPoly;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDuration = GetLevelByClass(CLASS_TYPE_DRUID, oPC)
                  + GetLevelByClass(CLASS_TYPE_ARCANE_HIEROPHANT, oPC);
	
	int bShiftingDruid = GetLocalInt(GetModule(),"PRC_DRUID_USES_SHIFTING");

    if (!GetLocalInt(GetModule(),"X3_NO_SHAPESHIFT_SPELL_CHECK"))
    { // check to see if abort due to being mounted
        if (PRCHorseGetIsMounted(oTarget))
        { // abort
            if (GetIsPC(oTarget)) FloatingTextStrRefOnCreature(111982,oTarget,FALSE);
              return;
        } // abort
    } // check to see if abort due to being mounted
    
    //Enter Metamagic conditions
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    //this command will make shore that polymorph plays nice with the shifter
    ShifterCheck(OBJECT_SELF);
	
	StoreCurrentAppearanceAsTrueAppearance(oPC, TRUE);

    int nShape = GetPersistantLocalInt(oPC, PRC_PNP_SHIFTING + IntToString(nSpell));
    if(nShape > 0)
    {
        wild_shape_shift(oPC, nShape);
        return;
    }

    //Determine Polymorph subradial type
	string sDruidShape;
	
    if(nSpell == 401)
    {
        if (bShiftingDruid)
		{
			if (nDuration < 12)
			{//:: Brown Bear 
				//ShiftIntoResRef(oPC, SHIFTER_TYPE_DRUID, "nw_bearbrwn", FALSE);
				sDruidShape = "nw_bearbrwn";
			}
			else
			{//:: Dire Bear
				//ShiftIntoResRef(oPC, SHIFTER_TYPE_DRUID, "nw_beardire", FALSE);
				sDruidShape = "nw_beardire";
			}			
		}
		else
		{
			nPoly = POLYMORPH_TYPE_BROWN_BEAR;
			if (nDuration >= 12)
			{
				nPoly = POLYMORPH_TYPE_DIRE_BROWN_BEAR;
			}
		}
    }
    else if (nSpell == 402)
    {
        nPoly = POLYMORPH_TYPE_PANTHER;
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_PANTHER;
        }
    }
    else if (nSpell == 403)
    {
        nPoly = POLYMORPH_TYPE_WOLF;

        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_WOLF;
        }
    }
    else if (nSpell == 404)
    {
        nPoly = POLYMORPH_TYPE_BOAR;
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_BOAR;
        }
    }
    else if (nSpell == 405)
    {
        nPoly = POLYMORPH_TYPE_BADGER;
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_BADGER;
        }
    }
    ePoly = EffectPolymorph(nPoly);
    ePoly = ExtraordinaryEffect(ePoly);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_WILD_SHAPE, FALSE));

    int bWeapon = StringToInt(Get2DACache("polymorph","MergeW",nPoly)) == 1;
    int bArmor  = StringToInt(Get2DACache("polymorph","MergeA",nPoly)) == 1;
    int bItems  = StringToInt(Get2DACache("polymorph","MergeI",nPoly)) == 1;

    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmorOld = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
    object oRing1Old = GetItemInSlot(INVENTORY_SLOT_LEFTRING,OBJECT_SELF);
    object oRing2Old = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,OBJECT_SELF);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,OBJECT_SELF);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,OBJECT_SELF);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,OBJECT_SELF);
    object oBeltOld = GetItemInSlot(INVENTORY_SLOT_BELT,OBJECT_SELF);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,OBJECT_SELF);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
    if (GetIsObjectValid(oShield))
    {
        if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
        {
            oShield = OBJECT_INVALID;
        }
    }

    ClearAllActions(); // prevents an exploit
    
    
    if (GetEssentiaInvestedFeat(OBJECT_SELF, FEAT_AZURE_WILD_SHAPE))
    	ePoly = EffectLinkEffects(ePoly, EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(GetEssentiaInvestedFeat(OBJECT_SELF, FEAT_AZURE_WILD_SHAPE)), DAMAGE_TYPE_BASE_WEAPON));

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
	if(bShiftingDruid)
	{
		ShiftIntoResRef(oPC, SHIFTER_TYPE_DRUID, sDruidShape, FALSE);
		DelayCommand(HoursToSeconds(nDuration), SetShiftTrueForm(oPC));
	}
	else
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, OBJECT_SELF, HoursToSeconds(nDuration));
	}

    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);

    if (bWeapon)
    {
            IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);
    }
    if (bArmor)
    {
        IPWildShapeCopyItemProperties(oShield,oArmorNew);
        IPWildShapeCopyItemProperties(oHelmetOld,oArmorNew);
        IPWildShapeCopyItemProperties(oArmorOld,oArmorNew);
    }
    if (bItems)
    {
        IPWildShapeCopyItemProperties(oRing1Old,oArmorNew);
        IPWildShapeCopyItemProperties(oRing2Old,oArmorNew);
        IPWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
        IPWildShapeCopyItemProperties(oCloakOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBootsOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBeltOld,oArmorNew);
    }

    DelayCommand(1.5,ActionCastSpellOnSelf(SPELL_SHAPE_INCREASE_DAMAGE));
}
