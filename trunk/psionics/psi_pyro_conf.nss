/*
    prc_pyro_conf

    Aoe, high damage, extra saves or die

    By: Flaming_Sword
    Created: Dec 7, 2007
    Modified: Dec 7, 2007
*/

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    int nDamageType = GetPersistantLocalInt(oPC, "PyroDamageType");
    int nImpactVFX = GetPersistantLocalInt(oPC, "PyroImpactVFX");
    int nImpactBigVFX = GetPersistantLocalInt(oPC, "PyroImpactBigVFX");
    int nSaveType = GetPersistantLocalInt(oPC, "PyroSave");
    int nDC = 15 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
    int nDice = 15;
    int bSaved = FALSE;
    int nTemp;
    float fDelay;
    location lTarget = GetLocation(oPC);

    // Declare the spell shape, size and the location.  Capture the first target object in the shape.
    // Cycle through the targets within the spell shape until an invalid object is captured.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(GetPersistantLocalInt(oPC, "PyroBurst")), lTarget);
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while (GetIsObjectValid(oTarget))
    {
        bSaved = FALSE;
        // Filter out the caster if he is supposed to be immune to the burst.
        if (oPC != oTarget)
        {
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                //Fire cast spell at event for the specified target
                PRCSignalSpellEvent(oTarget, TRUE, SPELL_CONFLAGRATION);

                fDelay = PRCGetSpellEffectDelay(lTarget, oTarget);

                int nDam = (nDamageType == DAMAGE_TYPE_SONIC) ? d4(nDice) : d6(nDice);  //reduced damage dice
                if((nDamageType == DAMAGE_TYPE_COLD) || (nDamageType == DAMAGE_TYPE_ELECTRICAL) || (nDamageType == DAMAGE_TYPE_ACID))
                    nDam = max(nDice, nDam - nDice);  //minimum of 1 per die
                // Damage damage type is the simple case, just get the total damage
                // of the spell's type, apply metamagic and roll the save.

                if(nDamageType == DAMAGE_TYPE_COLD)
                {   // cold element uses fort save instead of reflex
                    if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, nSaveType, oPC, fDelay))
                    {
                        bSaved = TRUE;
                        if(GetHasMettle(oTarget, SAVING_THROW_FORT))
                            nDam = 0;
                        else
                            nDam /= 2;
                    }
                }
                else
                {
                    nTemp = PRCGetReflexAdjustedDamage(nDam, oTarget, nDC, nSaveType);
                    if(nDam != nTemp)
                    {
                        bSaved = TRUE;
                        nDam = nTemp;
                    }
                }

                if(bSaved == FALSE)
                {
                    if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, nSaveType, oPC, fDelay))
                    {
                        DeathlessFrenzyCheck(oTarget);
                        //Apply the death effect and VFX impact
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                    }
                }

                // Adjust damage for reflex save / evasion / imp evasion

                //Set the damage effect
                if (nDam > 0)
                {
                    effect eDamage = PRCEffectDamage(oTarget, nDam, nDamageType);

                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                    PRCBonusDamage(oTarget);

                    // This visual effect is applied to the target object not the location as above.
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nImpactBigVFX), oTarget));
                }
            }
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
