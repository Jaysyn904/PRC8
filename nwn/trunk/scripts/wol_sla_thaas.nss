/**
 * @file
 * Spellscript for Thaas SLAs
 *
 */

#include "prc_inc_template"
#include "prc_inc_s_det"
#include "inc_npc"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Thaas");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;    
	
	switch(nSLA)
	{
        case WOL_THAAS_DETECT:
        {
            nCasterLevel = 5;
            if(!X2PreSpellCastCode()) return;
            PRCSetSchool(SPELL_SCHOOL_DIVINATION);
            float fDuration = TurnsToSeconds(nCasterLevel);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_DETECT), oPC, fDuration);
            DetectRaceAura(0, RACIAL_TYPE_OUTSIDER, GetLocation(oPC), VFX_BEAM_FIRE, FeetToMeters(60.0));
            PRCSetSchool();
            nUses = 999;
            break;
        }  
        case WOL_THAAS_OBSTRUCT:
        {
		    object oTarget = PRCGetSpellTargetObject();
		    effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
		    int nCount=1;
		    int nHD = FALSE;
		    if (10 >= GetHitDice(oTarget) || (GetHasFeat(FEAT_GREATER_LEGACY, oPC) && GetHitDice(oPC) >= 17)) nHD = TRUE;
		    // Evil outsiders only
		    if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL && MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER && nHD)
		    {
  				while (GetIsObjectValid(GetAssociateNPC(ASSOCIATE_TYPE_SUMMONED, oTarget, nCount)))
  				{
					object oKill = GetAssociateNPC(ASSOCIATE_TYPE_SUMMONED, oTarget, nCount);
		            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oKill);
		            AssignCommand(oKill, SetIsDestroyable(TRUE));
		            DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oKill)), oKill));
		            DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), oKill));
		            DestroyObject(oKill, 0.5);					
    				nCount++;
  				}		    
  			}	
		
            nUses = 999;
            break;
        }         
        case WOL_THAAS_BANISH:
        {
            nCasterLevel = 15;
            nSpell = SPELL_BANISHMENT;
            nUses = 1;
            nDC = max(20, 17 + GetAbilityModifier(ABILITY_CHARISMA, oPC));            
            break;
        } 
        case WOL_THAAS_TELEPORT:
        {
            nCasterLevel = 20;
            nSpell = SPELL_TELEPORT_PARTY;
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
    SetLegacyUses(oPC, nSLA);
    FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);    
    if (nSpell > 0) 
        DoRacialSLA(nSpell, nCasterLevel, nDC);
}
        