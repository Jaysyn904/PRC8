/*
17/10/20 by Stratovarius

Necrocarnum Circlet

Descriptors: Evil, necrocarnum
Classes: Incarnate, soulborn
Chakra: Crown
Saving Throw: None

Necrocarnum bends itself into a matte black crown that seems to consume light. The fractured remnants of souls broken by the power of necrocarnum float within this soulmeld. These forms barely surface in this dark and foreboding crown, yet even the faintest glimpse is unsettling

While this soulmeld is shaped, you unerringly detect the presence and position of undead creatures within 30 feet. 

Essentia: Undead within a 30-foot radius gain turn resistance equal to the number of points of essentia that you invest in the soulmeld. If you animated the undead, the turn resistance is equal to double the number of points of invested essentia.

Chakra Bind (Crown)

A matching coil of necrocarnum forms around the head of a corpse. Filled with the dark power of necrocarnum, the corpse shambles to its feet, its flesh and mind overtaken by the curse of undeath. 

When you shape this soulmeld and bind it to your crown chakra, you can animate an undead creature. This requires a full-round action and provokes attacks of opportunity; in addition, you take 
damage equal to the necrocarnum zombie’s Hit Dice, which may not be healed as long as the zombie remains animated. You may only have one zombie.
*/

#include "moi_inc_moifunc"
#include "prc_inc_s_det"  
void NecroDetect(object oMeldshaper, int bFirstRun = FALSE);
void CircTurnRes(object oMeldshaper);

void NecroDetect(object oMeldshaper, int bFirstRun = FALSE)  
{  
    if (!GetHasSpellEffect(MELD_NECROCARNUM_CIRCLET, oMeldshaper))  
        return;  
          
    if (bFirstRun)  
    {  
        // First activation: show detection cone VFX briefly  
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_DETECT), oMeldshaper, 3.0f);  
    }  
      
    // Always apply ioun stone VFX for continuous effect  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_IOUN_STONE_RED), oMeldshaper, 6.0);  
      
    // Run the actual detection logic  
    DetectRaceAura(0, RACIAL_TYPE_UNDEAD, GetLocation(oMeldshaper), VFX_BEAM_ODD, FeetToMeters(60.0));  
      
    // Schedule next run with bFirstRun = FALSE  
    DelayCommand(6.0, NecroDetect(oMeldshaper, FALSE));  
}

/* void NecroDetect(object oMeldshaper)
{
	if (GetHasSpellEffect(MELD_NECROCARNUM_CIRCLET, oMeldshaper))
	{
		ActionCastSpellOnSelf(SPELL_DETECT_UNDEAD);
		DelayCommand(6.0, NecroDetect(oMeldshaper));
	}	
}
 */
void CircTurnRes(object oMeldshaper)
{
	if (GetHasSpellEffect(MELD_NECROCARNUM_CIRCLET, oMeldshaper))
	{
    	location lTarget = GetLocation(oMeldshaper);
    	int nEssentia    = GetEssentiaInvested(oMeldshaper, MELD_NECROCARNUM_CIRCLET);
    	// Use the function to get the closest creature as a target
    	object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    	while(GetIsObjectValid(oAreaTarget))
    	{
    	    if(MyPRCGetRacialType(oAreaTarget) == RACIAL_TYPE_UNDEAD)
    	    {
    	    	if (GetMaster(oAreaTarget) == oMeldshaper)
    	        	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectTurnResistanceIncrease(nEssentia*2)), oAreaTarget, 6.0);
    	        else
    	        	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectTurnResistanceIncrease(nEssentia)), oAreaTarget, 6.0);
    	    }
    	    //Select the next target within the spell shape.
    	    oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    	}
    	DelayCommand(6.0, CircTurnRes(oMeldshaper));
    }	
}        

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
    int nEssentia      = GetEssentiaInvested(oMeldshaper);

    effect eLink = EffectVisualEffect(VFX_DUR_GR_AURA_UNDEAD);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);  
    
    if (nEssentia) CircTurnRes(oMeldshaper);
    
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_NECROCARNUM_CIRCLET), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_CROWN) IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_NECRO_CIRCLET_BROW), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
}