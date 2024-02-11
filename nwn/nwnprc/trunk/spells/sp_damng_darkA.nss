//::///////////////////////////////////////////////
//:: Name      Damning Darkness
//:: FileName  sp_damng_dark.nss
//:://////////////////////////////////////////////
/**@file Damning Darkness
Evocation [Darkness, Evil]
Level: Clr 4, Darkness 4, Sor/Wiz 4
Components: V, M/DF
Casting Time: 1 action
Range: Touch
Target: Object touched
Duration: 10 minutes/level (D)
Saving Throw: None
Spell Resistance: No 

This spell is similar to darkness, except that those
within the area of darkness also take unholy damage.
Creatures of good alignment take 2d6 points of 
damage per round in the darkness, and creatures
neither good nor evil take 1d6 points of damage. As 
with the darkness spell, the area of darkness is a 
20-foot radius, and the object that serves as the 
spell's target can be shrouded to block the darkness
(and thus the dam­aging effect).

Damning darkness counters or dispels any light spell 
of equal or lower level.

Arcane Material Component: A dollop of pitch with a 
tiny needle hidden inside it.

Author:    Tenjac
Created:   6/12/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
void DarkLoop(object oTarget, object oPC);


#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);
    
    object oTarget = GetEnteringObject();
    object oPC = GetAreaOfEffectCreator();
    int nMetaMagic = PRCGetMetaMagicFeat(); 
    int nCasterLvl = PRCGetCasterLevel(oPC);
    effect eDark = EffectDarkness();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eDark, eDur);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, (600.0f * nCasterLvl));
            
    DarkLoop(oTarget, oPC);
    
    PRCSetSchool();
}
        
void DarkLoop(object oTarget, object oPC)
{   
    if(GetIsObjectValid(oTarget))
    {       
        if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD)
        {
        	int nDam = SpellDamagePerDice(oPC, 2) + d6(2);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_DIVINE), oTarget);
        }
        
        else if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL)
        {
        	int nDam = SpellDamagePerDice(oPC, 2) + d6(2);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_DIVINE), oTarget);
        }
        
        else
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), oTarget, 1.0f);
        }
            
    }
    DelayCommand(6.0f, DarkLoop(oTarget, oPC));
    
}