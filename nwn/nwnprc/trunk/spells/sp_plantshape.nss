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
#include "prc_misc_const"


void wild_shape_shift(object oPC, int nShape)
{
    string sResRef = Get2DACache("prc_polymorph", "ResRef", nShape);
    StoreCurrentAppearanceAsTrueAppearance(oPC, TRUE);
    ShiftIntoResRef(oPC, SHIFTER_TYPE_DRUID, sResRef);
}

void WildshapePlantPoly(object oPC, int nPoly)
{
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly = SupernaturalEffect(EffectPolymorph(nPoly));

    int bMonkGloves      = GetLocalInt(oPC, "WEARING_MONK_GLOVES");
    int bArmsSlotAllowed = GetPRCSwitch(PRC_WILDSHAPE_ALLOWS_ARMS_SLOT);

    int bWeapon = StringToInt(Get2DACache("polymorph","MergeW",nPoly)) == 1;
    int bArmor  = StringToInt(Get2DACache("polymorph","MergeA",nPoly)) == 1;
    int bItems  = StringToInt(Get2DACache("polymorph","MergeI",nPoly)) == 1;

    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oArmorOld  = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
    object oRing1Old  = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oPC);
    object oRing2Old  = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oPC);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,oPC);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,oPC);
    object oBeltOld   = GetItemInSlot(INVENTORY_SLOT_BELT,oPC);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
    object oGlovesOld = GetItemInSlot(INVENTORY_SLOT_ARMS,oPC);

    if (GetIsObjectValid(oShield))
    {
        int nShieldType = GetBaseItemType(oShield);
        if (nShieldType != BASE_ITEM_LARGESHIELD &&
            nShieldType != BASE_ITEM_SMALLSHIELD &&
            nShieldType != BASE_ITEM_TOWERSHIELD)
        {
            oShield = OBJECT_INVALID;
        }
    }

    ShifterCheck(oPC);
    ClearAllActions();

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC);

    object oWeaponNewRight = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
    object oWeaponNewLeft  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
    object oWeaponNewBite  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);
    object oArmorNew       = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);

    //:: Weapon & Armor merge block
    object oMergeWeaponSource = OBJECT_INVALID;
    object oMergeArmorSource  = OBJECT_INVALID;

    //:: Determine Weapon Merge Source
    if (bWeapon)
    {
        if (bMonkGloves)
        {
            if (GetIsObjectValid(oGlovesOld))
                oMergeWeaponSource = oGlovesOld;
        }
        else
        {
            //:: Always attempt to merge melee weapon to creature weapon
            oMergeWeaponSource = oWeaponOld; // even if empty, ensures proper state
        }
    }
    else
    {
        //:: Weapon not requested, but arms-slot allowed monk gloves can merge via armor branch
        if (bMonkGloves && bArmsSlotAllowed && GetIsObjectValid(oGlovesOld))
            oMergeWeaponSource = oGlovesOld;
    }

    //:: Determine Armor Merge Source
    if (bArmor && GetIsObjectValid(oArmorNew))
    {
        if (!bMonkGloves)
        {
            if (bArmsSlotAllowed && GetIsObjectValid(oGlovesOld))
                oMergeArmorSource = oGlovesOld;

            if (GetIsObjectValid(oShield))    IPWildShapeCopyItemProperties(oShield, oArmorNew);
            if (GetIsObjectValid(oHelmetOld)) IPWildShapeCopyItemProperties(oHelmetOld, oArmorNew);
            if (GetIsObjectValid(oArmorOld))  IPWildShapeCopyItemProperties(oArmorOld, oArmorNew);
        }
        else
        {
            if (GetIsObjectValid(oShield))    IPWildShapeCopyItemProperties(oShield, oArmorNew);
            if (GetIsObjectValid(oHelmetOld)) IPWildShapeCopyItemProperties(oHelmetOld, oArmorNew);
            if (GetIsObjectValid(oArmorOld))  IPWildShapeCopyItemProperties(oArmorOld, oArmorNew);
        }
    }
    else if (bArmor && !GetIsObjectValid(oArmorNew) && DEBUG)
    {
        DoDebug("LycanthropePoly: MergeA set, but oArmorNew invalid.");
    }

    //:: Apply Weapon Merge
    if (GetIsObjectValid(oMergeWeaponSource) || bWeapon)
    {
        //:: Always attempt to merge weapon properties even if source is OBJECT_INVALID
        if (GetIsObjectValid(oWeaponNewLeft))  IPWildShapeCopyItemProperties(oMergeWeaponSource, oWeaponNewLeft, TRUE);
        if (GetIsObjectValid(oWeaponNewRight)) IPWildShapeCopyItemProperties(oMergeWeaponSource, oWeaponNewRight, TRUE);
        if (GetIsObjectValid(oWeaponNewBite))  IPWildShapeCopyItemProperties(oMergeWeaponSource, oWeaponNewBite, TRUE);
    }

    //:: Apply Armor Merge
    if (GetIsObjectValid(oMergeArmorSource))
    {
        if (GetIsObjectValid(oArmorNew)) IPWildShapeCopyItemProperties(oMergeArmorSource, oArmorNew);
    }

    //:: General item merge block
    if (bItems && GetIsObjectValid(oArmorNew))
    {
        if (GetIsObjectValid(oRing1Old))  IPWildShapeCopyItemProperties(oRing1Old, oArmorNew);
        if (GetIsObjectValid(oRing2Old))  IPWildShapeCopyItemProperties(oRing2Old, oArmorNew);
        if (GetIsObjectValid(oAmuletOld)) IPWildShapeCopyItemProperties(oAmuletOld, oArmorNew);
        if (GetIsObjectValid(oCloakOld))  IPWildShapeCopyItemProperties(oCloakOld, oArmorNew);
        if (GetIsObjectValid(oBootsOld))  IPWildShapeCopyItemProperties(oBootsOld, oArmorNew);
        if (GetIsObjectValid(oBeltOld))   IPWildShapeCopyItemProperties(oBeltOld, oArmorNew);
    }
}


/* void WildshapePlantPoly(object oPC, int nPoly)
{
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly = SupernaturalEffect(EffectPolymorph(nPoly));

    int bMonkGloves = GetLocalInt(oPC, "WEARING_MONK_GLOVES");
    int bArmsSlotAllowed = GetPRCSwitch(PRC_WILDSHAPE_ALLOWS_ARMS_SLOT);

    int bWeapon = StringToInt(Get2DACache("polymorph","MergeW",nPoly)) == 1;
    int bArmor  = StringToInt(Get2DACache("polymorph","MergeA",nPoly)) == 1;
    int bItems  = StringToInt(Get2DACache("polymorph","MergeI",nPoly)) == 1;

    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oArmorOld = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
    object oRing1Old = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oPC);
    object oRing2Old = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oPC);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,oPC);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,oPC);
    object oBeltOld   = GetItemInSlot(INVENTORY_SLOT_BELT,oPC);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
    object oGlovesOld = GetItemInSlot(INVENTORY_SLOT_ARMS,oPC);

    if (GetIsObjectValid(oShield))
    {
        int nShieldType = GetBaseItemType(oShield);
        if (nShieldType != BASE_ITEM_LARGESHIELD &&
            nShieldType != BASE_ITEM_SMALLSHIELD &&
            nShieldType != BASE_ITEM_TOWERSHIELD)
        {
            oShield = OBJECT_INVALID;
        }
    }

    ShifterCheck(oPC);
    ClearAllActions();

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC);

    object oWeaponNewRight = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
    object oWeaponNewLeft  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
    object oWeaponNewBite  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);
    object oArmorNew       = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);

	//::   Weapon merge block
	//::  Only blocked if monk gloves are equipped AND arms-slot merge is NOT allowed
    if (bWeapon && !bMonkGloves)
    {
        if (GetIsObjectValid(oWeaponOld))
        {
            if (GetIsObjectValid(oWeaponNewLeft))  IPWildShapeCopyItemProperties(oWeaponOld, oWeaponNewLeft, TRUE);
            if (GetIsObjectValid(oWeaponNewRight)) IPWildShapeCopyItemProperties(oWeaponOld, oWeaponNewRight, TRUE);
            if (GetIsObjectValid(oWeaponNewBite))  IPWildShapeCopyItemProperties(oWeaponOld, oWeaponNewBite, TRUE);
        }
    }
    else if (bWeapon && bMonkGloves && !bArmsSlotAllowed)
    {
        if (DEBUG) DoDebug("LycanthropePoly: Monk gloves overriding weapon merge (arms slot NOT allowed).");
        if (GetIsObjectValid(oGlovesOld))
        {
            if (GetIsObjectValid(oWeaponNewLeft))  IPWildShapeCopyItemProperties(oGlovesOld, oWeaponNewLeft, TRUE);
            if (GetIsObjectValid(oWeaponNewRight)) IPWildShapeCopyItemProperties(oGlovesOld, oWeaponNewRight, TRUE);
            if (GetIsObjectValid(oWeaponNewBite))  IPWildShapeCopyItemProperties(oGlovesOld, oWeaponNewBite, TRUE);
        }
    }

	//:: Armor merge block
	//:: Apply armor and gloves (if arms-slot allowed)
    if (bArmor && GetIsObjectValid(oArmorNew))
    {
        if (GetIsObjectValid(oShield))      IPWildShapeCopyItemProperties(oShield, oArmorNew);
        if (GetIsObjectValid(oHelmetOld))   IPWildShapeCopyItemProperties(oHelmetOld, oArmorNew);
        if (GetIsObjectValid(oArmorOld))    IPWildShapeCopyItemProperties(oArmorOld, oArmorNew);

        if (bArmsSlotAllowed && bMonkGloves && GetIsObjectValid(oGlovesOld))
        {
            if (DEBUG) DoDebug("LycanthropePoly: Arms-slot allowed -> applying gloves to creature weapons from armor branch.");
            if (GetIsObjectValid(oWeaponNewLeft))  IPWildShapeCopyItemProperties(oGlovesOld, oWeaponNewLeft, TRUE);
            if (GetIsObjectValid(oWeaponNewRight)) IPWildShapeCopyItemProperties(oGlovesOld, oWeaponNewRight, TRUE);
            if (GetIsObjectValid(oWeaponNewBite))  IPWildShapeCopyItemProperties(oGlovesOld, oWeaponNewBite, TRUE);
        }
    }
    else if (bArmor && !GetIsObjectValid(oArmorNew) && DEBUG)
    {
        DoDebug("LycanthropePoly: MergeA set, but oArmorNew invalid.");
    }

    //:: General item merge block
    if (bItems && GetIsObjectValid(oArmorNew))
    {
        if (GetIsObjectValid(oRing1Old)) IPWildShapeCopyItemProperties(oRing1Old, oArmorNew);
        if (GetIsObjectValid(oRing2Old)) IPWildShapeCopyItemProperties(oRing2Old, oArmorNew);
        if (GetIsObjectValid(oAmuletOld)) IPWildShapeCopyItemProperties(oAmuletOld, oArmorNew);
        if (GetIsObjectValid(oCloakOld)) IPWildShapeCopyItemProperties(oCloakOld, oArmorNew);
        if (GetIsObjectValid(oBootsOld)) IPWildShapeCopyItemProperties(oBootsOld, oArmorNew);
        if (GetIsObjectValid(oBeltOld))  IPWildShapeCopyItemProperties(oBeltOld, oArmorNew);
    }
}
 */

void main()
{
    object oPC = OBJECT_SELF;
    int nSpell = GetSpellId();
	object oTarget = PRCGetSpellTargetObject();
    int nPoly;
	
	SignalEvent(oTarget, EventSpellCastAt(oPC, SPELLABILITY_WILD_SHAPE, FALSE));
	
	if (!GetLocalInt(GetModule(),"X3_NO_SHAPESHIFT_SPELL_CHECK"))
    { // check to see if abort due to being mounted
        if (PRCHorseGetIsMounted(oTarget))
        { // abort
            if (GetIsPC(oTarget)) FloatingTextStrRefOnCreature(111982,oTarget,FALSE);
              return;
        } // abort
    } // check to see if abort due to being mounted	
	
    int nShape = GetPersistantLocalInt(oPC, PRC_PNP_SHIFTING + IntToString(nSpell));
    if(nShape > 0)
    {
        wild_shape_shift(oPC, nShape);
        return;
    }	

    switch (nSpell)
    {
        case 3642: nPoly = POLYMORPH_TYPE_TREANT; break;
        case 3643: nPoly = POLYMORPH_TYPE_SHAMBLING_MOUND; break;
        case 3644: nPoly = POLYMORPH_TYPE_TWIG_BLIGHT; break;
        case 3645: nPoly = POLYMORPH_TYPE_MYCONID; break;
        case 3646: nPoly = POLYMORPH_TYPE_ALGOID; break;
        default:
            if (DEBUG) DoDebug("WildShapePlant: Unknown spell ID.");
            return;
    }

    //WildshapePlantPoly(oPC, nPoly);
	LycanthropePoly(oPC, nPoly);
}



/* void main()
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

    int nShape = GetPersistantLocalInt(oPC, PRC_PNP_SHIFTING + IntToString(nSpell));
    if(nShape > 0)
    {
        wild_shape_shift(oPC, nShape);
        return;
    }

    //Determine Polymorph subradial type
    if(nSpell == 3642)
    {
        nPoly = POLYMORPH_TYPE_TREANT;
    }
    else if (nSpell == 3643)
    {
        nPoly = POLYMORPH_TYPE_SHAMBLING_MOUND;
    }
    else if (nSpell == 3644)
    {
        nPoly = POLYMORPH_TYPE_TWIG_BLIGHT;
    }
    else if (nSpell == 3645)
    {
        nPoly = POLYMORPH_TYPE_MYCONID;
    }
    else if (nSpell == 3646)
    {
        nPoly = POLYMORPH_TYPE_ALGOID;
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
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, OBJECT_SELF, HoursToSeconds(nDuration));

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
 */