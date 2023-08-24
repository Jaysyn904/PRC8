/**
 * @file
 * Spellscript for Wyrmbane Helm SLAs
 *
 */

#include "prc_inc_template"
#include "prc_inc_breath"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Wyrmbane");
    
    // You get nothing if you aren't wielding the item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_HEAD, oPC)) return;    

    switch(nSLA){
        case WOL_WYRMBANE_FEAR:
        {
            nCasterLevel = 5;
            nSpell = SPELL_SCARE;
            nUses = 5;
            nDC = 11;            
            if (11 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 11 + GetAbilityModifier(ABILITY_CHARISMA, oPC);            
            break;
        } 
        case WOL_WYRMBANE_BOLT:
        {
            nCasterLevel = 7;
            nSpell = SPELL_LIGHTNING_BOLT;
            nUses = 1;
            nDC = 14;            
            if (13 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 13 + GetAbilityModifier(ABILITY_CHARISMA, oPC);            
            break;
        }  
        /*case WOL_WYRMBANE_BANE:
        {
    		effect eLink = EffectLinkEffects(VersusRacialTypeEffect(EffectDamageIncrease(DAMAGE_BONUS_2d6), RACIAL_TYPE_DRAGON), VersusRacialTypeEffect(EffectAttackIncrease(2), RACIAL_TYPE_DRAGON));
 			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oPC, 9999.0);
            nUses = 999;
            break;
        } */          
        case WOL_WYRMBANE_EMP:
        {
            int nMeta = GetLocalInt(oPC, "SuddenMeta");
            nMeta |= METAMAGIC_EMPOWER;
            SetLocalInt(oPC, "SuddenMeta", nMeta);
            FloatingTextStringOnCreature("Sudden Empower Activated", oPC, FALSE);
            nUses = 3;
            break;
        }     
        case WOL_WYRMBANE_BREATH:
        {
			    // Check the dragon breath delay lock
    		if(GetLocalInt(oPC, "DragonBreathLock"))
    		{
    		    SendMessageToPC(oPC, "You cannot use your breath weapon again so soon");
    		    return;
    		}
            nDC = 25;            
            if (20 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) > nDC)
                nDC = 20 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC);    		
    		struct breath ElecBreath = CreateBreath(oPC, TRUE, 100.0, DAMAGE_TYPE_ELECTRICAL, 8, 12, nDC, 0);
    
    		//Apply the breath
    		PRCPlayDragonBattleCry();
    		ApplyBreath(ElecBreath, PRCGetSpellTargetLocation());
    
    		//Apply the recharge lock
    		SetLocalInt(oPC, "DragonBreathLock", TRUE);
		
    		// Schedule opening the delay lock
    		float fDelay = RoundsToSeconds(1);
    		SendMessageToPC(oPC, "Your breath weapon will be ready again in " + IntToString(1) + " rounds.");
			
    		DelayCommand(fDelay, DeleteLocalInt(oPC, "DragonBreathLock"));
    		DelayCommand(fDelay, SendMessageToPC(oPC, "Your breath weapon is ready now"));
    		nUses = 3;
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
        