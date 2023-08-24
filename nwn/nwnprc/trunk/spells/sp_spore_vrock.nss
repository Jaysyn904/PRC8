//::///////////////////////////////////////////////
//:: Name      Spores of the Vrock
//:: FileName  sp_spore_vrock.nss
//:://////////////////////////////////////////////
/**@file Spores of the Vrock 
Conjuration (Creation) [Evil]
Level: Clr 2, Demonologist 1 
Components: V S, M/DF 
Casting Time: 1 full round 
Area: 5-ft. radius, centered on caster
Duration: Instantaneous 
Saving Throw: Fortitude negates
Spell Resistance: Yes

The caster summons a mass of spores that fill the 
area around him.

The spores deal 1d8 points of damage to all 
creatures within 5 feet other than the caster. Then
they penetrate the skin and grow, dealing an 
additional 1d2 points of damage each round for 10 
rounds. At the end of this time, a tangle of viny 
growths covers each subject. A delay poison spell 
stops the spores' growth for its duration. Bless, 
neutralize poison, or remove disease kills the 
spores, as does sprinkling the victim with a vial
of holy water.

Arcane Material Component: The feathers of an 
avian creature with an intelligence score of at 
least 3 (a harpy, achaierai, or similar creature). 

Author:    Tenjac
Created:   5/10/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void SporeLoop(object oTarget, int nMetaMagic, int nRounds, object oCaster)
{
    if(nRounds > 0)
    {
        int nDam2 = d2(1);
        
        if(nMetaMagic & METAMAGIC_MAXIMIZE)
        {
            nDam2 = 2;
        }
        
        if(nMetaMagic & METAMAGIC_EMPOWER)
        {
            nDam2 += (nDam2/2);
        }
        nDam2 += SpellDamagePerDice(oCaster, 1);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam2, DAMAGE_TYPE_MAGICAL), oTarget);
        
        nRounds--;
        
        DelayCommand(6.0f, SporeLoop(oTarget, nMetaMagic, nRounds, oCaster));
    }
}
void main()
{
    object oPC = OBJECT_SELF;
    location lLoc = GetLocation(oPC);
    effect eVis = EffectVisualEffect(VFX_IMP_DISEASE_S);
    int nDam = d8(1);
    int nRounds = 10;
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lLoc);
    int nDC = PRCGetSaveDC(oTarget, oPC);
    int nCasterLvl = PRCGetCasterLevel(oTarget);
    int nMetaMagic = PRCGetMetaMagicFeat();
    
    if(nMetaMagic & METAMAGIC_MAXIMIZE)
    {
        nDam = 8;
    }
    
    if(nMetaMagic & METAMAGIC_EMPOWER)
    {
        nDam += (nDam/2);
    }
    nDam += SpellDamagePerDice(oPC, 1);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    
    while(GetIsObjectValid(oTarget))
    {
        if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
        {
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
            {
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);
                SporeLoop(oTarget, nMetaMagic, nRounds, oPC);
            }
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lLoc);
    }
    //SPEvilShift(oPC);
    PRCSetSchool();
}
    