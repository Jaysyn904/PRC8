//::///////////////////////////////////////////////
//:: Wild Shape
//:: NW_S2_WildShape
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 22, 2002
//:: Edited by Wyz_sub10, Oct 2004 for Pixie SA
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"
//#include "x2_inc_spellhook"
#include "pnp_shft_poly"


void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    //Declare major variables
    int nSpell = GetSpellId();
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly;
    int nPoly;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDuration = 8;
    //Enter Metamagic conditions
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    //Determine Polymorph subradial type
    if(nSpell == 1979)
    {
        nPoly = POLYMORPH_TYPE_BROWN_BEAR;
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_BROWN_BEAR;
        }
    }
    else if (nSpell == 1980)
    {
        nPoly = POLYMORPH_TYPE_PANTHER;
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_PANTHER;
        }
    }
    else if (nSpell == 1981)
    {
        nPoly = POLYMORPH_TYPE_WOLF;

        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_WOLF;
        }
    }
    else if (nSpell == 1982)
    {
        nPoly = POLYMORPH_TYPE_BOAR;
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_BOAR;
        }
    }
    else if (nSpell == 1983)
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
            GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD)
        {
            oShield = OBJECT_INVALID;
        }
    }

    // abort if mounted
    if (!GetLocalInt(GetModule(),"X3_NO_SHAPESHIFT_SPELL_CHECK"))
    { // check to see if abort due to being mounted
        if (PRCHorseGetIsMounted(oTarget))
        { // abort
            if (GetIsPC(oTarget)) FloatingTextStrRefOnCreature(111982,oTarget,FALSE);
              return;
        } // abort
    } // check to see if abort due to being mounted

    //this command will make shore that polymorph plays nice with the shifter
    ShifterCheck(oTarget);
    
    AssignCommand(oTarget, ClearAllActions()); // prevents an exploit

    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oTarget, HoursToSeconds(nDuration),TRUE,-1,8);
    DelayCommand(1.5,ActionCastSpellOnSelf(SPELL_SHAPE_INCREASE_DAMAGE));

    //Apply the VFX impact and effects
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, OBJECT_SELF, HoursToSeconds(nDuration));

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

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
