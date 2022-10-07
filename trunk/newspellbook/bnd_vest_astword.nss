/*
13/03/21 by Stratovarius

Astaroth, Unjustly Fallen
  
A fallen angel who would never accept responsibility for his own transgressions, Astaroth grants his summoners influence over the behavior of others, knowledge of hidden things, and the ability to sicken enemies.

Vestige Level: 4th
Binding DC: 22
Special Requirement: No

Influence: Astaroth's influence renders you incapable of taking responsibility for your own actions. You cannot admit any fault, acknowledge any mistake, or make reparations or 
apologies for any wrong, no matter the consequences or the evidence against you.

Granted Abilities: 
Astaroth guided mortals, and he still grants abilities based in knowledge and education. As a fallen angel, and then a vestige, his magics have grown ever grimmer and more distasteful;
he also grants powers based on directly controlling and offending others.

Word of Astaroth: You may charm a single creature with your glowing words. You must wait 5 rounds before making another attempt.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    float fRange = FeetToMeters(60.0);    
    int nDC = GetBinderDC(oBinder, VESTIGE_ASTAROTH);
    
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_ASTAROTH)) return;

    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
    {
        AssignCommand(oTarget, ClearAllActions(TRUE));
	    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE), EffectCharmed());
    	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oTarget, HoursToSeconds(GetBinderLevel(oBinder, VESTIGE_ASTAROTH))));   
    }
}

