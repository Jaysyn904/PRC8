#include "prc_inc_sp_tch"

int ooze_ranged_damage(effect eDamage, int splash_type)
{
    object target = PRCGetSpellTargetObject();

    if(!GetIsReactionTypeFriendly(target))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(target, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        //Make a touch attack to afflict target

       // GZ: * GetSpellCastItem() == OBJECT_INVALID is used to prevent feedback from showing up when used as OnHitCastSpell property
        if (PRCDoRangedTouchAttack(target))
        {
            effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, target);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, target);

            //Declare the spell shape, size and the location.  Capture the first target object in the shape.
            object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
            //Cycle through the targets within the spell shape until an invalid object is captured.
            while (GetIsObjectValid(oTarget))
            {
                /* Already damaged the target */
//                if (oTarget == target) continue;

                if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
                {
                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                        //Get the distance between the explosion and the target to calculate delay
                        float fDelay = GetDistanceBetweenLocations(GetLocation(target), GetLocation(oTarget))/20;

                        //Set the damage effect
                        effect eDam = EffectDamage(1, splash_type);

                        // Apply effects to the currently selected target.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                        //This visual effect is applied to the target object not the location as above.  This visual effect
                        //represents the flame that erupts on the target not on the ground.
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
               //Select the next target within the spell shape.
               oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
            }
            return TRUE;
        }
    }
    return FALSE;
}

void main()
{
    object target = PRCGetSpellTargetObject();
    int level = GetLevelByClass(CLASS_TYPE_OOZEMASTER);

    switch (GetSpellId())
    {
        case 2019: /* Brown Mold */
        {
            if (!GetHasFeat(FEAT_MIN_OOZY_TOUCH_BROWN))
            {
                FloatingTextStringOnCreature("You do not posses Brown Mold Oozy Touch.", OBJECT_SELF);
                return;
            }
            ooze_ranged_damage(EffectDamage(d6() + level, DAMAGE_TYPE_COLD), DAMAGE_TYPE_COLD);
            break;
        }
        case 2020: /* Gray Ooze */
        {
            if (!GetHasFeat(FEAT_MIN_OOZY_TOUCH_GRAY))
            {
                FloatingTextStringOnCreature("You do not posses Gray Ooze Oozy Touch.", OBJECT_SELF);
                return;
            }
            ooze_ranged_damage(EffectDamage(d6() + level, DAMAGE_TYPE_ACID), DAMAGE_TYPE_ACID);
            break;
        }
        case 2021: /* Ochre Jelly */
        {
            if (!GetHasFeat(FEAT_MIN_OOZY_TOUCH_OCHRE))
            {
                FloatingTextStringOnCreature("You do not posses Ochre Jelly Oozy Touch.", OBJECT_SELF);
                return;
            }
            effect damage = EffectDamage(d4() + level, DAMAGE_TYPE_ACID);
            object target = PRCGetSpellTargetObject();
            int DC = 15 + level;

            if (ooze_ranged_damage(damage, DAMAGE_TYPE_ACID))
            {
                if (!PRCMySavingThrow(SAVING_THROW_REFLEX, target, DC, SAVING_THROW_TYPE_ACID, OBJECT_SELF))
                {
                    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
                    effect stun = EffectLinkEffects(EffectStunned(), eMind);

                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, stun, target, RoundsToSeconds(1));
                }
            }
            break;
        }
        case 2022: /* Fungus */
        {
            if (!GetHasFeat(FEAT_MIN_OOZY_TOUCH_FUNGUS))
            {
                FloatingTextStringOnCreature("You do not posses Phosphorescent Fungus Oozy Touch.", OBJECT_SELF);
                return;
            }
            ooze_ranged_damage(EffectDamage(1, DAMAGE_TYPE_FIRE), DAMAGE_TYPE_FIRE);
            break;
        }
    }
}
