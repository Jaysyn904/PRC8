//::///////////////////////////////////////////////
//:: Dragonfire Channeling
//:: prc_drgfr_channl.nss
//::///////////////////////////////////////////////
/*
    Handles the Dragonfire Channeling feat
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Jan 09, 2008
//:://////////////////////////////////////////////


#include "prc_alterations"
#include "prc_inc_spells"
#include "prc_inc_sneak"
#include "prc_inc_turning"

void main()
{
    object oPC = OBJECT_SELF;
	
    //make sure there's TU uses left
    if (!GetHasFeat(FEAT_TURN_UNDEAD,oPC))
    {
    	FloatingTextStringOnCreature("You are out of Turn Undead uses for the day.", oPC, FALSE);
    	return;
    }
    
    //use up one
    DecrementRemainingFeatUses(OBJECT_SELF,FEAT_TURN_UNDEAD);
    
    effect eHealVis = EffectVisualEffect(VFX_IMP_HEALING_S);
    effect eHurtVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    
    int nDC              = 10 + GetAbilityModifier(ABILITY_CHARISMA, oPC) 
                              + ((GetTurningClassLevel()+1)/2);
    int nDieSize         = 6;
    int nNumberOfDice    = (GetTurningClassLevel()+1)/2;
    int nDamage;
    location lPC         = GetLocation(oPC);
    location lTarget     = PRCGetSpellTargetLocation();
    float fWidth         = FeetToMeters(15.0f);
    float fDelay;
    vector vOrigin       = GetPosition(oPC);
    effect eDamage;
    object oTarget;
    int nSpellID         = GetSpellId();
    int nDamageType      = GetDragonfireDamageType(oPC);
    int nSaveType        = (nDamageType == DAMAGE_TYPE_ACID)          ? SAVING_THROW_TYPE_ACID :
                           (nDamageType == DAMAGE_TYPE_COLD)          ? SAVING_THROW_TYPE_ACID :
                           (nDamageType == DAMAGE_TYPE_ELECTRICAL)    ? SAVING_THROW_TYPE_ELECTRICITY :
                           (nDamageType == DAMAGE_TYPE_FIRE)          ? SAVING_THROW_TYPE_ACID :
                           SAVING_THROW_TYPE_SONIC;
    
    // Loop over targets in the cone shape
    oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget))
    {
       if(oTarget != oPC &&
          spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC)
          )
       {
       	    // Let the AI know
            PRCSignalSpellEvent(oTarget, TRUE, nSpellID, oPC);
            // Roll damage
            nDamage = 0;
            int i;
            for (i = 0; i < nNumberOfDice; i++)
                   nDamage += Random(nDieSize) + 1;
            
            // Adjust damage according to Reflex Save, Evasion or Improved Evasion
            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType);

            if(nDamage > 0)
            {
                 fDelay = GetDistanceBetweenLocations(lPC, GetLocation(oTarget)) / 20.0f;
                 eDamage = EffectDamage(nDamage, nDamageType);
                 DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                 DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHurtVis, oTarget));
            }// end if - There was still damage remaining to be dealt after adjustments

        }// end if - Target validity check

        // Get next target
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }// end while - Target loop
    
}