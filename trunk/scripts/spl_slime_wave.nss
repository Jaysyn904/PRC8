#include "prc_alterations"
//#include "x2_inc_spellhook"
#include "prc_inc_spells"

void RunImpact(object oTarget, object oCaster);

void main()
{
    //Declare major variables
    float fDist;
    int nDC = 10 + GetLevelByClass(CLASS_TYPE_OOZEMASTER);
    int nDamage;
    int nDuration = GetLevelByClass(CLASS_TYPE_OOZEMASTER);
    object oTarget;
    effect eFire;
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);

    effect eDur = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Signal spell cast at event to fire.
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));

            //Calculate the delay time on the application of effects based on the distance
            //between the caster and the target
            fDist = GetDistanceBetween(OBJECT_SELF, oTarget)/20;

            // Make appropriate saving throw.
            if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_ACID, OBJECT_SELF) && oTarget != OBJECT_SELF)
            {
                nDamage = d6(2);

                eFire = EffectDamage(nDamage, DAMAGE_TYPE_ACID);

                // Apply effects to the currently selected target.
                DelayCommand(fDist, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
                DelayCommand(fDist, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));

                effect eMind = EffectVisualEffect(VFX_DUR_IOUNSTONE_RED);
                //effect stun = EffectLinkEffects(EffectAbilityDecrease(ABILITY_CONSTITUTION, d6()), eMind);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMind, oTarget, RoundsToSeconds(nDuration));
                ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, d6(), DURATION_TYPE_TEMPORARY, TRUE, RoundsToSeconds(nDuration));

                //----------------------------------------------------------------------
                // Apply the VFX that is used to track the spells duration
                //----------------------------------------------------------------------
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nDuration));
                object oSelf = OBJECT_SELF; // because OBJECT_SELF is a function
                DelayCommand(6.0f, RunImpact(oTarget, oSelf));
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
    }
}

void RunImpact(object oTarget, object oCaster)
{
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (PRCGetDelayedSpellEffectsExpired(SPELL_SLIME_WAVE, oTarget, oCaster))
    {
        return;
    }

    if (GetIsDead(oTarget) == FALSE)
    {
        //----------------------------------------------------------------------
        // Calculate Damage
        //----------------------------------------------------------------------
        int nDamage = PRCMaximizeOrEmpower(6,2, METAMAGIC_NONE);
        effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
        effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
        eDam = EffectLinkEffects(eVis,eDam); // flare up
        ApplyEffectToObject (DURATION_TYPE_INSTANT, eDam, oTarget);
        DelayCommand(6.0f, RunImpact(oTarget, oCaster));
    }
}

