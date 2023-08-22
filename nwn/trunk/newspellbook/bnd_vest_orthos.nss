/*
25/03/21 by Stratovarius

Orthos, Sovereign of the Howling Dark
    
Ancient and unknowable, Orthos gives its summoners the power to sense what they cannot see, to fool the sight of others, and to turn their breath into wind that can speak or scour flesh from bones.
  
Vestige Level: 8th
Binding DC: 35
Special Requirement: You must summon Orthos within an area of bright illumination.
  
Influence: While influenced by Orthos, you are averse to darkened areas and loud noises. Although you can endure such conditions, they give you a sense of panic and make you short of breath. 
Orthos requires that you always carry an active light source with a brightness at least equal to that of a candle, and that you not cover it or allow it to be darkened for more than 1 round. 
Additionally, Orthos requires that you speak only in a whisper.
  
Granted Abilities: 
Orthos gives you blindsight, displacement, and a breath weapon that you can use as a weapon.

Blindsight: You gain blindsight.

Displacement: You surround yourself with a light-bending glamer that makes it difficult for others to surmise your true location. Any melee or ranged attack directed at you has a 50% miss chance.

Whirlwind Breath: As a standard action, you can exhale a scouring blast of wind in a 60-foot cone. Your whirlwind breath deals 1d6 points of damage per binder level you possess. 
Every creature in the area can attempt a Reflex save to halve the damage, and must also succeed on a Fortitude save or be knocked prone and moved 1d4×10 feet away from you. 
Once you have used this ability, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 
	
    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_AIR1), EffectPact(oBinder));
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(PSI_DUR_SHADOW_BODY));
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ORTHOS_SIGHT))
    {
		eLink  = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ULTRAVISION));
        eLink  = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT));
        eLink  = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        effect eTrueSee = EffectTrueSeeing();

        // Adjust to PnP-like True Seeing
        if(GetPRCSwitch(PRC_PNP_TRUESEEING))
        {
            eTrueSee  = EffectSeeInvisible();
            int nSpot = GetPRCSwitch(PRC_PNP_TRUESEEING_SPOT_BONUS);
            // Default to 15
            if(nSpot == 0)
                nSpot = 15;
            effect eSpot = EffectSkillIncrease(SKILL_SPOT, nSpot);
            eTrueSee     = EffectLinkEffects(eTrueSee , eSpot);
        }

        // Finish the effect link
        eLink = EffectLinkEffects(eLink, eTrueSee);    
    }
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ORTHOS_DISPLACEMENT)) eLink = EffectLinkEffects(eLink, EffectConcealment(50));
	if (!GetIsVestigeExploited(oBinder, VESTIGE_ORTHOS_BREATH))  IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_ORTHOS_BREATH), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
   
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_WIND), oBinder);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SOUND_SYMBOL_STUNNING), oBinder);
}