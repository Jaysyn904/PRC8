//::///////////////////////////////////////////////
//:: Name      Bigby's Striking Fist
//:: FileName  sp_bigby_sf.nss
//:://////////////////////////////////////////////
/**@file Bigby's Striking Fist
Evocation [Force]
Level: Duskblade 2, sorcerer/wizard 2
Components: V,S,M
Casting Time: 1 standard action
Range: Medium
Target: One creature
Duration: Instantaneous
Saving Throw: Reflex partial
Spell Resistance: Yes

The attack bonus of this striking fist equals your
caster level + your key ability modifier + 2 for the
hand's Strength score (14). The fist deals 1d6 points
of nonlethal damage per two caster levels (maximum 5d6)
and attempts a bull rush.  The fist has a bonus of +4
plus +1 per two caster levels on the bull rush attempt,
and if successful it knocks the subject back in a
direction of your choice. This movement does not
provoke attacks of opportunity.  A subject that
succeeds on its Reflex save takes half damage and is
not subject to the bull rush attempt.

Material Components: Three glass beads.
**/
///////////////////////////////////////////////////////
// Author: Tenjac
// Date:   27.9.06
///////////////////////////////////////////////////////

int DoBullRushAttack(object oTarget, int nAttackBonus, int nCasterLevel);
void DoPush(object oTarget, object oCreator, int nReverse = FALSE);
int EvalSizeBonus(object oSubject);

#include "prc_inc_combat"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCasterLevel = PRCGetCasterLevel(oPC);
    int nDisplayFeedback;

    int nClassType = PRCGetLastSpellCastClass();

    int nAbilityScore = GetAbilityScoreForClass(nClassType, oPC);
    int nAttackBonus = (2 + nCasterLevel +  (nAbilityScore - 10)/2);

    int iAttackRoll = GetAttackRoll(oTarget, OBJECT_INVALID, OBJECT_INVALID, 0, nAttackBonus,0,nDisplayFeedback, 0.0, TOUCH_ATTACK_MELEE_SPELL);

    if (iAttackRoll > 0)
    {
        int nDam = d6(min(5, (nCasterLevel/2)));

        if(nMetaMagic & METAMAGIC_MAXIMIZE)
        {
            nDam = 6 * (min(5, (nCasterLevel/2)));
        }

        if(nMetaMagic & METAMAGIC_EMPOWER)
        {
            nDam += (nDam/2);
        }
		nDam += SpellDamagePerDice(oPC, min(5, nCasterLevel/2));
        //save
        if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, PRCGetSaveDC(oTarget, oPC), SAVING_THROW_TYPE_SPELL))
        {
            //Bull Rush
            if(DoBullRushAttack(oTarget, nAttackBonus, nCasterLevel))
            {
                DoPush(oTarget, oPC);
            }
        }

        else
        {
            nDam = (nDam / 2);
        }

        SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);
    }
    PRCSetSchool();
}


int DoBullRushAttack(object oTarget, int nAttackBonus, int nCasterLevel)
{
    int nSuccess = 0;
    int nSizeBonus = EvalSizeBonus(oTarget);
    int nBullRushFist = 14 + (4 + (nCasterLevel/2));
    int nBullRushOpposed = GetAbilityScore(oTarget, ABILITY_STRENGTH) + nSizeBonus;

    if(nBullRushFist > nBullRushOpposed)
    {
        nSuccess = 1;
    }
    return nSuccess;
}

void DoPush(object oTarget, object oCreator, int nReverse = FALSE)
{
            // Calculate how far the creature gets pushed
            float fDistance = FeetToMeters(10.0f);
            // Determine if they hit a wall on the way
            location lCreator   = GetLocation(oCreator);
            location lTargetOrigin = GetLocation(oTarget);
            vector vAngle          = AngleToVector(GetRelativeAngleBetweenLocations(lCreator, lTargetOrigin));
            vector vTargetOrigin   = GetPosition(oTarget);
            vector vTarget         = vTargetOrigin + (vAngle * fDistance);

            if(!LineOfSightVector(vTargetOrigin, vTarget))
            {
                // Hit a wall, binary search for the wall
                float fEpsilon    = 1.0f;          // Search precision
                float fLowerBound = 0.0f;          // The lower search bound, initialise to 0
                float fUpperBound = fDistance;     // The upper search bound, initialise to the initial distance
                fDistance         = fDistance / 2; // The search position, set to middle of the range

                do{
                    // Create test vector for this iteration
                    vTarget = vTargetOrigin + (vAngle * fDistance);

                    // Determine which bound to move.
                    if(LineOfSightVector(vTargetOrigin, vTarget))
                        fLowerBound = fDistance;
                    else
                        fUpperBound = fDistance;

                    // Get the new middle point
                    fDistance = (fUpperBound + fLowerBound) / 2;
                }while(fabs(fUpperBound - fLowerBound) > fEpsilon);
            }

            // Create the final target vector
            vTarget = vTargetOrigin + (vAngle * fDistance);

            // Move the target
            location lTargetDestination = Location(GetArea(oTarget), vTarget, GetFacing(oTarget));
            AssignCommand(oTarget, ClearAllActions(TRUE));
            AssignCommand(oTarget, JumpToLocation(lTargetDestination));
}

int EvalSizeBonus(object oSubject)
{
    int nSize = PRCGetCreatureSize(oSubject);
    int nBonus;

    //Eval size

    if(nSize == CREATURE_SIZE_LARGE)
    {
        nBonus = 4;
    }
    else if(nSize == CREATURE_SIZE_HUGE)
    {
        nBonus = 8;
    }
    else if(nSize == CREATURE_SIZE_GARGANTUAN)
    {
        nBonus = 12;
    }
    else if(nSize == CREATURE_SIZE_COLOSSAL)
    {
        nBonus = 16;
    }
    else if(nSize == CREATURE_SIZE_SMALL)
    {
        nBonus = -4;
    }
    else if(nSize == CREATURE_SIZE_TINY)
    {
        nBonus = -8;
    }
    else if(nSize == CREATURE_SIZE_DIMINUTIVE)
    {
        nBonus = -12;
    }
    else if (nSize == CREATURE_SIZE_FINE)
    {
        nBonus = -16;
    }
    else
    {
        nBonus = 0;
    }

    return nBonus;
}

