/**
 * @file
 * Spellscript for Ronove Vestige
 *
 
Far Hand: As a swift action, you can lift and move an unattended object as per the Far Hand psionic power. Alternatively, you can use the telekinetic force to
push a creature as a standard action. The force deals 1d6 points of damage to the target and initiates a bull rush, using the force’s Strength modifier and adding a +2 bonus. 
Once you have used your far hand in this way, you cannot use it again for 5 rounds. The force is considered Medium in size, and it has a Strength score equal to your effective binder level.
 
 */

#include "bnd_inc_bndfunc"
#include "psi_inc_psifunc"
#include "prc_inc_combmove"

void main()
{
    object oBinder = OBJECT_SELF;
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_RONOVE);
    int nSLA = GetSpellId();
    
    // All of these are under the same cooldown
    if (nSLA == VESTIGE_RONOVE_BULLRUSH)
    {
    	if(!BindAbilCooldown(oBinder, VESTIGE_RONOVE_BULLRUSH, VESTIGE_RONOVE)) return;
    }	
    
    switch(nSLA){
        case VESTIGE_RONOVE_FARHAND:
        {
            UsePower(POWER_FARHAND, CLASS_TYPE_PSION, TRUE, nBinderLevel);
            break;
        } 
        case VESTIGE_RONOVE_BULLRUSH:
        {
        	object oTarget = PRCGetSpellTargetObject();
        	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(), DAMAGE_TYPE_MAGICAL), oTarget);
        	// Turn it into an ability modifier
        	nBinderLevel = (nBinderLevel - 10) / 2;
            SetLocalInt(oBinder, "RonoveBullRush", nBinderLevel+2);
            DoBullRush(oBinder, oTarget, 0, FALSE, FALSE, TRUE, 0);
            DelayCommand(0.5, DeleteLocalInt(oBinder, "RonoveBullRush"));
            break;
        } 
    }
}
        