/**
 * @file
 * Spellscript for Ramethene Sword SLAs
 *
 */

#include "prc_inc_template"
#include "prc_inc_s_det"
#include "prc_inc_smite"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Ramethene");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;    

    switch(nSLA){
        case WOL_RAMETHENE_DETECT:
        {
            nCasterLevel = 5;
            if(!X2PreSpellCastCode()) return;
            PRCSetSchool(SPELL_SCHOOL_DIVINATION);
            float fDuration = TurnsToSeconds(nCasterLevel);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_DETECT), oPC, fDuration);
            DetectRaceAura(0, RACIAL_TYPE_DRAGON, GetLocation(oPC), VFX_BEAM_FIRE, FeetToMeters(60.0));
            PRCSetSchool();
            nUses = 999;
            break;
        }  
        case WOL_RAMETHENE_SMITE:
        {
            object oTarget = PRCGetSpellTargetObject();
            if(MyPRCGetRacialType(oTarget)== RACIAL_TYPE_DRAGON) 
                DoSmite(oPC, oTarget, SMITE_TYPE_RAMETHENE);
            nUses = 1;    
            break;
        } 
        case WOL_RAMETHENE_RESIST:
        {
            nCasterLevel = 5;
            nSpell = SPELL_RESIST_ELEMENTS;
            nUses = 1;
            break;
        }     
        case WOL_RAMETHENE_CLOUD:
        {
            nCasterLevel = 11;
            nSpell = SPELL_CLOUDKILL;
            nUses = 1;
            nDC = 17;            
            if (15 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 15 + GetAbilityModifier(ABILITY_CHARISMA, oPC);              
            break;
        } 
        case WOL_RAMETHENE_MAX:
        {
            int nMeta = GetLocalInt(oPC, "SuddenMeta");
            nMeta |= METAMAGIC_MAXIMIZE;
            SetLocalInt(oPC, "SuddenMeta", nMeta);
            FloatingTextStringOnCreature("Sudden Maximize Activated", oPC, FALSE);
            nUses = 3;
            break;
        }  
        case WOL_RAMETHENE_WILT:
        {
            nCasterLevel = GetHitDice(oPC);
            nSpell = SPELL_HORRID_WILTING;
            nUses = 1;
            nDC = 22;            
            if (18 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 18 + GetAbilityModifier(ABILITY_CHARISMA, oPC);              
            break;
        }        
    }
    
    // Check uses per day
    if (GetLegacyUses(oPC, nSLA) >= nUses)
    {
        FloatingTextStringOnCreature("You have used " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " the maximum amount of times today.", oPC, FALSE);
        return;
    }   
    SetLegacyUses(oPC, nSLA);
    FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);    
    if (nSpell > 0) 
        DoRacialSLA(nSpell, nCasterLevel, nDC);
}
        