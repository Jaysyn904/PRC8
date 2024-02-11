/*:://////////////////////////////////////////////
//:: Name Bigby Hand include file.
//:: FileName SMP_INC_BIGBY
//:://////////////////////////////////////////////
    Used for the Bigby scripts (SMP_s_bigbyXXX).

    This won't have much, and is seperate from SMP_INC_SPELLS.

    Must include this INSTEAD of SMP_INC_SPELLS, as it is included anyway, just
    below.

    Note: Because it is only for Bigby Spells, no SMP_ prefix, because I can't
    be bothered to change it.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

// SMP_INC_BIGBY. Apply the duration effect of Interposing Hand, after removing previous ones, for fDuration
void ApplyInterposingHand(object oTarget, int nSpellId, float fDuration, object oCaster = OBJECT_SELF);
// SMP_INC_BIGBY. Applys the duration, and starts the attack and pushback of, the Forceful Hand effect
void ApplyForcefulHand(object oTarget, int nBonus, int nSpellId, float fDuration, object oCaster);
// SMP_INC_BIGBY. Forceful Hand Check. Will call SMP_DoMoveBackwards() if sucessful bullrush.
// Will continue this function until the duration runs out, or a new Forceful
// Hand is cast on them.
// * Local SMP_SPELL_BIGBYS_FORCEFUL_HAND_CASTTIMES must be == nCastTimes.
void ForcefulHandCheck(object oCaster, object oTarget, int nBonus, int nSpellId, int nCastTimes);
// SMP_INC_BIGBY. Applys the duration, and starts the grapple of, the Grasping Hand effect
// * Must hit AND THEN grapple to work. If grapple worked last time, only need to grapple.
void ApplyGraspingHand(object oTarget, int nAttackBonus, int nGrappleBonus, int nSpellId, float fDuration, object oCaster);
// SMP_INC_BIGBY. Grasping Hand Check. Will do 6 seconds of Entanglement if sucessful grapple.
// Will continue this function until the duration runs out, or a new Grasping
// Hand is cast on them.
// * Local SMP_SPELL_BIGBYS_GRASPING_HAND_CASTTIMES must be == nCastTimes.
// * Must hit AND THEN grapple to work. If grapple worked last time, only need to grapple.
void GraspingHandCheck(object oCaster, object oTarget, int nAttackBonus, int nGrappleBonus, int nSpellId, int nCastTimes);
// SMP_INC_BIGBY. Applys the duration, and starts the attacks of, the Clenched Fist effect
// * Must hit and may stun if the save failed.
void ApplyClenchedFist(object oTarget, int nAttackBonus, int nSpellSaveDC, int nSpellId, float fDuration, object oCaster);
// SMP_INC_BIGBY. Clenched Fist Check. Will do 1d8 + 11 damage on each sucessful hit each round.
// Will continue this function until the duration runs out, or a new Clenched
// Fist is cast on them.
// * Local SMP_SPELL_BIGBYS_CLENCHED_FIST_CASTTIMES must be == nCastTimes.
// * Must hit and it may stun if the save failed.
void ClenchedFistCheck(object oCaster, object oTarget, int nAttackBonus, int nSpellSaveDC, int nSpellId, int nCastTimes);
// SMP_INC_BIGBY. Applys the duration, and starts the grapple of, the Crushing Hand effect
// * Must hit AND THEN grapple to work. If grapple worked last time, only need to grapple.
void ApplyCrushingHand(object oTarget, int nAttackBonus, int nGrappleBonus, int nSpellId, float fDuration, object oCaster);
// SMP_INC_BIGBY. Grasping Hand Check. Will do 6 seconds of Entanglement if sucessful grapple, and
// and additional 2d6 + 12 damage.
// Will continue this function until the duration runs out, or a new Grasping
// Hand is cast on them.
// * Local SMP_SPELL_BIGBYS_CRUSHING_HAND_CASTTIMES must be == nCastTimes.
// * Must hit AND THEN grapple to work. If grapple worked last time, only need to grapple.
void CrushingHandCheck(object oCaster, object oTarget, int nAttackBonus, int nGrappleBonus, int nSpellId, int nCastTimes);

// Apply the duration effect of Interposing Hand, after removing previous ones, for fDuration
void ApplyInterposingHand(object oTarget, int nSpellId, float fDuration, object oCaster = OBJECT_SELF)
{
    // Declare effects
    effect eMove = EffectMovementSpeedDecrease(50);
    effect eAttack = EffectAttackDecrease(4);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_BIGBYS_INTERPOSING_HAND);

    // Link
    effect eLink = EffectLinkEffects(eAttack, eCessate);
    eLink = EffectLinkEffects(eLink, eDur);

    // Might add in slow (eMove) if they are under a cirtain weight
    // Note: We also get the actual weight of the creature too.
    // * Must be <= 20000, IE: 2000lbs
    if(GetWeight(oTarget) + SMP_GetCreatureWeight(oTarget) <= 20000)
    {
        eLink = EffectLinkEffects(eLink, eMove);
    }

    // Check if an enemy and no PvP
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Signal spell cast at event
        SMP_SignalSpellCastAt(oTarget, nSpellId);

        // Spell resistance
        if(!SMP_SpellResistanceCheck(oCaster, oTarget))
        {
            // Remove previous
            SMP_RemoveInterposingHands(oTarget);

            // Apply effects
            SMP_ApplyDuration(oTarget, eLink, fDuration);
        }
    }
}

// Applys the duration, and starts the attack and pushback of, the Forceful Hand effect
void ApplyForcefulHand(object oTarget, int nBonus, int nSpellId, float fDuration, object oCaster)
{
    // Declare effects
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // PvP Check
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Signal spell cast at event
        SMP_SignalSpellCastAt(oTarget, nSpellId);

        // Spell resistance and immunity
        if(!SMP_SpellResistanceCheck(oCaster, oTarget))
        {
            // Apply duration, cessate, effect
            SMP_ApplyDuration(oTarget, eCessate, fDuration);

            // Do the heartbeat start
            int nCastTimes = SMP_IncreaseStoredInteger(oTarget, "SMP_SPELL_BIGBYS_FORCEFUL_HAND_CASTTIMES");
            ForcefulHandCheck(oCaster, oTarget, nBonus, nSpellId, nCastTimes);
        }
    }
}

// Forceful Hand Check. Will call SMP_DoMoveBackwards() if sucessful bullrush.
// Will continue this function until the duration runs out, or a new Forceful
// Hand is cast on them.
// * Local SMP_SPELL_FORCEFUL_HAND_CASTTIMES must be == nCastTimes.
void ForcefulHandCheck(object oCaster, object oTarget, int nBonus, int nSpellId, int nCastTimes)
{
    // Check cast times, and spell effect
    if(GetHasSpellEffect(nSpellId, oTarget) &&
       GetLocalInt(oTarget, "SMP_SPELL_BIGBYS_FORCEFUL_HAND_CASTTIMES") == nCastTimes &&
       GetIsObjectValid(oTarget) && GetIsObjectValid(oCaster))
    {
        // Check range. If under 20M, do the move back.
        if(GetDistanceBetween(oCaster, oTarget) < 20.0)
        {
            // Check bullrush
            if(SMP_Bullrush(oTarget, nBonus, oCaster))
            {
                // Apply new VFX
                SMP_ApplyVFX(oTarget, EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND));

                // Move them back 2M
                AssignCommand(oTarget, SMP_ActionRepel(2.0, oCaster));
            }
        }
        // Call this function again
        DelayCommand(6.0, ForcefulHandCheck(oCaster, oTarget, nBonus, nSpellId, nCastTimes));
    }
}

// Applys the duration, and starts the grapple of, the Grasping Hand effect
// * Must hit AND THEN grapple to work. If grapple worked last time, only need to grapple.
void ApplyGraspingHand(object oTarget, int nAttackBonus, int nGrappleBonus, int nSpellId, float fDuration, object oCaster)
{
    // Declare effects
    effect eCessate = EffectVisualEffect(VFX_DUR_BIGBYS_GRASPING_HAND);

    // PvP Check
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Signal spell cast at event
        SMP_SignalSpellCastAt(oTarget, nSpellId);

        // Spell resistance and immunity
        if(!SMP_SpellResistanceCheck(oCaster, oTarget))
        {
            // Apply duration, cessate, effect
            SMP_ApplyDuration(oTarget, eCessate, fDuration);

            // Do the heartbeat start
            int nCastTimes = SMP_IncreaseStoredInteger(oTarget, "SMP_SPELL_BIGBYS_GRASPING_HAND_CASTTIMES");
            GraspingHandCheck(oCaster, oTarget, nAttackBonus, nGrappleBonus, nSpellId, nCastTimes);
        }
    }
}
// Grasping Hand Check. Will do 6 seconds of Entanglement if sucessful grapple.
// Will continue this function until the duration runs out, or a new Grasping
// Hand is cast on them.
// * Local SMP_SPELL_BIGBYS_GRASPING_HAND_CASTTIMES must be == nCastTimes.
// * Must hit AND THEN grapple to work. If grapple worked last time, only need to grapple.
void GraspingHandCheck(object oCaster, object oTarget, int nAttackBonus, int nGrappleBonus, int nSpellId, int nCastTimes)
{
    // Check cast times, and spell effect
    if(GetHasSpellEffect(nSpellId, oTarget) &&
       GetLocalInt(oTarget, "SMP_SPELL_BIGBYS_GRASPING_HAND_CASTTIMES") == nCastTimes &&
       GetIsObjectValid(oTarget) && GetIsObjectValid(oCaster))
    {
        // Must hit first - if we are not already grappling.
        int bSucess = GetLocalInt(oTarget, "SMP_SPELL_BIGBYS_GRASPING_HAND_GRAPPLE");
        int bContinueGrapple = FALSE;
        int nAC = GetAC(oTarget);
        // Not sucessful requires attack check
        if(!bSucess)
        {
            bSucess = SMP_AttackCheck(oTarget, nAttackBonus, 0, 0, nAC, oCaster);
        }
        if(bSucess)
        {
            // Check grapple
            if(SMP_GrappleCheck(oTarget, nGrappleBonus, 0, 0, nAC, oCaster))
            {
                // We were sucessful, we will set the grasping hand to auto-hit next time
                bContinueGrapple = TRUE;

                // Declare effects
                effect eEntangle = EffectEntangle();
                // This cannot be dispelled - makes it ignored by Dispel, so the
                // DUR_CESSATE is used instead.
                eEntangle = SupernaturalEffect(eEntangle);

                // Apply effects for 6 seconds.
                SMP_ApplyDuration(oTarget, eEntangle, 6.0);
            }
        }
        // Set to continue the grapple, if bContinueGrapple is TRUE, else it is FALSE
        // and need a new attack next turn.
        SetLocalInt(oTarget, "SMP_SPELL_BIGBYS_GRASPING_HAND_GRAPPLE", bContinueGrapple);
        // Call this function again
        DelayCommand(6.0, GraspingHandCheck(oCaster, oTarget, nAttackBonus, nGrappleBonus, nSpellId, nCastTimes));
    }
}

// Applys the duration, and starts the attacks of, the Clenched Fist effect
// * Must hit and may stun if the save failed.
void ApplyClenchedFist(object oTarget, int nAttackBonus, int nSpellSaveDC, int nSpellId, float fDuration, object oCaster)
{
    // Declare effects
    effect eCessate = EffectVisualEffect(VFX_DUR_BIGBYS_CLENCHED_FIST);

    // PvP Check
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Signal spell cast at event
        SMP_SignalSpellCastAt(oTarget, nSpellId);

        // Spell resistance and immunity
        if(!SMP_SpellResistanceCheck(oCaster, oTarget))
        {
            // Apply duration, cessate, effect
            SMP_ApplyDuration(oTarget, eCessate, fDuration);

            // Do the heartbeat start
            int nCastTimes = SMP_IncreaseStoredInteger(oTarget, "SMP_SPELL_BIGBYS_CLENCHED_FIST_CASTTIMES");
            ClenchedFistCheck(oCaster, oTarget, nAttackBonus, nSpellSaveDC, nSpellId, nCastTimes);
        }
    }
}

// Clenched Fist Check. Will do 1d8 + 11 damage on each sucessful hit each round.
// Will continue this function until the duration runs out, or a new Clenched
// Fist is cast on them.
// * Local SMP_SPELL_BIGBYS_CLENCHED_FIST_CASTTIMES must be == nCastTimes.
// * Must hit and it may stun if the save failed.
void ClenchedFistCheck(object oCaster, object oTarget, int nAttackBonus, int nSpellSaveDC, int nSpellId, int nCastTimes)
{
    // Check cast times, and spell effect
    if(GetHasSpellEffect(nSpellId, oTarget) &&
       GetLocalInt(oTarget, "SMP_SPELL_BIGBYS_CLENCHED_FIST_CASTTIMES") == nCastTimes &&
       GetIsObjectValid(oTarget) && GetIsObjectValid(oCaster))
    {
        // Check attack roll
        if(SMP_AttackCheck(oTarget, nAttackBonus, 0, 0, GetAC(oTarget), oCaster))
        {
            // Apply damage
            int nDamage = SMP_MaximizeOrEmpower(8, 1, FALSE, 11);

            // Do damage (Bludgeoning)
            SMP_ApplyDamageToObject(oTarget, nDamage, DAMAGE_TYPE_BLUDGEONING);

            // Save for stunning
            if(!SMP_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster))
            {
                // Failed, apply 6 seconds of stun

                // Declare Effects
                effect eVis = EffectVisualEffect(VFX_IMP_STUN);
                effect eStun = EffectStunned();
                effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
                // Link effects
                effect eLink = EffectLinkEffects(eDur, eStun);
                // As Grasping Hand, make it supernautral, so the hand can be
                // dispelled only once
                eLink = SupernaturalEffect(eLink);

                // Apply effects
                SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, 6.0);
            }
        }
        // Call this function again
        DelayCommand(6.0, ClenchedFistCheck(oCaster, oTarget, nAttackBonus, nSpellSaveDC, nSpellId, nCastTimes));
    }
}
// Applys the duration, and starts the grapple of, the Crushing Hand effect
// * Must hit AND THEN grapple to work. If grapple worked last time, only need to grapple.
void ApplyCrushingHand(object oTarget, int nAttackBonus, int nGrappleBonus, int nSpellId, float fDuration, object oCaster)
{
    // Declare effects
    effect eCessate = EffectVisualEffect(VFX_DUR_BIGBYS_CRUSHING_HAND);

    // PvP Check
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Signal spell cast at event
        SMP_SignalSpellCastAt(oTarget, nSpellId);

        // Spell resistance and immunity
        if(!SMP_SpellResistanceCheck(oCaster, oTarget))
        {
            // Apply duration, cessate, effect
            SMP_ApplyDuration(oTarget, eCessate, fDuration);

            // Do the heartbeat start
            int nCastTimes = SMP_IncreaseStoredInteger(oTarget, "SMP_SPELL_BIGBYS_CRUSHING_HAND_CASTTIMES");
            CrushingHandCheck(oCaster, oTarget, nAttackBonus, nGrappleBonus, nSpellId, nCastTimes);
        }
    }
}
// Grasping Hand Check. Will do 6 seconds of Entanglement if sucessful grapple, and
// and additional 2d6 + 12 damage.
// Will continue this function until the duration runs out, or a new Grasping
// Hand is cast on them.
// * Local SMP_SPELL_BIGBYS_CRUSHING_HAND_CASTTIMES must be == nCastTimes.
// * Must hit AND THEN grapple to work. If grapple worked last time, only need to grapple.
void CrushingHandCheck(object oCaster, object oTarget, int nAttackBonus, int nGrappleBonus, int nSpellId, int nCastTimes)
{
    // Check cast times, and spell effect
    if(GetHasSpellEffect(nSpellId, oTarget) &&
       GetLocalInt(oTarget, "SMP_SPELL_BIGBYS_CRUSHING_HAND_CASTTIMES") == nCastTimes &&
       GetIsObjectValid(oTarget) && GetIsObjectValid(oCaster))
    {
        // Must hit first - if we are not already grappling.
        int bSucess = GetLocalInt(oTarget, "SMP_SPELL_BIGBYS_CRUSHING_HAND_GRAPPLE");
        int bContinueGrapple = FALSE;
        int nAC = GetAC(oTarget);
        // Not sucessful requires attack check
        if(!bSucess)
        {
            bSucess = SMP_AttackCheck(oTarget, nAttackBonus, 0, 0, nAC, oCaster);
        }
        if(bSucess)
        {
            // Check grapple
            if(SMP_GrappleCheck(oTarget, nGrappleBonus, 0, 0, nAC, oCaster))
            {
                // We were sucessful, we will set the grasping hand to auto-hit next time
                bContinueGrapple = TRUE;

                // Apply damage
                int nDamage = SMP_MaximizeOrEmpower(6, 2, FALSE, 12);

                // Do damage (Bludgeoning)
                SMP_ApplyDamageToObject(oTarget, nDamage, DAMAGE_TYPE_BLUDGEONING);

                // Declare effects
                effect eEntangle = EffectEntangle();
                // This cannot be dispelled - makes it ignored by Dispel, so the
                // DUR_CESSATE is used instead.
                eEntangle = SupernaturalEffect(eEntangle);

                // Apply effects for 6 seconds.
                SMP_ApplyDuration(oTarget, eEntangle, 6.0);
            }
        }
        // Set to continue the grapple, if bContinueGrapple is TRUE, else it is FALSE
        // and need a new attack next turn.
        SetLocalInt(oTarget, "SMP_SPELL_BIGBYS_CRUSHING_HAND_GRAPPLE", bContinueGrapple);
        // Call this function again
        DelayCommand(6.0, CrushingHandCheck(oCaster, oTarget, nAttackBonus, nGrappleBonus, nSpellId, nCastTimes));
    }
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
