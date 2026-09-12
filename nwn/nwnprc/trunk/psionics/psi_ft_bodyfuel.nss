//::////////////////////////////////////////////////////////  
//:: Body Fuel  
//:: psi_ft_bodyfuel.nss  
//:://////////////////////////////////////////////////////// 
/*  
    Body Fuel (Expanded Psionics Handbook, p. 41)

	[Psionic]

	You can expand your power point total at the 
	expense of your health.
	
	Prerequisite

	Benefit

	You can recover 2 power points by taking 1 point of 
	ability burn damage (see page 67) to each of your three 
	ability scores: Strength, Dexterity, and Constitution. 
	You can recover additional power points for a 
	proportional cost; for example, you could choose to 
	recover 6 power points by taking 3 points of ability 
	burn damage to Strength, Dexterity, and Constitution. 
	These recovered points are added to your power point 
	reserve as if you had gained them by resting overnight.
	Special

	Only living creatures can use this feat. You can take 
	advantage of this feat only while in your own body (if 
	you are under the effect of mind switch or metamorph, 
	for example, you gain no benefit).
 
*/  
//:://////////////////////////////////////////////  
#include "psi_inc_ppoints"  
  
void main()  
{  
    object oPC = OBJECT_SELF;  
  
    if(!PRCGetIsAliveCreature(oPC))  
    {  
        FloatingTextStringOnCreature("Only living creatures can use Body Fuel.", oPC, FALSE);  
        return;  
    }  
  
    if(GetIsPolyMorphedOrShifted(oPC))  
    {  
        FloatingTextStringOnCreature("You cannot use Body Fuel while polymorphed or shifted.", oPC, FALSE);  
        return;  
    }  
  
    if(GetCurrentPowerPoints(oPC) >= GetMaximumPowerPoints(oPC))  
    {  
        FloatingTextStringOnCreature("You already have a full reserve of Power Points.", oPC, FALSE);  
        return;  
    }  
  
    if(GetAbilityScore(oPC, ABILITY_STRENGTH,     TRUE) <= 3 ||  
       GetAbilityScore(oPC, ABILITY_DEXTERITY,    TRUE) <= 3 ||  
       GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE) <= 3)  
    {  
        FloatingTextStringOnCreature("Your Strength, Dexterity, or Constitution is too low (3 or less) to safely use Body Fuel.", oPC, FALSE);  
        return;  
    }  
  
    // Mirror ApplyAbilityDamage()'s guard clauses so Body Fuel cancels outright  
    // rather than silently reducing/blocking burn while still paying out PP.  
    if(GetIsImmune(oPC, IMMUNITY_TYPE_ABILITY_DECREASE))  
    {  
        FloatingTextStringOnCreature("You are immune to ability decrease and cannot use Body Fuel.", oPC, FALSE);  
        return;  
    }  
  
    if(GetLocalInt(oPC, "IncarnumDefenseCE"))  
    {  
        FloatingTextStringOnCreature("Your Incarnum Defense protects your Strength, blocking Body Fuel.", oPC, FALSE);  
        return;  
    }  
  
    if(GetIsMeldBound(oPC, MELD_VITALITY_BELT) == CHAKRA_WAIST || GetIsMeldBound(oPC, MELD_VITALITY_BELT) == CHAKRA_DOUBLE_WAIST)  
    {  
        FloatingTextStringOnCreature("Your bound Vitality Belt protects your Constitution, blocking Body Fuel.", oPC, FALSE);  
        return;  
    }  
  
    if(GetHasSpellEffect(MELD_STRONGHEART_VEST, oPC) ||  
       GetIsMeldBound(oPC, MELD_STRONGHEART_VEST) == CHAKRA_WAIST || GetIsMeldBound(oPC, MELD_STRONGHEART_VEST) == CHAKRA_DOUBLE_WAIST)  
    {  
        FloatingTextStringOnCreature("Your Strongheart Vest reduces ability damage/drain, blocking Body Fuel.", oPC, FALSE);  
        return;  
    }  

	if(DEBUG) DoDebug("psi_ft_bodyfuel: Firing Body Fuel  //////////////////////////////////////////////////////////////////////////////");
	if(DEBUG) DoDebug("/////////////////////////////////////////////////////////////////////////////////////////////////////////////////");
		
    int nBurnPerAbility = 1;  
    int nPPGain = nBurnPerAbility * 2;  
  
    // Apply ability burn to STR, DEX, CON  
	if(GetPRCSwitch(PRC_ABILITY_BURN_HEAL_ON_REST))  
	{  
		// Rest-based healing: RestFinished() handles recovery, so apply as permanent  
		ApplyAbilityDamage(oPC, ABILITY_STRENGTH,     nBurnPerAbility, DURATION_TYPE_PERMANENT, FALSE);  
		ApplyAbilityDamage(oPC, ABILITY_DEXTERITY,    nBurnPerAbility, DURATION_TYPE_PERMANENT, FALSE);  
		ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, nBurnPerAbility, DURATION_TYPE_PERMANENT, FALSE);
	}  
	else  
	{  
		// Real-time healing: let ApplyAbilityDamage schedule its own 24h/point recovery  
		ApplyAbilityDamage(oPC, ABILITY_STRENGTH,     nBurnPerAbility, DURATION_TYPE_TEMPORARY, FALSE, -1.0f);  
		ApplyAbilityDamage(oPC, ABILITY_DEXTERITY,    nBurnPerAbility, DURATION_TYPE_TEMPORARY, FALSE, -1.0f);  
		ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, nBurnPerAbility, DURATION_TYPE_TEMPORARY, FALSE, -1.0f);  
	}  
  
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE_RED);  
           eVis = EffectLinkEffects(eVis, EffectVisualEffect(VFX_IMP_HEALING_S));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);  
  
	ReApplyUnhealableAbilityDamage(oPC));
    GainPowerPoints(oPC, nPPGain);  
  
    FloatingTextStringOnCreature("You burn your body's vitality to fuel your mind, gaining " +  
        IntToString(nPPGain) + " power points.", oPC, FALSE);  
}