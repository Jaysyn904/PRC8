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

Whirlwind Breath: As a standard action, you can exhale a scouring blast of wind in a 60-foot cone. Your whirlwind breath deals 1d6 points of damage per binder level you possess. 
Every creature in the area can attempt a Reflex save to halve the damage, and must also succeed on a Fortitude save or be knocked prone and moved 1d4×10 feet away from you. 
Once you have used this ability, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"
#include "prc_inc_combmove"

void main()
{
    object oBinder = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    float fRange = FeetToMeters(60.0);    
    int nDC = GetBinderDC(oBinder, VESTIGE_ORTHOS);
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_ORTHOS);
    
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_ORTHOS)) return;

    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, fRange, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != oBinder)
        {
    	    int nDamage = d6(nBinderLevel);
    	    //Run the damage through the various reflex save and evasion feats
    	    nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_NONE);
    	    if(nDamage > 0)
    	    {
    	        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE), oTarget);
    	        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_WIND), oTarget);
    	    }        
        
        	if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
        	{
        	    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_WIND), oTarget);
        	    _DoBullRushKnockBack(oTarget, oBinder, d4()*10.0);
        	    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, RoundsToSeconds(1)));
        	}    
        }
        
    oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, fRange, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }   
}

