/**
 * @file
 * Spellscript for Tiger Fang SLAs
 *
 */

#include "prc_inc_template"
#include "prc_inc_combmove"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    int nInstant = FALSE;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_TigerFang");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case IP_CONST_FEAT_TIGER_FANG_CHARGE:
        {
            nUses = 1;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {            
                SetLegacyUses(oPC, nSLA);
                SetLocalInt(oPC, "TigerFangCharge", TRUE);
                object oTarget = PRCGetSpellTargetObject();
                DoCharge(oPC, oTarget);
                DelayCommand(5.5, DeleteLocalInt(oPC, "TigerFangCharge"));
            } 
            break;
        } 
        case IP_CONST_FEAT_TIGER_FANG_BATTLE:
        {
            nUses = 3;
            int nHeal = d8();
            if (GetLocalInt(oPC, "TigerFangFever")) 
            {
            	nUses = 5;
            	nHeal = d8(2);
            }	
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {            
                SetLegacyUses(oPC, nSLA);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oPC);       
            } 
            break;
        } 
        case IP_CONST_FEAT_TIGER_FANG_HASTE:
        {
            nUses = 5;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {            
                SetLegacyUses(oPC, nSLA);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectHaste()), oPC, 6.0);       
            } 
            break;
        }         
    }
    
    // Check uses per day
    if (GetLegacyUses(oPC, nSLA) >= nUses)
    {
        FloatingTextStringOnCreature("You have used " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " the maximum amount of times today.", oPC, FALSE);
        return;
    }   
    if (nSpell > 0) 
    {
        DoRacialSLA(nSpell, nCasterLevel, nDC, nInstant);
        SetLegacyUses(oPC, nSLA);
        FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);
    }     
}
        