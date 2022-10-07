/*
   ----------------
   Light Within Darkness
   
   tob_ssn_lightwd.nss
   ----------------

    18 MAR 09 by GC
*/ /** @file

*/
#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"


void TheLight(object oInitiator)
{
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), GetLocation(oInitiator));
        int nDC        = 10 + GetHitDice(oInitiator)/2 + GetAbilityModifier(ABILITY_WISDOM);
    effect eLink   = EffectBlindness();
           eLink   = SupernaturalEffect(eLink);
    effect eVis    = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    
    while(GetIsObjectValid(oTarget))
    {
        if(GetIsEnemy(oTarget) && !GetObjectSeen(oInitiator, oTarget))
        {// Mustn't see oInitiator at this time
            if(DEBUG) DoDebug("Didn't see you: " + ObjectToString(oTarget));
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
            {
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0); // Fail save? Blinded
                SetLocalInt(oInitiator, "SSN_DARKWL_SUCCESS", TRUE); // Set if someone was affected
            }
        }
        else if(DEBUG) DoDebug("Saw you: " + ObjectToString(oTarget));
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), GetLocation(oInitiator));
    }
    if(GetLocalInt(oInitiator, "SSN_DARKWL_SUCCESS"))// Only show if someone was affected.  Otherwise will act like normal attack round
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oInitiator);
}

void main()
{
    if (!PreManeuverCastCode())
    {
            // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
            return;
    }
    // End of Spell Cast Hook

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget, TRUE);
    effect eNone;

    if(move.bCanManeuver)
    {   
        TheLight(oInitiator);
        //DelayCommand(0.0, PerformAttackRound(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, FALSE, "", "", FALSE, FALSE, FALSE));
    }
}
