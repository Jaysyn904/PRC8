/*
03/03/21 by Stratovarius

Andras, the Gray Knight
  
A great warrior in life, Andras is an enigma as a vestige. He gives binders prowess in combat and skill in the saddle.

Vestige Level: 4th
Binding DC: 22
Special Requirement: No.

Influence: Andras’s influence causes you to become listless and emotionally remote. Because Andras wearies of combat quickly, you become exhausted after only 10 rounds of battle, and flee from the fight for 1d4 rounds. 

Granted Abilities: 
Andras lends you some of the skills he had in life, making you a strong combatant with or without a mount.

Sow Discord: Andras grants you the ability to sow discord among your enemies. As a standard action, you can force an enemy to attack a randomly determined ally within reach on his next action. 
Sow discord is a mind-affecting compulsion ability. Once you have used this ability, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder      = OBJECT_SELF;
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_ANDRAS)) return;
    object oTarget      = PRCGetSpellTargetObject();
    int nDC             = GetBinderDC(oBinder, VESTIGE_ANDRAS);
    
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oBinder, PRCGetSpellId()));
    if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS) && !PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
    {
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SOUND_SYMBOL_PAIN), oTarget);
        location lTarget = GetLocation(oTarget);
        int bBreak = FALSE;

        // Use the function to get the closest creature as a target
        object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oAreaTarget) && !bBreak)
        {
            if(oAreaTarget != oTarget && oAreaTarget != oBinder && GetIsFriend(oTarget, oAreaTarget))
            {
                //effect eNone;
                AssignCommand(oTarget, ClearAllActions());
                AssignCommand(oTarget, ActionAttack(oAreaTarget));
                DelayCommand(4.5, AssignCommand(oTarget, ClearAllActions()));
                bBreak = TRUE;
            }
        //Select the next target within the spell shape.
        oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }             
    }   
}