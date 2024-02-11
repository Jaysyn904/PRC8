////////////////////////////////////////////////////
// Consecrate On Enter
// sp_consecratea.nss
///////////////////////////////////////////////////////
/*Consecrate  
Evocation [Good]
Level:  Clr 2
Components:     V, S
Casting time:   1 standard action
Range:  Close (25 ft. + 5 ft./2 levels)
Area:   20-ft.-radius emanation
Duration:       2 hours/level
Saving Throw:   None
Spell Resistance:       No

This spell blesses an area with positive energy. Each Charisma check made
to turn undead within this area gains a +3 sacred bonus. Every undead creature
entering a consecrated area suffers minor disruption, giving it a -1 penalty on
attack rolls, damage rolls, and saves. Undead cannot be created within or summoned
into a consecrated area.

If the consecrated area contains an altar, shrine, or other permanent fixture 
dedicated to your deity, pantheon, or aligned higher power, the modifiers given 
above are doubled (+6 sacred bonus on turning checks, -2 penalties for undead in 
the area). You cannot consecrate an area with a similar fixture of a deity other 
than your own patron.

If the area does contain an altar, shrine, or other permanent fixture of a deity,
pantheon, or higher power other than your patron, the consecrate spell instead curses
the area, cutting off its connection with the associated deity or power. This secondary
function, if used, does not also grant the bonuses and penalties relating to undead, as
given above.

Consecrate counters and dispels desecrate. 
*/
#include "prc_inc_spells"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eVis =  EffectVisualEffect(VFX_IMP_SUNSTRIKE);

    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        effect eNegLink = EffectLinkEffects(EffectAttackDecrease(1), EffectDamageDecrease(1, DAMAGE_TYPE_BLUDGEONING|DAMAGE_TYPE_PIERCING|DAMAGE_TYPE_SLASHING));
        eNegLink = EffectLinkEffects(eNegLink, EffectSavingThrowDecrease(SAVING_THROW_ALL,1));
        eNegLink = EffectLinkEffects(eNegLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNegLink, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
    else
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oTarget);
}