/*
   ----------------
   Deathmark

   tob_dw_dthmrk
   ----------------

   15/07/07 by Stratovarius
*/ /** @file

    Deathmark

    Desert Wind (Strike) [Fire]
    Level: Swordsage 3
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature
    Area: Variable.
    Saving Throw: Reflex half, see text.

    As your weapon strikes your foe, his body convulses as waves of flame run down
    your blade into his body. The fire causes him to briefly glow with a brilliant
    internal fire before the flames erupt from his body in a terrible explosion.
    
    When you strike your foe, all creatures in the area (see table below) take 6d6 fire damage,
    Reflex save for half. You are immune to this effect.
    This maneuver is a supernatural maneuver.
    
    Size        Radius
    Small or Less   5'
    Medium      10'
    Large       20'
    Huge        30'
    Gargantuan      40'
    Colossal        50'
*/

#include "tob_inc_move"
#include "tob_movehook"

float DoDeathmarkArea(object oTarget)
{
    float fDist = 0.0;
    int nSize = PRCGetCreatureSize(oTarget);
    if (nSize == CREATURE_SIZE_SMALL || nSize == CREATURE_SIZE_TINY || nSize == CREATURE_SIZE_FINE || nSize == CREATURE_SIZE_DIMINUTIVE)
        fDist = 5.0;
    else if (nSize == CREATURE_SIZE_MEDIUM)
        fDist = 10.0;
    else if (nSize == CREATURE_SIZE_LARGE)
        fDist = 20.0;
    else if (nSize == CREATURE_SIZE_HUGE)
        fDist = 30.0;
    else if (nSize == CREATURE_SIZE_GARGANTUAN)
        fDist = 40.0;
    else if (nSize == CREATURE_SIZE_COLOSSAL)
        fDist = 50.0;
        
    return fDist;
}

void Deathmark(object oInitiator, object oTarget)
{
    if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    {
        location lTarget = GetLocation(oTarget);
        float fDist = DoDeathmarkArea(oTarget);
        //FloatingTextStringOnCreature("Deathmark Area "+FloatToString(fDist), oInitiator);
        int nDC = 13 + GetAbilityModifier(ABILITY_WISDOM, oInitiator);
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);

        //Get the first target in the radius around the caster
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(fDist), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        //FloatingTextStringOnCreature("Deathmark First Target "+GetName(oTarget), oInitiator);
        while(GetIsObjectValid(oTarget))
        {
            //FloatingTextStringOnCreature("Deathmark Target is Valid "+GetName(oTarget), oInitiator);
            if(oTarget != oInitiator)
            {
                //FloatingTextStringOnCreature("Deathmark Target isn't Initiator", oInitiator);
                SignalEvent(oTarget, EventSpellCastAt(oInitiator, GetSpellId()));
                int nDamage = d6(6);
                if (GetLocalInt(oInitiator, "DesertFire")) nDamage += d6();
                //Run the damage through the various reflex save and evasion feats
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_FIRE);
                if(nDamage > 0)
                {
                    //FloatingTextStringOnCreature("Deathmark Burning", oInitiator);
                    effect eFire = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                    // Apply effects to the currently selected target. 
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        //Get the next target in the specified area around the caster
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(fDist), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
    }
}

void TOBAttack(object oTarget, object oInitiator)
{
    //FloatingTextStringOnCreature("Deathmark TOBAttack", oInitiator);
    effect eNone;
    PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Deathmark Hit", "Deathmark Miss");
    Deathmark(oInitiator, oTarget);
}

void main()
{
    if (!PreManeuverCastCode())
    {
        // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
        DelayCommand(0.0, TOBAttack(oTarget, oInitiator));
    }
}