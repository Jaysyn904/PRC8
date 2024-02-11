/**
 * @file
 * Spellscript for Hammer of Witches SLAs
 *
 */

#include "prc_inc_template"
#include "prc_inc_combat"
#include "inc_dispel"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    int nHD = GetHitDice(oPC);
    int nInstant = FALSE;
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_HammerWitches");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_WITCHES_DETECT:
        {
            nCasterLevel = 5;
            nSpell = SPELL_DETECT_MAGIC; 
            nUses = 999;
            break;
        } 
        case WOL_WITCHES_SPELLBREAKER:
        {
            nUses = 1;
            if (nHD >= 11) nUses++;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {        
                object oTarget = PRCGetSpellTargetObject();
                PerformAttackRound(oTarget, oPC, eNone, 0.0, 0, 0, 0, FALSE, "Spellbreaker Hit", "Spellbreaker Miss");
                SetLegacyUses(oPC, nSLA);
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
                {
                    effect eVis = EffectVisualEffect(VFX_IMP_BREACH);
                    effect eImpact = EffectVisualEffect(VFX_FNF_DISPEL_GREATER);
                    spellsDispelMagicMod(oTarget, 10, eVis, eImpact);
                }  
            }    
            break;
        }         
        case WOL_WITCHES_AMF:
        {
            nCasterLevel = 11;
            nSpell = SPELL_ANTIMAGIC_FIELD;
            nUses = 1;
            break;
        }   
        case WOL_WITCHES_DISPEL:
        {
            nCasterLevel = 15;
            nSpell = SPELL_GREATER_DISPELLING;
            nUses = 1;
            nInstant = TRUE;
            break;
        } 
        case WOL_WITCHES_MANTLE:
        {
            nCasterLevel = 15;
            nSpell = SPELL_GREATER_SPELL_MANTLE;
            nUses = 1;  
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
        