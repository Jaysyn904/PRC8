//::///////////////////////////////////////////////
//:: Name      
//:: FileName  sp_.nss
//:://////////////////////////////////////////////
/**@file Prismatic Wall
Abjuration
Level: Sor/Wiz 8 
Components: V, S 
Casting Time: 1 standard action 
Range: Close (25 ft. + 5 ft./2 levels) 
Effect: Wall 4 ft./level wide, 2 ft./level high 
Duration: 10 min./level (D) 
Saving Throw: See text 
Spell Resistance: See text

Prismatic wall creates a vertical, opaque wall; a 
shimmering, multicolored plane of light that 
protects you from all forms of attack. The wall 
flashes with seven colors, each of which has a 
distinct power and purpose. The wall is immobile, 
and you can pass through and remain near the wall
without harm. However, any other creature with 
less than 8 HD that is within 20 feet of the wall
is blinded for 2d4 rounds by the colors if it 
looks at the wall.

The wall’s maximum proportions are 4 feet wide per
caster level and 2 feet high per caster level. A 
prismatic wall spell cast to materialize in a 
space occupied by a creature is disrupted, and 
the spell is wasted.

Each color in the wall has a special effect. The
accompanying table shows the seven colors of the
wall, the order in which they appear, their 
effects on creatures trying to attack you or pass
through the wall, and the magic needed to negate
each color.

The wall can be destroyed, color by color, in 
consecutive order, by various magical effects;
however, the first color must be brought down 
before the second can be affected, and so on. 
A rod of cancellation or a mage’s disjunction 
spell destroys a prismatic wall, but an 
antimagic field fails to penetrate it. Dispel
magic and greater dispel magic cannot dispel 
the wall or anything beyond it. Spell resistance
is effective against a prismatic wall, but the 
caster level check must be repeated for each 
color present.

Color   Order   Effect of Color         

Red     1st     Deals 20 points of fire damage (Reflex half).  
Orange  2nd     Deals 40 points of acid damage (Reflex half).
Yellow  3rd     Deals 80 points of electricity damage (Reflex half).
Green   4th     Poison (Kills; Fortitude partial for 1d6 points of Con damage instead).
Blue    5th     Turned to stone (Fortitude negates). 
Indigo  6th     Will save or become insane (as insanity spell). 
Violet  7th     Creatures sent to another plane (Will negates). 

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;
    
    PRCSetSchool(SPELL_SCHOOL_ABJURATION);
    
    object oPC = OBJECT_SELF;
    location lLoc = PRCGetSpellTargetLocation();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    effect eAoE = EffectAreaOfEffect(VFX_PER_PRISMATIC_WALL);
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDur = (600.0 * nCasterLvl);
    
    if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
    
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoE, lLoc, fDur);

    object oAoE = GetAreaOfEffectObject(lLoc, "VFX_PER_PRISMATIC_WALL");
    SetAllAoEInts(SPELL_PRISMATIC_WALL, oAoE, PRCGetSpellSaveDC(SPELL_PRISMATIC_WALL, SPELL_SCHOOL_ABJURATION), 0, nCasterLvl);
	
	SetLocalObject(oAoE, "ExtraordinarySpellAim_Caster", oPC);

    PRCSetSchool();
}