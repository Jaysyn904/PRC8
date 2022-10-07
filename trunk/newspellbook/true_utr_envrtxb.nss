/*
   ----------------
   Energy Vortex, Heartbeat

   true_utr_envrtxb
   ----------------

    2/9/06 by Stratovarius
*/ /** @file

    Energy Vortex

    Level: Perfected Map 2
    Range: 100 feet
    Area: 20' Radius 
    Duration: 1 Minute
    Spell Resistance: Yes
    Save: None
    Metautterances: Extend, Empower

    Your words transform the nature of the air, turning it from harmless gas into a swirling mass of harmful energy.
    You fill the air around your foes with energy, dealing 2d6 acid, cold, electrical, or fire damage per round.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

void main()
{
    SetAllAoEInts(UTTER_ENERGY_VORTEX_ACID, OBJECT_SELF, GetTrueSpeakerDC(GetAreaOfEffectCreator()));

    //Declare major variables
    int nDamage;
    effect eDam;
    effect eVis; 
    int nPen = GetTrueSpeakPenetration(GetAreaOfEffectCreator());
    int nDamageType = GetLocalInt(GetAreaOfEffectCreator(), "UtterEnergyVortexDamage");
    if (nDamageType == DAMAGE_TYPE_ACID) eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    if (nDamageType == DAMAGE_TYPE_COLD) eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    if (nDamageType == DAMAGE_TYPE_ELECTRICAL) eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
    if (nDamageType == DAMAGE_TYPE_FIRE) eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
     
    //Start cycling through the AOE Object for viable targets including doors and placable objects.
    object oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
        //Fire cast spell at event for the target
    	SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), UTTER_ENERGY_VORTEX_ACID));
        //Spell resistance check
        if(!PRCDoResistSpell(GetAreaOfEffectCreator(), oTarget,nPen))
        {
           nDamage = d6(2);
           if (GetLocalInt(GetAreaOfEffectCreator(), "UtterEnergyVortexEmpower"))
	   {
	   	nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
           }
           //Set the damage effect
           eDam = EffectDamage(nDamage, nDamageType);
           //Apply damage and visuals
	   SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
           SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        }
        
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }
}
