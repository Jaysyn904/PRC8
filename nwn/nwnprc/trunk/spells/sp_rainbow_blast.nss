//::///////////////////////////////////////////////
//:: Name      Rainbow Blast
//:: FileName  sp_rainbow_blast.nss
//:://////////////////////////////////////////////
/**@file Rainbow Blast
Evocation [Light]
Level: Sorcerer/wizard 3
Components: V, S, M
Casting Time: 1 standard action
Range: 120 ft.
Area: 120-ft. line
Duration: Instantaneous
Saving Throw: Reflex half
Spell Resistance: Yes

This spell is a wide-spectrum blast of
radiant energy composed of all five
energy types. Rainbow blast deals 1d6
points of damage from each of the five
energy types (acid, cold, electricity,
fire, and sonic), for a total of 5d6 points
of damage. Creatures apply resistance
to energy separately for each type of
damage.
As you gain in levels, the damage
die increases in size. At 7th level the
spell deals 5d8 points of damage, at 9th
level it deals 5d10 points of damage,
and at 11th level it deals 5d12 points of
damage; one die for each of the five
energy types.
Focus: A small clear gem or crystal
prism worth at least 50 gp.

Author:    Tenjac
Created:   6/28/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "spinc_bolt"

int GetDieType(int nCasterLevel)
{
    if(nCasterLevel > 10) return 12;
    if(nCasterLevel >  8) return 10;
    if(nCasterLevel >  6) return  8;
    return 6;
}

void DoBoltVFX(location lCaster, location lTarget)
{
    // Do VFX. This is moderately heavy, so it isn't duplicated by Twin Power
    float fAngle             = GetRelativeAngleBetweenLocations(lCaster, lTarget);
    float fRadius            = FeetToMeters(5.0f);
    float fVFXLength         = GetVFXLength(lCaster, 36.6f, GetRelativeAngleBetweenLocations(lCaster, lTarget));
    // A tube of beams, radius 5ft, starting 1m from manifester and running for the length of the line
    BeamGengon(DURATION_TYPE_TEMPORARY, VFX_BEAM_MIND, lCaster, fRadius, fRadius,
               1.0f, fVFXLength, // Start 1m from the manifester, end at LOS end
               8, // 8 sides
               4.5f, "prc_invisobj",
               0.0f, // Drawn instantly
               0.0f, 0.0f, 45.0f, "y", fAngle, 0.0f,
               -1, -1, 0.0f, 1.0f, // No secondary VFX
               4.5f
               );
}

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    location lCaster = GetLocation(OBJECT_SELF);
    vector vOrigin = GetPosition(OBJECT_SELF);

    int nCasterLevel = PRCGetCasterLevel();
    int nPenetr = nCasterLevel + SPGetPenetr();
    int nDieSides = GetDieType(nCasterLevel);

    DoBoltVFX(lCaster, lTarget);

    int nDamage;
    int nSaveDC;
    float fDelay;


    // individual effect
    effect eDamage;

    // spell damage effects
    // Loop over targets in the spell shape
    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCYLINDER, 36.6f, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != oCaster && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            // Let the AI know
            PRCSignalSpellEvent(oTarget, TRUE, SPELL_RAINBOW_BLAST, oCaster);

            // Make an SR check
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
            {
                nSaveDC = PRCGetSaveDC(oTarget, OBJECT_SELF);

                fDelay = GetDistanceBetweenLocations(lCaster, GetLocation(oTarget)) / 20.0f;

                // Roll fire damage
                nDamage = PRCGetMetaMagicDamage(DAMAGE_TYPE_FIRE, 1, nDieSides);
                nDamage += SpellDamagePerDice(oCaster, 1);
                // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nSaveDC, SAVING_THROW_TYPE_FIRE);
                if(nDamage > 0)
                {
                    eDamage = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_FIRE);
                    DelayCommand(1.0f + fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                    DelayCommand(1.0f + fDelay, PRCBonusDamage(oTarget));
                    DelayCommand(1.0f + fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_S), oTarget));
                }// end if - There was still damage remaining to be dealt after adjustments

                // Roll acid damage
                nDamage = PRCGetMetaMagicDamage(DAMAGE_TYPE_ACID, 1, nDieSides);
                nDamage += SpellDamagePerDice(oCaster, 1);
                // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nSaveDC, SAVING_THROW_TYPE_ACID);
                if(nDamage > 0)
                {
                    eDamage = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_ACID);
                    DelayCommand(1.0f + fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                    DelayCommand(1.0f + fDelay, PRCBonusDamage(oTarget));
                    DelayCommand(1.0f + fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ACID_S), oTarget));
                }// end if - There was still damage remaining to be dealt after adjustments

                // Roll cold damage
                nDamage = PRCGetMetaMagicDamage(DAMAGE_TYPE_COLD, 1, nDieSides);
                nDamage += SpellDamagePerDice(oCaster, 1);
                // Cold has a fort save for half
                if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_COLD))
                {
                    if (GetHasMettle(oTarget, SAVING_THROW_FORT))
                        nDamage = 0;
                    nDamage /= 2;
                }

                if(nDamage > 0)
                {
                    eDamage = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_COLD);
                    DelayCommand(1.0f + fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                    DelayCommand(1.0f + fDelay, PRCBonusDamage(oTarget));
                    DelayCommand(1.0f + fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_S), oTarget));
                }// end if - There was still damage remaining to be dealt after adjustments

                // Roll electrical damage
                nDamage = PRCGetMetaMagicDamage(DAMAGE_TYPE_ELECTRICAL, 1, nDieSides);
                nDamage += SpellDamagePerDice(oCaster, 1);
                // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nSaveDC, SAVING_THROW_TYPE_ELECTRICITY);
                if(nDamage > 0)
                {
                    eDamage = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_ELECTRICAL);
                    DelayCommand(1.0f + fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                    DelayCommand(1.0f + fDelay, PRCBonusDamage(oTarget));
                    DelayCommand(1.0f + fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_S), oTarget));
                }// end if - There was still damage remaining to be dealt after adjustments

                // Roll sonic damage
                nDamage = PRCGetMetaMagicDamage(DAMAGE_TYPE_SONIC, 1, nDieSides);
                nDamage += SpellDamagePerDice(oCaster, 1);
                // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nSaveDC, SAVING_THROW_TYPE_SONIC);
                if(nDamage > 0)
                {
                    eDamage = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_SONIC);
                    DelayCommand(1.0f + fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                    DelayCommand(1.0f + fDelay, PRCBonusDamage(oTarget));
                    DelayCommand(1.0f + fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SONIC), oTarget));
                }// end if - There was still damage remaining to be dealt after adjustments
            }// end if - SR check
        }// end if - Target validity check

       // Get next target
        oTarget = MyNextObjectInShape(SHAPE_SPELLCYLINDER, 36.6f, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
    }// end while - Target loop

    PRCSetSchool();
}




















