const int DISEASE_TALONAS_BLIGHT = 52;

#include "prc_inc_spells"

void main()
{
    object oTarget = OBJECT_SELF;
    string sResRef = GetResRef(oTarget);
    object oCreator = GetLocalObject(oTarget, "BlightspawnCreator");
    int nRace = MyPRCGetRacialType(oTarget);
    
    if(DEBUG) DoDebug("Blight Touch Disease Target is: " + GetName(oTarget));
    if(DEBUG) DoDebug("Blight Touch Disease Creator is: " + GetPCPlayerName(oCreator));
    
    int iPenalty = d4(1);
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    //effect eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION, iPenalty);
    //effect eCha = EffectAbilityDecrease(ABILITY_CHARISMA, iPenalty);
    //Make the damage supernatural
    //eCon = SupernaturalEffect(eCon);
    //eCha = SupernaturalEffect(eCha);
    int iDC = GetLocalInt(oTarget, "BlightDC");

    //Make a saving throw check
    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_DISEASE))
    {
        //Apply the VFX impact and effects
        //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCon, oTarget);
        //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCha, oTarget);
        ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, iPenalty, DURATION_TYPE_PERMANENT, TRUE);
        ApplyAbilityDamage(oTarget, ABILITY_CHARISMA,     iPenalty, DURATION_TYPE_PERMANENT, TRUE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        
        if(DEBUG) DoDebug("Failed save vs Talona's Blight, applying penalty");
    }

    // If the monster is dead or his stats have dropped below what the bioware engine allows
    if ((GetAbilityScore(oTarget, ABILITY_CONSTITUTION) - iPenalty) <= 3 || 
       (GetAbilityScore(oTarget, ABILITY_CHARISMA) - iPenalty) <= 3)
    {
    	if (!GetIsDead(oTarget))
    	{
        	// This is to make sure its dead, in case ability damage didn't get it
        	DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget));
        	//ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetMaxHitPoints(oTarget)), oTarget);
        }
    	if(DEBUG && GetIsDead(oTarget)) DoDebug("Talona's Blight has killed the creature");


    	if (nRace == RACIAL_TYPE_ANIMAL ||
    	    nRace == RACIAL_TYPE_BEAST ||
    	    nRace == RACIAL_TYPE_MAGICAL_BEAST)
    	{
    		if(DEBUG) DoDebug("Creature is a valid type for blightspawned template");
    	
    		object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sResRef, GetLocation(oTarget), FALSE, "prc_blightspawn");
    		if(GetIsObjectValid(oCreature) && DEBUG) DoDebug("Created a blightspawned creature");
    		
    		// Try and make him non-hostile to the blightlord
    		AssignCommand(oCreator, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCharmed()), oCreature));
    		
    		// Apply the Blightspawned Template
    		
        	//Get the companion's skin
        	object oCreatureSkin = GetPCSkin(oCreature);
        	if(DEBUG) DoDebug("Applying Blightspawned bonuses to the creature");
        	//Give the companion Str +4, Con +2, Wis -2, and Cha -2
        	effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
        	effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, 2);
        	effect eWis = EffectAbilityDecrease(ABILITY_WISDOM, 2);
        	effect eCha = EffectAbilityDecrease(ABILITY_CHARISMA, 2);
        	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eStr, oCreatureSkin);
        	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCon, oCreatureSkin);
        	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eWis, oCreatureSkin);
        	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCha, oCreatureSkin);
        	//Get the companion's Hit Dice
        	int iHD = GetHitDice(oCreature);
        	//Get the companion's constitution modifier
        	int iCons = GetAbilityModifier(ABILITY_CONSTITUTION, oCreature);
        	//Compute the DC for this companion's blight touch
        	int iDC = 10 + (iHD / 2) + iCons;
        	//Create the onhit item property for causing the blight touch disease
        	itemproperty ipBlightTouch = ItemPropertyOnHitProps(IP_CONST_ONHIT_DISEASE, iDC, DISEASE_TALONAS_BLIGHT);
        	//Get the companion's creature weapons
        	object oBite = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oCreature);
        	object oLClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCreature);
        	object oRClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCreature);
        	//Apply blight touch to each weapon
        	if (GetIsObjectValid(oBite))
        	{
        	    IPSafeAddItemProperty(oBite, ipBlightTouch);
        	}
        	if (GetIsObjectValid(oLClaw))
        	{
        	    IPSafeAddItemProperty(oLClaw, ipBlightTouch);
        	}
        	if (GetIsObjectValid(oRClaw))
        	{
        	    IPSafeAddItemProperty(oRClaw, ipBlightTouch);
        	}
        	//Get the companion's alignment
        	int iCompLCA = GetAlignmentLawChaos(oCreature);
        	int iCompGEA = GetAlignmentGoodEvil(oCreature);
        	//Set PLANT immunities and add low light vision
        	AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_CHARM_PERSON), oCreatureSkin);
        	AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_DOMINATE_PERSON), oCreatureSkin);
        	AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_HOLD_PERSON), oCreatureSkin);
        	AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_MASS_CHARM), oCreatureSkin);
        	AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS), oCreatureSkin);
        	AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON), oCreatureSkin);
        	AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS), oCreatureSkin);
        	AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS), oCreatureSkin);
        	AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE), oCreatureSkin);
        	AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB), oCreatureSkin);
        	//Feat 354 is FEAT_LOWLIGHTVISION
        	AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(354), oCreatureSkin);

        	if (iCompLCA != ALIGNMENT_NEUTRAL)
        	{
        	    AdjustAlignment(oCreature, ALIGNMENT_NEUTRAL, 50, FALSE);
        	}
        	if (iCompGEA != ALIGNMENT_EVIL)
        	{
        	    AdjustAlignment(oCreature, ALIGNMENT_EVIL, 80, FALSE);
        	}
    		// Blightspawned creatures do not normally attack Blightlords
    		DelayCommand(2.0, SetIsTemporaryNeutral(oCreature, oCreator));
    		DelayCommand(2.0, SetIsTemporaryFriend(oCreature, oCreator));
    		
    		if(DEBUG) DoDebug("Setting created creature neutral to the blightlord");        	

        	if(DEBUG) DoDebug("Done applying Blightspawned bonuses to the creature");
        	
        }
        if(DEBUG) DoDebug("Exiting dead creature brackets");
        
    }
    if(DEBUG) DoDebug("Exiting prc_talona.nss");
}