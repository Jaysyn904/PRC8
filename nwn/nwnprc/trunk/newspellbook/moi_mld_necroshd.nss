/*
17/10/20 by Stratovarius

Necrocarnum Shroud

Descriptors: Evil, necrocarnum
Classes: Incarnate, soulborn
Chakra: Soul or waist
Saving Throw: See text

A deadening field of necrocarnum radiates from you, filling the air around you with faint, shadowy tendrils.

You gain a +1 profane bonus on attack rolls and damage rolls any time a living creature takes damage while adjacent to you. This bonus lasts for 1 round. If a living creature dies while adjacent to you, the bonus instead lasts for a number of rounds equal to the creature’s Hit Dice.

Essentia: If you invest essentia in the necrocarnum shroud, the area encompassed by the life-draining field expands. Any living creature who takes damage (or dies) within 5 feet plus 5 feet per point of essentia invested triggers the bonus.

Chakra Bind (Soul)

While you have necrocarnum shroud bound to your soul chakra, you can take a standard action to strike a living foe with the raw evil of necrocarnum. When you use this ability, you must make a successful melee touch attack against the intended victim. If successful, your touch bestows 1d4 negative levels on the target (Fortitude half). For each negative level bestowed, you gain 1 temporary point of essentia and 5 temporary hit points. The temporary essentia lasts until the end of your next turn. The temporary hit points fade after 1 hour.

Chakra Bind (Waist)

At the beginning of your turn, any creature within the area of your life-draining field becomes shaken for 1 round (Will negates).
*/

#include "moi_inc_moifunc"

void ShroudPulse(object oMeldshaper);
void ShroudShaken(object oMeldshaper);

void ShroudPulse(object oMeldshaper)
{
	if (GetHasSpellEffect(MELD_NECROCARNUM_SHROUD, oMeldshaper))
	{
    	location lTarget = GetLocation(oMeldshaper);
    	int nEssentia    = GetEssentiaInvested(oMeldshaper, MELD_NECROCARNUM_SHROUD);
    	float fDist      = 5.0 + nEssentia * 5.0;
 	
    	// Use the function to get the closest creature as a target
    	object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(fDist), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    	while(GetIsObjectValid(oAreaTarget))
    	{
			SetLocalObject(oAreaTarget, "NecrocarnumShroud", oMeldshaper);
    	    //Select the next target within the spell shape.
    	    oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(fDist), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    	}
    	DelayCommand(1.0, ShroudPulse(oMeldshaper));
    }	
}        

void ShroudShaken(object oMeldshaper)
{
	if (GetHasSpellEffect(MELD_NECROCARNUM_SHROUD, oMeldshaper))
	{
    	location lTarget = GetLocation(oMeldshaper);
    	int nEssentia    = GetEssentiaInvested(oMeldshaper, MELD_NECROCARNUM_SHROUD);
    	int nClass = GetMeldShapedClass(oMeldshaper, MELD_NECROCARNUM_SHROUD);		
		int nDC = GetMeldshaperDC(oMeldshaper, nClass, MELD_NECROCARNUM_SHROUD);       	
    	float fDist      = 5.0 + nEssentia * 5.0;
    	// Use the function to get the closest creature as a target
    	object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(fDist), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    	while(GetIsObjectValid(oAreaTarget))
    	{
    		if(!PRCMySavingThrow(SAVING_THROW_WILL, oAreaTarget, nDC, SAVING_THROW_TYPE_FEAR))
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectShaken(), oAreaTarget, 6.0);
    	    //Select the next target within the spell shape.
    	    oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(fDist), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    	}
    	DelayCommand(6.0, ShroudPulse(oMeldshaper));
    }	
}  

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia      = GetEssentiaInvested(oMeldshaper);

    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
        
    ShroudPulse(oMeldshaper);
    
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_NECROCARNUM_SHROUD), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_SOUL) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_NECROCARNUM_SHROUD_SOUL), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_WAIST) ShroudShaken(oMeldshaper);
}