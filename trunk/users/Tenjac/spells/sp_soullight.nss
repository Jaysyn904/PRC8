//:://////////////////////////////////////////////
//:: Name     Soul of Light
//:: FileName   sp_soulight.nss
//:://////////////////////////////////////////////
/** @file Transmutation [Good]
Level: Paladin 2, Cleric 3,
Components: V, S,
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 hour

Bright, clear light sprouts from your body, quickly 
flaring before fading to a faint white pulse. This spell
infuses your body with energy drawn from the Positive 
Energy Plane, making it easier to repair injuries.

Whenever you cast or are the target of a conjuration 
(healing) spell, you can choose for the spell to heal
a number of extra points of damage equal to twice the spell's level.

If such a spell heals at least 10 points of damage,
it also removes the fatigued condition from the 
target (or reduces exhaustion to fatigue).

If soul of light and soul of order are active on you at the 
same time, you gain damage reduction 3/+3

*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 8/8/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  HoursToSeconds(1);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AURA_WHITE), oPC, fDur);
        
        if(GetHasSpellEffect(SPELL_SOUL_OF_ORDER, oPC))
        {
        	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageReduction(3, DAMAGE_POWER_PLUS_THREE, 0), oPC, fDur);
        }
        
        /**To add into PRCEffectHeal
        if(GetHasSpellEffect(SPELL_SOUL_OF_LIGHT, oTarget))
        {
        	//2x the spell level bonus
        	nHP += (StringToInt(Get2DACache("spells", "Innate", PRCGetSpellId()) *2);
        	if(nHP >= 10)
        	{	
        		effect eEffect = GetFirstEffect(oPC);
        		while(GetIsEffectValid(eEffect))
        		{
        			//remove fatigue
        			if(GetEffectTag(eEffect) == "PRCFatigue")
        			{
        				RemoveEffect(oPC, eEffect);
        				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffecVisualEffect(VFX_DUR_CESSATE_POSITIVE) oTarget, 6.0f);
        			}
			  	
			  	//downgrade exhaustion
			  	if(GetEffectTag(eEffect) == "PRCExhausted")
			  	{	
			  		float fNew = IntToFloat(GetEffectDurationRemaining(eEffect));
			  		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectFatigue(), oTarget, fNew);
			  		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffecVisualEffect(VFX_DUR_CESSATE_POSITIVE) oTarget, 6.0f);
        			
			  	}
			  	eEffect = GetNextEffect(oPC);
			 }           		
                 }              
         */
        
        PRCSetSchool();
}