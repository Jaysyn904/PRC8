/*
At 3rd level, the blighter gains a version of the wild shape ability. Undead wild shape functions like the druid’s wild shape ability, 
except that the blighter adds the skeleton template to the animal form he chooses to transform into. The blighter’s animal form is 
altered as follows: 
— Type changes to undead. 
— Natural armor bonus is +0 (Tiny animal), +1 (Small), +2 (Medium or Large), or +3 (Huge). 
— +2 Dexterity, no Constitution score. 
— Immunity to cold. 
— Damage reduction 5/bludgeoning.

The blighter gains one extra use per day of this ability at every even blighter level after 3rd. In addition, she gains the 
ability to take the shape of a Large skeletal animal at 5th level and a Huge skeletal animal at 9th level.
*/

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
    int nDuration = GetLevelByClass(CLASS_TYPE_BLIGHTER, oPC);
    if (!GetLocalInt(GetModule(),"X3_NO_SHAPESHIFT_SPELL_CHECK"))
    { // check to see if abort due to being mounted
        if (PRCHorseGetIsMounted(oTarget))
        { // abort
            if (GetIsPC(oTarget)) FloatingTextStrRefOnCreature(111982,oTarget,FALSE);
              return;
        } // abort
    } // check to see if abort due to being mounted

    //this command will make shore that polymorph plays nice with the shifter
    ShifterCheck(OBJECT_SELF);

    int nShape = GetPersistantLocalInt(oPC, PRC_PNP_SHIFTING + IntToString(nSpell));
    if(nShape > 0)
    {
        wild_shape_shift(oPC, nShape);
        //Applying Skeleton template here
        SetLocalInt(oPC, "PRC_ShiftingOverride_Race", RACIAL_TYPE_UNDEAD + 1);
        DelayCommand(HoursToSeconds(nDuration), DeleteLocalInt(oPC, "PRC_ShiftingOverride_Race"));
        effect eLink = EffectLinkEffects(EffectAbilityIncrease(ABILITY_DEXTERITY, 2), EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100));
        eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_PIERCING, 5));
        eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING, 5));
        eLink = EffectLinkEffects(eLink, EffectACIncrease(2, AC_NATURAL_BONUS));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, HoursToSeconds(nDuration));        
        return;
    }

    //Determine Polymorph subradial type
    if(nSpell == 2284)
    {
        nPoly = POLYMORPH_TYPE_BROWN_BEAR;
        if (nDuration >= 9)
        {
            nPoly = POLYMORPH_TYPE_DIRE_BROWN_BEAR;
        }
    }
    else if (nSpell == 2285)
    {
        nPoly = POLYMORPH_TYPE_PANTHER;
        if (nDuration >= 5)
        {
            nPoly = POLYMORPH_TYPE_DIRE_PANTHER;
        }
    }
    else if (nSpell == 2286)
    {
        nPoly = POLYMORPH_TYPE_WOLF;

        if (nDuration >= 5)
        {
            nPoly = POLYMORPH_TYPE_DIRE_WOLF;
        }
    }
    else if (nSpell == 2287)
    {
        nPoly = POLYMORPH_TYPE_BOAR;
        if (nDuration >= 5)
        {
            nPoly = POLYMORPH_TYPE_DIRE_BOAR;
        }
    }
    else if (nSpell == 2288)
    {
        nPoly = POLYMORPH_TYPE_DIRE_BADGER;
        if (nDuration >= 9)
        {
            nPoly = POLYMORPH_TYPE_GIANT_SPIDER;
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

    //Apply the VFX impact and effects
    //Applying Skeleton template here
    SetLocalInt(oPC, "PRC_ShiftingOverride_Race", RACIAL_TYPE_UNDEAD + 1);
    DelayCommand(HoursToSeconds(nDuration), DeleteLocalInt(oPC, "PRC_ShiftingOverride_Race"));
    effect eLink = EffectLinkEffects(EffectAbilityIncrease(ABILITY_DEXTERITY, 2), EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100));
    eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_PIERCING, 5));
    eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING, 5));
    eLink = EffectLinkEffects(eLink, EffectACIncrease(2, AC_NATURAL_BONUS));
    ePoly = EffectLinkEffects(ePoly, eLink);    
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
