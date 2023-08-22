//::///////////////////////////////////////////////
//:: Name      Arrow Storm
//:: FileName  sp_arrow_storm.nss
//:://////////////////////////////////////////////
/**@file Arrow Storm
Transmutation
Level: Ranger 3
Components: V
Casting Time: 1 swift action
Range: Personal
Target: You
Duration: 1 round

After casting arrow storm, you use a full-round 
action to make one ranged attack with a bow with 
which you are proficient against every foe within 
range. You can attack a maximum number of individual
targets equal to your character level.

Author:    Tenjac
Created:   8/8/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "prc_add_spell_dc"

void main()
{
        object oPC = OBJECT_SELF;
        object oTarget;
        int nLevel = GetHitDice(oPC);
        effect eArrow = EffectVisualEffect(357);
        int i;
                
        for (i = 1; i <= nLevel; i++)
        {
                oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, i);
                if (GetIsObjectValid(oTarget))
                {
                        float fDist = GetDistanceBetween(oPC, oTarget);
                        float fDelay = fDist/(3.0 * log(fDist) + 2.0);
                        
                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(oPC, SPELL_ARROW_STORM));
                        
                        DelayCommand(fDelay, PerformAttack(oTarget, oPC, eArrow));
                }
        }
}