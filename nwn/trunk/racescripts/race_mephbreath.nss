
//::///////////////////////////////////////////////
//:: [Mephling Breath Weapon]
//:: [prc_mephbreath.nss]
//:: [Jaysyn / PRC 20220428]
//::///////////////////////////////////////////////
/**@file  Each mephling has a breath weapon, the effect of which varies by the 
mephling's heritage. An air mephling's breath weapon is a cone of dust and grit 
(piercing damage), an earth mephling's breath weapon is a cone of rock shards 
and pebbles (bludgeoning damage), a fire mephling's breath weapon is a cone of 
flame (fire damage), and a water mephling's breath weapon is a cone of caustic 
liquid (acid damage). Regardless of the effect, a mephling's breath weapon fills 
a 15-foot cone, deals 1d8 points of damage to each target, and allows a Reflex 
save (10 + 1/2 mephling's Hit Dice + mephling's Con modifier) for half damage. 
A 1st level mephling can use his breath weapon once per day; a higher-level 
mephling gains one additional use per day for every four levels he has attained. 
If a mephling can use his breath weapon more than once per day, 1d4 rounds 
must pass between consecutive uses of the breath weapon.

//////////////////////////////////////////////////////////////////////////////*/

#include "prc_inc_spells"
#include "prc_inc_breath"
#include "prc_inc_combat"


//:: Returns range in feet for breath struct. Conversion to meters is
//:: handled internally in the include
float GetRangeFromSize(int nSize)
{
    float fRange = 15.0;
    switch(nSize)
    {
        case CREATURE_SIZE_FINE:
        case CREATURE_SIZE_DIMINUTIVE:
        case CREATURE_SIZE_TINY:        fRange = 10.0; break;
        case CREATURE_SIZE_SMALL:       fRange = 15.0; break;
        case CREATURE_SIZE_MEDIUM:      fRange = 20.0; break;
        case CREATURE_SIZE_LARGE:       fRange = 30.0; break;
        case CREATURE_SIZE_HUGE:        fRange = 40.0; break;
        case CREATURE_SIZE_GARGANTUAN:  fRange = 50.0; break;
        case CREATURE_SIZE_COLOSSAL:    fRange = 60.0; break;
    }
    return fRange;
}


void main()
{
//:: Declare major variables.
    object oPC = OBJECT_SELF;
	
    int nHD  = GetHitDice(oPC);
	int nSaveDCBonus = (nHD/2);
	int nVis;
	
	location lTarget = PRCGetSpellTargetLocation();
	
	struct breath MephBreath;

//:: Range calculation
    float fRange = GetRangeFromSize(PRCGetCreatureSize(oPC));

//:: Flat 1d8 damage breath weapon
    int nDice = 1;    

//:: Sanity check, mephlings only.
    int nMephType =	GetHasFeat(FEAT_AIR_MEPHLING, oPC)		?	DAMAGE_TYPE_PIERCING :
					GetHasFeat(FEAT_EARTH_MEPHLING, oPC)	?	DAMAGE_TYPE_BLUDGEONING :
					GetHasFeat(FEAT_FIRE_MEPHLING, oPC)		?	DAMAGE_TYPE_FIRE :
					GetHasFeat(FEAT_WATER_MEPHLING, oPC)	?	DAMAGE_TYPE_ACID :
					-1;

//:: Assemble breath weapon struct.
    MephBreath = CreateBreath(oPC, 0, fRange, nMephType, 10, nDice, ABILITY_CONSTITUTION, nSaveDCBonus);

//:: Set breath weapon VFX.
    switch(nMephType)
    {
        case DAMAGE_TYPE_FIRE:       	nVis = VFX_FNF_DRAGBREATHGROUND;	break;
        case DAMAGE_TYPE_ACID:       	nVis = VFX_FNF_DRAGBREATHACID;   	break;
        case DAMAGE_TYPE_PIERCING:   	nVis = VFX_FNF_DRAGBREATHSONIC;   	break;
        case DAMAGE_TYPE_BLUDGEONING:	nVis = VFX_FNF_DRAGBREATHODD;   	break;
        default:                     	nVis = VFX_FNF_DRAGBREATHODD;    	break;
    }

//:: Actual breath effect
    ApplyBreath(MephBreath, lTarget);

//:: Breath weapon VFX
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nVis), lTarget);

}