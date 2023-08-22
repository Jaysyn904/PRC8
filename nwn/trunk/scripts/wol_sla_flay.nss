/**
 * @file
 * Spellscript for Flay SLAs
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
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Flay");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;    

    switch(nSLA){
        case WOL_FLAY_SNAKE_STING:
        {
            nCasterLevel = 5;
            nSpell = SPELL_MAGIC_MISSILE;
            nUses = 3;
            break;
        } 
        case WOL_FLAY_WHIP_WRAP:
        {
            object oTarget = PRCGetSpellTargetObject();
            if (DoTrip(oPC, oTarget, 0))
            {
                SetLocalInt(oPC, "Flay_Grapple", TRUE);
                DoGrapple(oPC, oTarget, 4, FALSE, TRUE);
                ForceUnequip(oPC, oWOL, INVENTORY_SLOT_RIGHTHAND);
                AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "wol_m_flay", TRUE, FALSE);
            }
            break;
        }        
    }
    
    // Check uses per day
    if (GetLegacyUses(oPC, nSLA) >= nUses && nSLA != WOL_FLAY_WHIP_WRAP)
    {
        FloatingTextStringOnCreature("You have used " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " the maximum amount of times today.", oPC, FALSE);
        return;
    }   
    if (nSpell > 0) 
    {
        DoRacialSLA(nSpell, nCasterLevel, nDC);
        SetLegacyUses(oPC, nSLA);
        FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);
    }     
}
        