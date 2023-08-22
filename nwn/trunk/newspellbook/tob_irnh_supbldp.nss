//////////////////////////////////////////////////
//  Supreme Blade Parry
//  tob_irnh_supbldp.nss
//  Tenjac   9/26/07
//////////////////////////////////////////////////
/** Supreme Blade Parry
Iron Heart(Stance)
Level: Warblade 8
Prerequisite: Three Iron Heart maneuvers
Initiation Action: 1 swift action
Range: Personal
Target: You
Duration: Stance

You drop into a relaxed pose, allowing your defenses to flow naturally and easily. Your blade
lashes out to absorb or deflect each attack you face, blunting the force of your enemies' blows.

As a student of the Iron Heart discipline, you learn that a simple flick of the wrist or turn
of the blade can transform a deadly strike into a wild miss. In battle, you enter a steady 
rhythm that makes you frustratingly difficult to fight. Your disrupt each attack with a
perfectly timed counter, leaving your foes' strikes weak and ineffectual.

While you are in this stance, you gain damage reduction 5/- against any opponent that does not
catch you flat-footed. To gain this benefit, you must be proficient with the weapon you carry. 
You gain this benefit while unarmed only if you have the Improved Unarmed Strike feat.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

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
                object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
                
                //Wielding a weapon or Improved Unarmed Strike - can't use a weapon without proficiency in NWN
                if(GetIsObjectValid(oWeap) || GetHasFeat(FEAT_IMPROVED_UNARMED_STRIKE, oInitiator))
                {
                        effect eLink = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 5, 0), EffectDamageResistance(DAMAGE_TYPE_PIERCING, 5, 0));
                               eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING, 5, 0));
                        if (GetLocalInt(oInitiator, "KamateStance"))  eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, GetLocalInt(oInitiator, "KamateStance")));       	       
                               eLink = ExtraordinaryEffect(eLink);
                               
                        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oInitiator);
                }
                
        }
}