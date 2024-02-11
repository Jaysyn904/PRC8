/*
   ----------------
   Fog from the Void, Solid Fog Enter

   true_utr_fogvoid
   ----------------

    1/9/06 by Stratovarius
*/ /** @file

    Fog from the Void

    Level: Perfected Map 1
    Range: 100 feet
    Area: 20' Radius 
    Duration: 1 Minute
    Spell Resistance: No
    Save: None
    Metautterances: Extend

    At your words, moisture in the air and ground condenses into a thick mist.
    You create a thick, roiling cloud of fog like the fog cloud spell.
    If you add 10 to the DC of your Truespeak check, you can create a solid fog, as the spell.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

void main()
{
    SetAllAoEInts(UTTER_FOG_VOID_SOLID,OBJECT_SELF, GetSpellSaveDC());

    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eSlow = EffectMovementSpeedDecrease(80);
    effect eConceal = EffectConcealment(20, MISS_CHANCE_TYPE_VS_MELEE);
    effect eConceal2 = EffectConcealment(100, MISS_CHANCE_TYPE_VS_RANGED);
    effect eMiss = EffectMissChance(100, MISS_CHANCE_TYPE_VS_RANGED);
    effect eHitReduce = EffectAttackDecrease(2);
    effect eDamReduce = EffectDamageDecrease(2, DAMAGE_TYPE_BLUDGEONING|DAMAGE_TYPE_PIERCING|DAMAGE_TYPE_SLASHING);
   
    // Link
    effect eLink = EffectLinkEffects(eConceal, eConceal2);
    eLink = EffectLinkEffects(eLink, eSlow);
    eLink = EffectLinkEffects(eLink, eMiss);
    eLink = EffectLinkEffects(eLink, eHitReduce);
    eLink = EffectLinkEffects(eLink, eDamReduce);

    //Fire cast spell at event for the target
    SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), UTTER_FOG_VOID_SOLID, FALSE));

    // Maximum time possible. If its less, its simply cleaned up when the utterance ends.
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(20));
}
