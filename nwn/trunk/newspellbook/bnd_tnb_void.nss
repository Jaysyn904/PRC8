/*
Tenebrous Apostate - Blast of the Void

When you attain 5th level, you can use a turn or rebuke attempt to deal 1d8 points of damage per effective 
turning level to every living creature within a 30-foot cone. This ability is usable once per day.

Strat 05/03/21
*/

#include "bnd_inc_bndfunc"
#include "prc_inc_turning"

void BlastVoid(object oBinder)
{    
    int nTurnLevel = GetTurningClassLevel(oBinder, SPELL_TURN_UNDEAD);
    location lTarget = PRCGetSpellTargetLocation();
    float fRange = FeetToMeters(30.0);    
    
    vector vOrigin = GetPosition(oBinder);
    vector vTarget = GetPositionFromLocation(lTarget);
    float fAngle   = acos((vTarget.x - vOrigin.x) / GetDistanceBetweenLocations(GetLocation(oBinder), lTarget));        
    DrawLinesInACone(nTurnLevel, fRange, GetLocation(oBinder), fAngle, DURATION_TYPE_INSTANT, VFX_IMP_NEGBLAST_ENERGY, 0.0f, 20, 1.5f);    
    
    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, fRange, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != oBinder && PRCGetIsAliveCreature(oTarget))
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGBLAST_ENERGY), oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d8(nTurnLevel), DAMAGE_TYPE_DIVINE), oTarget);
        }
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, fRange, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    } 
}    

void main()
{
    object oBinder = OBJECT_SELF;
    
    if(BindAbilCooldown(oBinder, VESTIGE_TENEBROUS_TURN, VESTIGE_TENEBROUS)) 
    	BlastVoid(oBinder);
    else if(GetHasFeat(FEAT_TURN_UNDEAD, oBinder))
    {
        DecrementRemainingFeatUses(oBinder, FEAT_TURN_UNDEAD);
        BlastVoid(oBinder);
    }    
    else
    {
        SpeakStringByStrRef(40550);
        IncrementRemainingFeatUses(oBinder, FEAT_TENEBROUS_BLAST_VOID);
    }    
}

