//////////////////////////////////////////////////
//   Crushing Vise
//   tob_stdr_crshvis.nss 
//   Tenjac   9/11/07
//////////////////////////////////////////////////
/** @file Crushing Vise
Stone Dragon (Strike)
Level: Crusader 6, swordsage 6, warblade 6
Initiation Action: 1 standard action
Range: Melee attack
Target: One creature
Duration: 1 round

The overwhelming power behind your attack leaves your opponent unable to move.
The punishing strike forces it to waste a few moments shrugging off the effects of your attack.

By making a powerful, focused blow, you leave your opponent unable to move. The crushing
weight of your attack forces it to waste a precious moment regaining its footing.

As part of this maneuver, you make a melee attack. This attack deals an extra 4d6 points
of damage. Your attack also drops the  target's speed to 0 feet (for all movement types) for 
1 round. It can act normally in all other ways.

*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
                effect eVis;
                object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
                PerformAttack(oTarget, oInitiator, eVis, 0.0, 0, d6(4), GetWeaponDamageType(oWeap), "Crushing Vise Hit", "Crushing Vise  Miss");
                
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
                {
                        effect eImmob = EffectEntangle();
                        eImmob = ExtraordinaryEffect(eImmob);
                }
}

void main()
{
        if (!PreManeuverCastCode())
        {
                // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
                return;
        }
        
        // End of Spell Cast Hook
        
        object oInitiator    = OBJECT_SELF;
        object oTarget       = PRCGetSpellTargetObject();
        struct maneuver move = EvaluateManeuver(oInitiator, oTarget);
                
        if(move.bCanManeuver)
        {
        	DelayCommand(0.0, TOBAttack(oTarget, oInitiator));
        }
}
                        