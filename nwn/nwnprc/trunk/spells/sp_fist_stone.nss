//::///////////////////////////////////////////////
//:: Name      
//:: FileName  sp_.nss
//:://////////////////////////////////////////////
/**@file FIST OF STONE
Transmutation [Earth]
Level: Sorcerer/wizard 1, warmage 1
Components: V, S, M
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 minute

You transform one of your hands into
a mighty fist of living stone, gaining
a +6 enhancement bonus to Strength
for purposes of attacks, grapple
checks, or breaking and crushing
items. In addition, you gain the ability
to make one natural slam attack as
a standard action, dealing 1d6 points
of damage plus your new Strength
bonus (or 1-1/2 times your Strength
bonus if you make no other attacks
that round). You can make the slam
attack as a natural secondary attack
with the normal -5 penalty as part of a 
full attack action.
However, you cannot gain more than
one slam attack per round with this
spell due to a high base attack bonus
(+6 or higher).
Your fist undergoes no change in
size or form, remaining as flexible
and responsive as it would normally
be while under the spell’s effect.

Material Component: A pebble
inscribed with a stylized fist design.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_inc_natweap"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
        
        object oPC = OBJECT_SELF;
        effect eBuff = EffectAbilityIncrease(ABILITY_STRENGTH, 6);
        float fDur = 60.0f;
        
        if(PRCGetMetaMagicFeat() & METAMAGIC_EXTEND) fDur += fDur;
        
        AddNaturalSecondaryWeapon(oPC, "nw_it_crewpb005", 1);
        
        DelayCommand(fDur, RemoveNaturalSecondaryWeapons(oPC, "nw_it_crewpb005"));
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oPC, fDur, TRUE, SPELL_FIST_OF_STONE, PRCGetCasterLevel(oPC));
        PRCSetSchool();
}
        