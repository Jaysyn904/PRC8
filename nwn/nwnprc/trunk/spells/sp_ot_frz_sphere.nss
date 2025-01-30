//::///////////////////////////////////////////////
//:: Name      Otiluke's Freezing Sphere
//:: FileName  sp_ot_frz_sphere.nss
//:://////////////////////////////////////////////
/**@file Otiluke's Freezing Sphere
Evocation [Cold]
Level: Sor/Wiz 6 
Components: V, S, F 
Casting Time: 1 standard action 
Range: Long (400 ft. + 40 ft./level) 
Target, Effect, or Area: See text
Duration: Instantaneous or 1 round/level; see text
Saving Throw: Reflex half; see text
Spell Resistance: Yes

Freezing sphere creates a frigid globe of cold energy 
that streaks from your fingertips to the location you
select, where it explodes in a 10-foot-radius burst, 
dealing 1d6 points of cold damage per caster level 
(maximum 15d6) to each creature in the area. An 
elemental (water) creature instead takes 1d8 points
of cold damage per caster level (maximum 15d8).

You can refrain from firing the globe after 
completing the spell, if you wish. Treat this as a
touch spell for which you are holding the charge. 
You can hold the charge for as long as 1 round per 
level, at the end of which time the freezing sphere
bursts centered on you (and you receive no saving 
throw to resist its effect). Firing the globe in a 
later round is a standard action.

Focus: A small crystal sphere.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

int GetIsWaterElemental(object oTarget);

#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    object oPC = OBJECT_SELF;
    object oTarget;
    location lTarget = PRCGetSpellTargetLocation();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nDice = PRCMin(15, nCasterLvl);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int eDamageType = ChangedElementalDamage(oPC, DAMAGE_TYPE_COLD);
    int nDC, bIsElemental, nDam;
    float fDelay;
    effect eImp = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eVis = EffectVisualEffect(VFX_FNF_OTIL_COLDSPHERE);
    effect eDam;

    nCasterLvl += SPGetPenetr();

    // Apply AOE location explosion
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);

    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

    while(GetIsObjectValid(oTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget, oPC))
        {
            // Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_OTILUKES_FREEZING_SPHERE));

            if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl))
            {
                // Damage - it is 1d8 for water elementals!
                bIsElemental = GetIsWaterElemental(oTarget);
                nDC = PRCGetSaveDC(oTarget, oPC);

                nDam = bIsElemental ? d8(nDice) : d6(nDice);
                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                    nDam = bIsElemental ? 8 * nDice : 6 * nDice;
                if(nMetaMagic & METAMAGIC_EMPOWER)
                    nDam += (nDam/2);
				nDam += SpellDamagePerDice(oPC, nDice);
                nDam = PRCGetReflexAdjustedDamage(nDam, oTarget, nDC, SAVING_THROW_TYPE_COLD);

                // Need to do damage to apply visuals
                if(nDam > 0)
                {
                    eDam = PRCEffectDamage(oTarget, nDam, eDamageType);
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    PRCBonusDamage(oTarget);
                }
            }
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    PRCSetSchool();
}

int GetIsWaterElemental(object oTarget)
{
    if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
        return FALSE;

    int nAppearance = GetAppearanceType(oTarget);
    if(nAppearance == APPEARANCE_TYPE_ELEMENTAL_WATER
    || nAppearance == APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER)
        return TRUE;

    if(FindSubString(GetStringLowerCase(GetSubRace(oTarget)), "water elemental", 0) > -1)
        return TRUE;

    return FALSE;
}
