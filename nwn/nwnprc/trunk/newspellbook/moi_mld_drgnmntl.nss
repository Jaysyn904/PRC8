/*
31/1/21 by Stratovarius

Dragon Mantle

Descriptors: Draconic
Classes: Soulborn, totemist
Chakra: Heart, shoulders (totem)
Saving Throw: None

Incarnum forms heavy plates of armor that resemble blue dragonhide. The plates hover above your back and shoulders, having an almost winglike appearance.

You draw on the incarnum of the mightiest dragons to increase your resilience. You gain a +2 enhancement bonus on Fortitude saves.

Essentia: You gain resistance to acid, electricity, fire, and cold equal to 3 � the number of points of essentia invested in this soulmeld. 

Chakra Bind (Heart)

The blue dragonhide plate armor fuses with your torso, invigorating your entire body with draconic energy.

You gain fast healing equal to the number of points of essentia invested in this soulmeld. This fast healing functions only when you are at or below half your full normal hit points.

Chakra Bind (Shoulders)

The blue dragonhide plate armor fits tightly to your shoulders and runs down your back and across your upper arms.

You gain damage reduction X/+1, where X equals the number of points of essentia you have invested in your dragon mantle.

Chakra Bind (Totem)

Long, draconic wings sprout from the shoulders of your blue dragonhide plate armor.

You gain +4 on Jump checks for every point of essentia invested in your dragon mantle.

*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 09:00:01
//::
//:: Double Chakra Bind support added
//:: Double Totem bind support added
//:: Fixed Dragon Mantle fast healing
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void DragonMantleHeal(object oMeldshaper);

void DragonMantleHeal(object oMeldshaper)
{
    	int nCurHP = GetCurrentHitPoints(oMeldshaper);
    	int nMaxHP = GetMaxHitPoints(oMeldshaper);
    	
    	// Is the HP total lower than half?
    	if ((nMaxHP/2) > nCurHP)
    	{
    	    if (!GetIsResting(oMeldshaper)) 
			{
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetEssentiaInvested(oMeldshaper, MELD_DRAGON_MANTLE)), oMeldshaper);
			}
			else
			{
				RemoveEventScript(oMeldshaper, EVENT_ONHEARTBEAT, "moi_mld_drgnmntl", TRUE, FALSE);
			}
    	}
		//DelayCommand(6.0, DragonMantleHeal(oMeldshaper));
}

void main()  
{  
    //Declare main variables.  
    int nEvent = GetRunningEvent();  
    int flag = 0;  
    object oMeldshaper;  
    switch(nEvent)  
    {  
        case EVENT_ONHEARTBEAT:     oMeldshaper = OBJECT_SELF;    break;  
  
        default:  
            oMeldshaper = PRCGetSpellTargetObject(); //flag = 1;  
    }  
      
    int nMeldId = PRCGetSpellId();  
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_DRAGON_MANTLE);  
    int nBonus    = 3 * nEssentia;  
  
    //if(flag == 1)  
    if(nEvent == FALSE)  
    {      
        effect eLink = EffectSavingThrowIncrease(SAVING_THROW_FORT, 2);  
        if (nEssentia)  
        {  
            eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ACID, nBonus));      
            eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_COLD, nBonus));      
            eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nBonus));      
            eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_FIRE, nBonus));      
        }  
          
        // Check for binds   
        int nBoundToShoulders = FALSE;  
        if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_SHOULDERS)) == nMeldId ||  
            GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_SHOULDERS)) == nMeldId)  
            nBoundToShoulders = TRUE;  
  
        if (nBoundToShoulders && nEssentia)   
        {  
            eLink = EffectLinkEffects(eLink, EffectDamageReduction(nEssentia, DAMAGE_POWER_PLUS_ONE));  
        }  
  
        // Check for binds   
        int nBoundToTotem = FALSE;  
        if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_TOTEM)) == nMeldId ||  
            GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)) == nMeldId)  
            nBoundToTotem = TRUE;  
  
        if (nBoundToTotem && nEssentia)  
        {  
            eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_JUMP, nEssentia * 4));  
        }  
  
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);    
        IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DRAGON_MANTLE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
          
        AddEventScript(oMeldshaper, EVENT_ONHEARTBEAT, "moi_mld_drgnmntl", TRUE, FALSE);  
    }      
    else if(nEvent == EVENT_ONHEARTBEAT)  
    {  
        // Check for binds  
        int nBoundToHeart = FALSE;  
        if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_HEART)) == nMeldId ||  
            GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_HEART)) == nMeldId)  
            nBoundToHeart = TRUE;  
  
        if (GetHasSpellEffect(MELD_DRAGON_MANTLE, oMeldshaper) && nBoundToHeart)  
        {  
            DragonMantleHeal(oMeldshaper);  
        }  
    }  
}

/* void main()
{
    //Declare main variables.
    int nEvent = GetRunningEvent();
	int flag = 0;
    object oMeldshaper;
    switch(nEvent)
    {
        case EVENT_ONHEARTBEAT:		oMeldshaper = OBJECT_SELF;	break;

        default:
            oMeldshaper = PRCGetSpellTargetObject(); //flag = 1;
    }
	
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_DRAGON_MANTLE);
    int nBonus    = 3 * nEssentia;

    //if(flag == 1)
	if(nEvent == FALSE)
    {    
		effect eLink = EffectSavingThrowIncrease(SAVING_THROW_FORT, 2);
		if (nEssentia)
		{
			eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ACID, nBonus));    
			eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_COLD, nBonus));    
			eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nBonus));    
			eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_FIRE, nBonus));    
		}
		
		if (GetIsMeldBound(oMeldshaper, MELD_DRAGON_MANTLE) == CHAKRA_SHOULDERS && nEssentia) 
		{
			eLink = EffectLinkEffects(eLink, EffectDamageReduction(nEssentia, DAMAGE_POWER_PLUS_ONE));
		}
		if (GetIsMeldBound(oMeldshaper, MELD_DRAGON_MANTLE) == CHAKRA_TOTEM && nEssentia)
		{
			eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_JUMP, nEssentia * 4));
		}

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
		IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DRAGON_MANTLE), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		
		AddEventScript(oMeldshaper, EVENT_ONHEARTBEAT, "moi_mld_drgnmntl", TRUE, FALSE);
	}	
	else if(nEvent == EVENT_ONHEARTBEAT)
	{	
		if (GetHasSpellEffect(MELD_DRAGON_MANTLE, oMeldshaper) && GetIsMeldBound(oMeldshaper, MELD_DRAGON_MANTLE) == CHAKRA_HEART)
		{
			DragonMantleHeal(oMeldshaper);
		}
	}
} */