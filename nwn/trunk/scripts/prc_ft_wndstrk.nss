/*
    Activates Wand Strike
*/   

#include "prc_inc_sp_tch"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    object oWand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int nType = GetBaseItemType(oWand);
    
    if(nType != BASE_ITEM_MAGICWAND && nType != BASE_ITEM_ENCHANTED_WAND)
    {
        oWand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
        nType = GetBaseItemType(oWand);
        
        if(nType != BASE_ITEM_MAGICWAND && nType != BASE_ITEM_ENCHANTED_WAND)
            return; // Not wielding a wand anywhere
    }        
    
    if(PRCDoMeleeTouchAttack(oTarget)) // Got to hit
    {
        SetLocalInt(oPC, "AttackHasHit", TRUE); // Touch attacks don't have to reroll if the spell requires one
        DelayCommand(0.5, DeleteLocalInt(oPC, "AttackHasHit"));
        int nCharges = GetItemCharges(oWand);
        
        if (nCharges > 1) // Need to have enough charges for this
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(), DAMAGE_TYPE_MAGICAL), oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SPARKS), oTarget);
            //code for getting new ip type
            int nCasterLevel;
            int nSpell;
            itemproperty ipTest = GetFirstItemProperty(oWand);
            while(GetIsItemPropertyValid(ipTest))
            {
                if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_CAST_SPELL_CASTER_LEVEL)
                {
                    nCasterLevel = GetItemPropertyCostTableValue(ipTest);
                    if (DEBUG) DoDebug("Wandstrike: caster level from item = "+IntToString(nCasterLevel));
                }
                if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_CAST_SPELL)
                {
                    nSpell = GetItemPropertySubType(ipTest);
                    if (DEBUG) DoDebug("Wandstrike: iprop subtype = "+IntToString(nSpell));
                    nSpell = StringToInt(Get2DACache("iprp_spells", "SpellIndex", nSpell));
                    if (DEBUG) DoDebug("Wandstrike: spell from item = "+IntToString(nSpell));
                }                    
                ipTest = GetNextItemProperty(oWand);
            }
            // if we didn't find a caster level on the item, it must be Bioware item casting
            if(!nCasterLevel)
            {
                nCasterLevel = GetCasterLevel(oPC);
                if (DEBUG) DoDebug("Wandstrike: bioware item casting with caster level = "+IntToString(nCasterLevel));
            }
        
            ActionCastSpell(nSpell, nCasterLevel, 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, FALSE, oTarget, TRUE);
            SetItemCharges(oWand, nCharges - 2); // One for the damage, one for the spell
        }        
    }
}