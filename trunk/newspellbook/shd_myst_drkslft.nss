/*
18/02/19 by Stratovarius

Dark Soul

Master, Heart and Soul 
Level/School: 7th/Enchantment (Compulsion) [Mind Affecting]
Range: Personal 
Target: You 
Duration: 1 round/level 
Saving Throw: Will negates; see text 
Spell Resistance: Yes; see text

You open the subject’s mind to the Plane of Shadow, altering its personality.

You turn the dark energies from the Plane of Shadow upon another creature, compelling it to act in ways that it normally would not. 
While this effect is active, you can use a standard action to focus the shadow energies on one living creature within 30 feet that you select. 
The creature must succeed on a Will saving throw (DC 17 + your Cha modifier) or immediately make a melee attack against one target within its reach.
*/

#include "shd_inc_shdfunc"
#include "prc_inc_combat"

void main()
{
    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    int nPen = ShadowSRPen(oShadow, GetShadowcasterLevel(oShadow));
    
    if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oShadow))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oShadow, PRCGetSpellId()));
        if (!PRCDoResistSpell(oShadow, oTarget, nPen) && !/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetShadowcasterDC(oShadow), SAVING_THROW_TYPE_MIND_SPELLS))
        {
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SOUND_SYMBOL_PAIN), oTarget);
            location lTarget = GetLocation(oTarget);
            int bBreak = FALSE;

            // Use the function to get the closest creature as a target
            object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oAreaTarget) && !bBreak)
            {
                if(oAreaTarget != oTarget && oAreaTarget != oShadow && GetIsInMeleeRange(oTarget, oAreaTarget))
                {
                    //effect eNone;
                    AssignCommand(oTarget, ClearAllActions());
                    AssignCommand(oTarget, ActionAttack(oAreaTarget));
                    //AssignCommand(oTarget, PerformAttack(oAreaTarget, oTarget, eNone));
                    //if (DEBUG) DoDebug("shd_myst_drkslft: Successful attack against "+GetName(oAreaTarget));
                    //FloatingTextStringOnCreature("shd_myst_drkslft: Successful attack against "+GetName(oAreaTarget), oShadow, FALSE);
                    DelayCommand(4.5, AssignCommand(oTarget, ClearAllActions()));
                    bBreak = TRUE;
                }
            //Select the next target within the spell shape.
            oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            }             

        }
    }    
}