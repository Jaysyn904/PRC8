/*
    x2_s0_enhweap

    Consolidation of:
        Blackstaff
        Blade Thirst
        Bless Weapon
        Darkfire
        Deafening Clang
        Flame Weapon
        Holy Sword
        Keen Edge
        Magic Weapon
        Greater Magic Weapon
        Unholy Sword
        Weapon of Impact
        Shillelagh

    By: Flaming_Sword
    Created: Jun 29, 2006
    Modified: Jun 30, 2006
    Modified; Apr 7, 2007 by motu99
*/

#include "prc_sp_func"
#include "x2_inc_toollib"

/// Used simply to use up a bit less processor time on the delayed command to delete these 6 Ints.
// motu99: seems to be not used any more
void DeleteTheInts(object oTarget)
{
    DeleteLocalInt(oTarget, "X2_Wep_Dam_Type");
    DeleteLocalInt(oTarget, "X2_Wep_Caster_Lvl");
    DeleteLocalInt(oTarget, "X2_Wep_Dam_Type_DF");
    DeleteLocalInt(oTarget, "X2_Wep_Caster_Lvl_DF");
    DeleteLocalInt(oTarget, "X2_Wep_Caster_Lvl_DC");
    DeleteLocalInt(oTarget, "X2_Wep_Penetr_DC");
}

//------------------------------------------------------------------------------
// AN, 2003
// Returns TRUE if oItem is a slashing weapon
//------------------------------------------------------------------------------
int PRCGetSlashingWeapon(object oItem)
{
    //Declare major variables
    int nItem = GetBaseItemType(oItem);
    //exclude creature weapons
    if(nItem == BASE_ITEM_CSLASHWEAPON ||
       nItem == BASE_ITEM_CSLSHPRCWEAP)
        return FALSE;
    int nWeapon = (StringToInt(Get2DACache("baseitems", "WeaponType", nItem)));
    // 3 = slashing, 4 = piercing-slashing
    return (nWeapon == 3 || nWeapon == 4);

/*    if((nItem == BASE_ITEM_BASTARDSWORD) ||
      (nItem == BASE_ITEM_BATTLEAXE) ||
      (nItem == BASE_ITEM_DOUBLEAXE) ||
      (nItem == BASE_ITEM_GREATAXE) ||
      (nItem == BASE_ITEM_GREATSWORD) ||
      (nItem == BASE_ITEM_HALBERD) ||
      (nItem == BASE_ITEM_HANDAXE) ||
      (nItem == BASE_ITEM_KAMA) ||
      (nItem == BASE_ITEM_KATANA) ||
      (nItem == BASE_ITEM_KUKRI) ||
      (nItem == BASE_ITEM_LONGSWORD)||
      (nItem == BASE_ITEM_SCIMITAR)||
      (nItem == BASE_ITEM_SCYTHE)||
      (nItem == BASE_ITEM_SICKLE)||
      (nItem == BASE_ITEM_TWOBLADEDSWORD) ||
      (nItem == BASE_ITEM_DWARVENWARAXE) ||
      (nItem == BASE_ITEM_THROWINGAXE) ||
      (nItem == BASE_ITEM_WHIP)
      || (nItem == 300) //CEP Trident
      || (nItem == 303) //CEP Sai
      || (nItem == 305) //CEP falchion
      || (nItem == 309) //CEP assassin dager
      || (nItem == 310) //CEP katar
      || (nItem == 313) //CEP kukri2
      || (nItem == 316) //CEP falchion
      || (nItem == 319) //CEP sh_x1_mercuryls
      || (nItem == 320) //CEP sh_x1_mercurygs
      || (nItem == 321) //CEP sh_x1_doublesc
      || (nItem == 322) //CEP goad
      || (nItem == 323) //CEP windfirewheel
      || (nItem == 324) //CEP maugdoublesword

      )
   {
        return TRUE;
   }
   return FALSE;*/
}

//------------------------------------------------------------------------------
// Returns TRUE if oItem is a piercing weapon
//------------------------------------------------------------------------------
int PRCGetPiercingWeapon(object oItem)
{
    int nItem = GetBaseItemType(oItem);
    //exclude creature weapons
    if(nItem == BASE_ITEM_CBLUDGWEAPON)
        return FALSE;
    int nWeapon = (StringToInt(Get2DACache("baseitems", "WeaponType", nItem)));
    // 2 = bludgeoning, 5 = bludgeoning/piercing
    return (nWeapon == 1 || nWeapon == 4 || nWeapon == 5);
}

//------------------------------------------------------------------------------
// Returns TRUE if oItem is a bludgeoning weapon
//------------------------------------------------------------------------------
int PRCGetBludgeoningWeapon(object oItem)
{
    int nItem = GetBaseItemType(oItem);
    //exclude creature weapons
    if(nItem == BASE_ITEM_CBLUDGWEAPON)
        return FALSE;
    int nWeapon = (StringToInt(Get2DACache("baseitems", "WeaponType", nItem)));
    // 2 = bludgeoning, 5 = bludgeoning/piercing
    return (nWeapon == 2 || nWeapon == 5);
}

void ApplyEffectsToWeapon(object oItem, int nSpellID, float fDuration, object oCaster, int nCasterLevel, int nPenetr)
{
    switch(nSpellID)
    {
        case SPELL_BLADE_THIRST:
        {
            IPSafeAddItemProperty(oItem, ItemPropertyEnhancementBonus(3), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
            IPSafeAddItemProperty(oItem, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_LOW, IP_CONST_LIGHTCOLOR_YELLOW), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
            break;
        }
        case SPELL_BLACKSTAFF:
        {
            IPSafeAddItemProperty(oItem, ItemPropertyEnhancementBonus(4), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitProps(IP_CONST_ONHIT_DISPELMAGIC, IP_CONST_ONHIT_SAVEDC_16), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
            IPSafeAddItemProperty(oItem, ItemPropertyVisualEffect(ITEM_VISUAL_EVIL), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
            break;
        }
        case SPELL_SHILLELAGH:
        {
            IPSafeAddItemProperty(oItem, ItemPropertyEnhancementBonus(1), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
            IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d6), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
            IPSafeAddItemProperty(oItem, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
            break;
        }
        case SPELL_BLESS_WEAPON:
        {
            // If the spell is cast again, any previous enhancement boni are kept
            IPSafeAddItemProperty(oItem, ItemPropertyEnhancementBonus(1), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE);
            // Replace existing temporary anti undead boni
            IPSafeAddItemProperty(oItem, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d6), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
            IPSafeAddItemProperty(oItem, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );
            break;
        }
        case SPELL_DARKFIRE:
        case SPELL_FLAME_WEAPON:
        {
            int nAppearanceType = ITEM_VISUAL_FIRE;
            int nDamageType = ChangedElementalDamage(oCaster, DAMAGE_TYPE_FIRE);
            int bDarkfire = (nSpellID == SPELL_DARKFIRE);
            //SendMessageToPC(OBJECT_SELF, "I am the caster");
            switch(nDamageType)
            {
                case DAMAGE_TYPE_ACID: nAppearanceType = ITEM_VISUAL_ACID; break;
                case DAMAGE_TYPE_COLD: nAppearanceType = ITEM_VISUAL_COLD; break;
                case DAMAGE_TYPE_ELECTRICAL: nAppearanceType = ITEM_VISUAL_ELECTRICAL; break;
                case DAMAGE_TYPE_SONIC: nAppearanceType = ITEM_VISUAL_SONIC; break;
            }
            // motu99: added differentiation for Darkfire and flame weapon
            if (bDarkfire)
            {
                // DeleteLocalInt(oItem, "X2_Wep_Dam_Type_DF");
                SetLocalInt(oItem, "X2_Wep_Dam_Type_DF", nDamageType);
                // Sets Caster Level int because it was too confusing trying to figure out caster level
                // in the damage script.
                // DeleteLocalInt(oItem, "X2_Wep_Caster_Lvl");
                SetLocalInt(oItem, "X2_Wep_Caster_Lvl_DF", nCasterLevel);
            }
            else
            {
                // DeleteLocalInt(oItem, "X2_Wep_Dam_Type");
                SetLocalInt(oItem, "X2_Wep_Dam_Type", nDamageType);
                // Sets Caster Level int because it was too confusing trying to figure out caster level
                // in the damage script.
                // DeleteLocalInt(oItem, "X2_Wep_Caster_Lvl");
                SetLocalInt(oItem, "X2_Wep_Caster_Lvl", nCasterLevel);
            }


            // If the spell is cast again, any previous itemproperties matching are removed.
            if(!bDarkfire || (bDarkfire && !(GetBaseItemType(oItem) == BASE_ITEM_SHORTSPEAR && GetHasFeat(FEAT_THUNDER_WEAPON, oCaster))))
                IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(bDarkfire ? 127 : 124, nCasterLevel), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
            IPSafeAddItemProperty(oItem, ItemPropertyVisualEffect(nAppearanceType), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
            //DelayCommand(fDuration, DeleteTheInts(oItem));
            break;
        }
        case SPELL_DEAFENING_CLANG:
        {
            IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(1), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
            IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_3), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING ,FALSE,TRUE);
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(137, 5),fDuration,  X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE,FALSE);
            IPSafeAddItemProperty(oItem, ItemPropertyVisualEffect(ITEM_VISUAL_SONIC), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );
            SetLocalInt(oItem, "X2_Wep_Caster_Lvl_DC", nCasterLevel);
            SetLocalInt(oItem, "X2_Wep_Penetr_DC", nPenetr);
            break;
        }
        case SPELL_HOLY_SWORD:
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonus(2), oItem, fDuration);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 5), oItem, fDuration);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d6), oItem, fDuration);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAreaOfEffect(IP_CONST_AOE_CIRCLE_VS_EVIL, nCasterLevel), oItem, fDuration);
            break;
        }
        case SPELL_KEEN_EDGE:
        {
            IPSafeAddItemProperty(oItem,ItemPropertyKeen(), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
            break;
        }
        case SPELL_WEAPON_OF_IMPACT:
        {
            IPSafeAddItemProperty(oItem,ItemPropertyKeen(), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
            break;
        }
        case SPELL_MAGIC_WEAPON:
        {
            IPSafeAddItemProperty(oItem,ItemPropertyEnhancementBonus(1), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
            break;
        }
        case SPELL_GREATER_MAGIC_WEAPON:
        {
            int nBonus = nCasterLevel / 3;
            if(nBonus > 5) nBonus = 5;
            IPSafeAddItemProperty(oItem,ItemPropertyEnhancementBonus(nBonus), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
            break;
        }
        case SPELL_UNHOLYSWORD:
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonus(2), oItem, fDuration);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, 5), oItem, fDuration);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d6), oItem, fDuration);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAreaOfEffect(IP_CONST_AOE_CIRCLE_VS_GOOD, nCasterLevel), oItem, fDuration);
            break;
        }
    }
}

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nSpellID = PRCGetSpellId(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat(oCaster);
    int nPenetr = nCasterLevel + SPGetPenetr();
    //float fMaxDuration = RoundsToSeconds(nCasterLevel); //modify if necessary

    int nDuration = nCasterLevel;
    if(CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND)) nDuration *= 2;

    object oMyWeapon = IPGetTargetedOrEquippedMeleeWeapon();
    object oPossessor = GetItemPossessor(oMyWeapon);
    int bCondition = GetIsObjectValid(oMyWeapon);
    if(!bCondition)
    {
        FloatingTextStrRefOnCreature(83615, oCaster);
        return TRUE;
    }
    int nVis = VFX_IMP_SUPER_HEROISM;
    int nDur = VFX_DUR_CESSATE_POSITIVE;
    float fDuration = RoundsToSeconds(nDuration);
    switch(nSpellID)
    {
        case SPELL_BLADE_THIRST:
        {
            bCondition = bCondition && PRCGetSlashingWeapon(oMyWeapon);
            break;
        }
        case SPELL_BLACKSTAFF:
        {
            nVis = VFX_IMP_EVIL_HELP;
            bCondition = bCondition && (GetBaseItemType(oMyWeapon) == BASE_ITEM_QUARTERSTAFF) ||
                                        (GetBaseItemType(oMyWeapon) == BASE_ITEM_MAGICSTAFF) ||
                                        (GetBaseItemType(oMyWeapon) == BASE_ITEM_CRAFTED_STAFF);
            break;
        }
        case SPELL_BLESS_WEAPON:
        {
            fDuration = TurnsToSeconds(nDuration);
            // ---------------- TARGETED ON BOLT  -------------------
            if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
            {
                // special handling for blessing crossbow bolts that can slay rakshasa's
                if (GetBaseItemType(oTarget) == BASE_ITEM_BOLT)
                {
                    SignalEvent(GetItemPossessor(oTarget), EventSpellCastAt(GetItemPossessor(oTarget), nSpellID, FALSE));
                    IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(123,1), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING );
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVis), GetItemPossessor(oTarget));
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nDur), GetItemPossessor(oTarget), RoundsToSeconds(nDuration));
                    return TRUE;
                }
            }
            break;
        }
        case SPELL_DARKFIRE:
        {
            nVis = VFX_IMP_PULSE_FIRE;
            fDuration = HoursToSeconds(nDuration);
            break;
        }
        case SPELL_FLAME_WEAPON:
        {
            nVis = VFX_IMP_PULSE_FIRE;
            fDuration = TurnsToSeconds(nDuration);
            break;
        }
        case SPELL_HOLY_SWORD:
        case SPELL_UNHOLYSWORD:
        {
            nVis = VFX_IMP_GOOD_HELP;
            break;
        }
        case SPELL_KEEN_EDGE:
        {
            bCondition = bCondition && (PRCGetSlashingWeapon(oMyWeapon) || PRCGetPiercingWeapon(oMyWeapon));
            fDuration = TurnsToSeconds(nDuration*10);
            break;
        }
        case SPELL_WEAPON_OF_IMPACT:
        {
            bCondition = bCondition && PRCGetBludgeoningWeapon(oMyWeapon);
            fDuration = TurnsToSeconds(nDuration*10);
            break;
        }
        case SPELL_MAGIC_WEAPON:
        {
            fDuration = HoursToSeconds(nDuration);
            break;
        }
        case SPELL_GREATER_MAGIC_WEAPON:
        {
            fDuration = HoursToSeconds(nDuration);
            break;
        }
        case SPELL_SHILLELAGH:
        {
            bCondition = bCondition && ((GetBaseItemType(oMyWeapon) == BASE_ITEM_QUARTERSTAFF) ||
                                       (GetBaseItemType(oMyWeapon) == BASE_ITEM_CLUB)) &&
                                       !GetIsMagicItem(oMyWeapon);
            fDuration = TurnsToSeconds(nDuration);
            break;
        }
    }

    if(bCondition)
    {
        SignalEvent(oPossessor, EventSpellCastAt(oPossessor, nSpellID, FALSE));

        if (nDuration>0)
        {
            effect eVis = EffectVisualEffect(nVis);
            if(nSpellID == SPELL_DARKFIRE) eVis = EffectLinkEffects(EffectVisualEffect(VFX_IMP_FLAME_M), eVis);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPossessor);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nDur), oPossessor, fDuration);
            ApplyEffectsToWeapon(oMyWeapon, nSpellID, fDuration, oCaster, nCasterLevel, nPenetr);
        }
        if(nSpellID == SPELL_UNHOLYSWORD)
        {
            TLVFXPillar(VFX_IMP_GOOD_HELP, GetLocation(PRCGetSpellTargetObject()), 4, 0.0f, 6.0f);
            DelayCommand(1.0f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_SUPER_HEROISM),GetLocation(PRCGetSpellTargetObject())));

        }
        return TRUE;
    }
    else
    {
        if(nSpellID == SPELL_BLACKSTAFF)
            FloatingTextStrRefOnCreature(83620, OBJECT_SELF);  // not a qstaff
        else if((nSpellID == SPELL_BLADE_THIRST) || (nSpellID == SPELL_KEEN_EDGE))
            FloatingTextStrRefOnCreature(83621, OBJECT_SELF); // not a slashing weapon
        else if(nSpellID == SPELL_WEAPON_OF_IMPACT)
            FloatingTextStrRefOnCreature(16789910, OBJECT_SELF); // not a bludgeoning weapon
        else if(nSpellID == SPELL_SHILLELAGH)
            FloatingTextStrRefOnCreature(16789913, OBJECT_SELF); // not a nonmagical club or quarterstaff
    }

    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId(oCaster)));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject(oCaster);
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}