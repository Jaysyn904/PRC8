/*
   ----------------
   Null Psionics Field - OnEnter

   psi_pow_npfent
   ----------------

   6/10/05 by Stratovarius
   Modified: Nov 1, 2007 - Flaming_Sword
*/ /** @file

    Null Psionics Field - OnEnter

    Psychokinesis
    Level: Kineticist 6
    Manifesting Time: 1 standard action
    Range: 10 ft.
    Area: 10-ft.-radius emanation centered on you
    Duration: 10 min./level(D)
    Saving Throw: None
    Power Resistance: See text
    Power Points: 11
    Metapsionics: Extend, Widen

    An invisible barrier surrounds you and moves with you. The space within this
    barrier is impervious to most psionic effects, including powers, psi-like
    abilities, and supernatural abilities. Likewise, it prevents the functioning
    of any psionic items or powers within its confines. A null psionics field
    negates any power or psionic effect used within, brought into, or manifested
    into its area.

    Dispel psionics does not remove the field. Two or more null psionics fields
    sharing any of the same space have no effect on each other. Certain powers
    may be unaffected by null psionics field (see the individual power
    descriptions).


    Implementation note: To dismiss the power, use the control feat again. If
                         the power is active, that will end it instead of
                         manifesting it.
*/

#include "prc_craft_inc"
#include "inc_npc"

int GetIsExempt(object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    int nIPType = GetItemPropertyType(ip);
    int nIPSubType = GetItemPropertySubType(ip);

    int nType = GetBaseItemType(oItem);
    switch(nType)
    {
        case BASE_ITEM_TORCH:
        case BASE_ITEM_TRAPKIT:
        case BASE_ITEM_HEALERSKIT:
        case BASE_ITEM_GRENADE:
        case BASE_ITEM_THIEVESTOOLS:
        case BASE_ITEM_CRAFTMATERIALMED:
        case BASE_ITEM_CRAFTMATERIALSML:
        case 112://craftbase
            return TRUE;
        case BASE_ITEM_POTIONS:
        {
            if(nIPType == ITEM_PROPERTY_CAST_SPELL)
            {
                if(nIPSubType == IP_CONST_CASTSPELL_SPECIAL_ALCOHOL_BEER
                || nIPSubType == IP_CONST_CASTSPELL_SPECIAL_ALCOHOL_SPIRITS
                || nIPSubType == IP_CONST_CASTSPELL_SPECIAL_ALCOHOL_WINE)
                    return TRUE;
            }
        }
        case BASE_ITEM_MISCSMALL:
        {
            if(nIPType == ITEM_PROPERTY_CAST_SPELL)
            {
                //Dye Kits/Poison Weapon
                if(nIPSubType >= 490 && nIPSubType <= 497)
                    return TRUE;
            }
        }
    }

    // if there is more than 1 property then this item should be stripped
    if(GetIsItemPropertyValid(GetNextItemProperty(oItem)))
        return FALSE;

    if(nIPType == ITEM_PROPERTY_ON_HIT_PROPERTIES
    && nIPSubType == IP_CONST_ONHIT_ITEMPOISON)
        return TRUE;

    return FALSE;
}

void RemoveEffectsNPF(object oObject)
{
    effect eEff = GetFirstEffect(oObject);
    while(GetIsEffectValid(eEff))
    {
        int nType = GetEffectType(eEff);
        int nSubType = GetEffectSubType(eEff);
        if(nSubType != SUBTYPE_EXTRAORDINARY &&
           nSubType != SUBTYPE_SUPERNATURAL &&
           (nType == EFFECT_TYPE_ABILITY_INCREASE          ||
            nType == EFFECT_TYPE_AC_INCREASE               ||
            nType == EFFECT_TYPE_ATTACK_INCREASE           ||
            nType == EFFECT_TYPE_BLINDNESS                 ||
            nType == EFFECT_TYPE_CHARMED                   ||
            nType == EFFECT_TYPE_CONCEALMENT               ||
            nType == EFFECT_TYPE_CONFUSED                  ||
            nType == EFFECT_TYPE_CURSE                     ||
            nType == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE  ||
            nType == EFFECT_TYPE_DAMAGE_INCREASE           ||
            nType == EFFECT_TYPE_DAMAGE_REDUCTION          ||
            nType == EFFECT_TYPE_DAMAGE_RESISTANCE         ||
            nType == EFFECT_TYPE_DAZED                     ||
            nType == EFFECT_TYPE_DEAF                      ||
            nType == EFFECT_TYPE_DOMINATED                 ||
            nType == EFFECT_TYPE_ELEMENTALSHIELD           ||
            nType == EFFECT_TYPE_ETHEREAL                  ||
            nType == EFFECT_TYPE_FRIGHTENED                ||
            nType == EFFECT_TYPE_HASTE                     ||
            nType == EFFECT_TYPE_IMMUNITY                  ||
            nType == EFFECT_TYPE_IMPROVEDINVISIBILITY      ||
            nType == EFFECT_TYPE_INVISIBILITY              ||
            nType == EFFECT_TYPE_INVULNERABLE              ||
            nType == EFFECT_TYPE_ABILITY_INCREASE          ||
            nType == EFFECT_TYPE_NEGATIVELEVEL             ||
            nType == EFFECT_TYPE_PARALYZE                  ||
            nType == EFFECT_TYPE_POLYMORPH                 ||
            nType == EFFECT_TYPE_REGENERATE                ||
            nType == EFFECT_TYPE_SANCTUARY                 ||
            nType == EFFECT_TYPE_SAVING_THROW_INCREASE     ||
            nType == EFFECT_TYPE_SEEINVISIBLE              ||
            nType == EFFECT_TYPE_SILENCE                   ||
            nType == EFFECT_TYPE_SKILL_INCREASE            ||
            nType == EFFECT_TYPE_SLOW                      ||
            nType == EFFECT_TYPE_SPELL_IMMUNITY            ||
            nType == EFFECT_TYPE_SPELL_RESISTANCE_INCREASE ||
            nType == EFFECT_TYPE_SPELLLEVELABSORPTION      ||
            nType == EFFECT_TYPE_TEMPORARY_HITPOINTS       ||
            nType == EFFECT_TYPE_TRUESEEING                ||
            nType == EFFECT_TYPE_ULTRAVISION               ||
            nType == EFFECT_TYPE_INVULNERABLE
            )
           )
            RemoveEffect(oObject, eEff);

        eEff = GetNextEffect(oObject);
    }
}

//Stores the itemprops of an item in a persistent array
void StoreItemprops(object oItem, int bRemove)
{
    if(DEBUG) DoDebug("StoreItemprops: " + GetName(GetItemPossessor(oItem)) + ", " + GetName(oItem) + ", " + ObjectToString(oItem));

    string sIP;
    int nIpCount;
    persistant_array_create(oItem, "PRC_NPF_ItemList"); //stores object strings
    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
        {   //only store the permanent ones as underscore delimited strings
            sIP = IntToString(GetItemPropertyType(ip)) + "_" +
                    IntToString(GetItemPropertySubType(ip)) + "_" +
                    IntToString(GetItemPropertyCostTableValue(ip)) + "_" +
                    IntToString(GetItemPropertyParam1Value(ip));
            if(DEBUG) DoDebug("StoreItemprops: " + GetName(GetItemPossessor(oItem)) + ", " + ObjectToString(oItem) + ", " + sIP);
            array_set_string(oItem, "PRC_NPF_ItemList", nIpCount++, sIP);
        }
        if(bRemove)
            RemoveItemProperty(oItem, ip);
        ip = GetNextItemProperty(oItem);
    }
}

//Stores an array of objects and their itemprops
void StoreObjects(object oCreature, int bRemove = TRUE)
{
    int i, nSlotMax = INVENTORY_SLOT_CWEAPON_L; //INVENTORY_SLOT_ARROWS;    //max slot number, to exempt creature items //ammo placeholders (?)
    object oItem;

    for(i = 0; i < nSlotMax; i++)   //equipped items
    {
        oItem = GetItemInSlot(i, oCreature);
        if(GetIsObjectValid(oItem))
        {
            if(!GetIsExempt(oItem))
                StoreItemprops(oItem, bRemove);
        }
    }

    oItem = GetFirstItemInInventory(oCreature);
    while(GetIsObjectValid(oItem))
    {
        if(!GetIsExempt(oItem))
            StoreItemprops(oItem, bRemove);

        oItem = GetNextItemInInventory(oCreature);
    }
}

void main()
{   //testing code
    object oEnter = GetEnteringObject();
    if(GetObjectType(oEnter) == OBJECT_TYPE_CREATURE && !GetPlotFlag(oEnter) && !GetIsDM(oEnter) && !GetPersistantLocalInt(oEnter, "NullPsionicsField"))
    {
        if(DEBUG) DoDebug("psi_pow_npfent: Creatured entered Null Psionics Field: " + DebugObject2Str(oEnter));

        object oCaster = GetAreaOfEffectCreator();

        // Set the marker variable
        SetPersistantLocalInt(oEnter, "NullPsionicsField", TRUE);

        //Fire cast spell at event for the target
        SignalEvent(oEnter, EventSpellCastAt(oCaster, GetLocalInt(OBJECT_SELF, "X2_AoE_SpellID"), FALSE));

        // Remove all non-extraordinary effects
        RemoveEffectsNPF(oEnter);

        // Apply absolute spell failure and spell immunity
        effect eLink = EffectSpellResistanceIncrease(100);
               //eLink = EffectLinkEffects(eLink, EffectSpellFailure(100, SPELL_SCHOOL_GENERAL));
               eLink = ExtraordinaryEffect(eLink);
        //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oEnter);

        if(GetAssociateTypeNPC(oEnter) == ASSOCIATE_TYPE_SUMMONED ||
          (MyPRCGetRacialType(oEnter) == RACIAL_TYPE_UNDEAD &&
          GetLocalInt(oEnter, "X2_L_IS_INCORPOREAL") || GetHasFeat(FEAT_INCORPOREAL, oEnter)))
        {
            int nPenetr = SPGetPenetrAOE(OBJECT_SELF);
            //Spell resistance check
            if(!PRCDoResistSpell(oCaster, oEnter, nPenetr))
            {
                effect eInvis = EffectDamageImmunityAll();
                       eInvis = EffectLinkEffects(eInvis, EffectImmunityMiscAll());
                       eInvis = EffectLinkEffects(eInvis, EffectCutsceneGhost());
                       eInvis = EffectLinkEffects(eInvis, EffectCutsceneParalyze());
                       eInvis = EffectLinkEffects(eInvis, EffectEthereal());
                       eInvis = EffectLinkEffects(eInvis, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
                       eInvis = ExtraordinaryEffect(eInvis);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInvis, oEnter);
            }
        }
        else
            // Store itemproperties and remove them from objects
            StoreObjects(oEnter);

        // Apply vfx
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oEnter);
    }
}