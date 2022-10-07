//:Ghost-Faced Killer Frightful Attack
//
//Power Attack must be active.
//The attack must be a Sudden Strike (Sneak Attack.)
//The victim makes a Will Save (DC 10 + GFK class level + GFK Cha modifier.)
//If the victim fails the save, the victim dies of fright.
//If the victim succeeds, the victim becomes shaken for 1 round per GFK class
//level.
//Victims immune to mind-affecting effects, immune to fear, or with more Hit
//Dice than the GFK's character level are immune to this frightful attack.
//All onlookers in a 30 foot radius who are not the victim, the GFK, or allies
//of the GFK must make a will save (DC 10 + GFK class level + GFK Cha modifier
//+ damage modifier of power attack.)
//If the onlooker succeeds the will save, no effect is applied.
//If the onlooker has less Hit Dice than the GFK class level + GFK Cha modifier,
//and fails the save, the onlooker becomes panicked for 1 round per GFK class
//level.
//If the onlooker has more Hit Dice than the GFK class level + GFK Cha modifier,
//and fails the save, the onlooker becomes shaken for 1 round per GFK class
//level.

#include "prc_inc_combat"

void DoFrightfulAttack(object oPC, object oTarget);

void DelayFrightfulAttackCheck(object oPC, object oTarget) {
   if(GetIsDead(oTarget)) {
      float fGFKSize = StringToFloat(Get2DACache("appearance","PREFATCKDIST",GetAppearanceType(oPC)));
      object oNewTarget;
      oNewTarget = MyFirstObjectInShape(SHAPE_SPHERE, fGFKSize, GetLocation(oPC), TRUE);
      if ( GetIsObjectValid(oNewTarget) ) {
         if ( oNewTarget == oPC ) {
            oNewTarget = MyNextObjectInShape(SHAPE_SPHERE, fGFKSize, GetLocation(oPC), TRUE);
         }
      }
      if ( GetIsObjectValid(oNewTarget) ) {
         if ( oNewTarget != oPC ) {
            if ( GetCanSneakAttack(oNewTarget,oPC)) {
               DoFrightfulAttack(oPC, oNewTarget);
            } else {
               effect eEffect;
               PerformAttack(oNewTarget,oPC,eEffect);
            }
         }
      }
   }    
}

void DoFrightfulAttack(object oPC, object oTarget) {

   //Does the GFK have frightful cleave yet?
   int iGFKFrightfulCleave = GetHasFeat( FEAT_FRIGHTFUL_CLEAVE, oPC );

   //What is the GFK class level?
   int iGFKClassLevel = GetLevelByClass(CLASS_TYPE_GHOST_FACED_KILLER, oPC);

   //What is the GFK character level?
   int iGFKCharacterLevel = GetHitDice(oPC);

   //What is the Cha modifier?
   int iGFKCharModifier = GetAbilityModifier(ABILITY_CHARISMA, oPC);

   //What is the Hit Dice of the target?
   int iTargetHD = GetHitDice(oTarget);

   //Can the GFK use a Sudden Strike? (sneak attack)
   int iSuddenStrike = GetCanSneakAttack(oTarget, oPC);
   if ( ! iSuddenStrike ) {
      //Replace all of these with FloatingTextStrRefOnCreature() later.
      FloatingTextStrRefOnCreature(16832361, oPC, FALSE);
      //FloatingTextStringOnCreature("Frightful Attack must be a Sudden Strike (Sneak Attack).", oPC, FALSE);
      IncrementRemainingFeatUses(oPC, FEAT_FRIGHTFUL_ATTACK);
   }

   //What level of Power Attack did the GFK use while making this attack?
   //Not sure if this is correct.
   int iDamageBonus = GetLocalInt(oPC, "PRC_PowerAttack_Level");
   if ( GetActionMode(oPC, ACTION_MODE_POWER_ATTACK) ) {
      iDamageBonus = 5;
   }
   if ( GetActionMode(oPC, ACTION_MODE_IMPROVED_POWER_ATTACK) ) {
      iDamageBonus = 10;
   }
   if ( iDamageBonus <= 0 ) {
      //Replace all of these with FloatingTextStrRefOnCreature() later.
      FloatingTextStrRefOnCreature(16832362, oPC, FALSE);
      //FloatingTextStringOnCreature("Power Attack must be active to use Frightful Attack.", oPC, FALSE);
      IncrementRemainingFeatUses(oPC, FEAT_FRIGHTFUL_ATTACK);
   }


   //Is the target immune to mind-affecting effects?
   int iTargetIMA = GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_INVALID);

   //Is the target immune to fear?
   int iTargetIF = GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR, OBJECT_INVALID);

   if ( iSuddenStrike && iDamageBonus > 0 ) {
      effect eEffect;
      if ( ! iTargetIF && ! iTargetIMA ) {
         if ( iTargetHD < iGFKCharacterLevel ) {
            //We use PerformAttack from prc_inc_combat to make this easier
            //eShaken = EffectShaken();
            //eDeath = EffectDeath(TRUE,FALSE);
            int iSave = PRCMySavingThrow( SAVING_THROW_WILL, oTarget, 10 + iGFKClassLevel + iGFKCharModifier, SAVING_THROW_TYPE_FEAR);
            if ( iSave < 2 ) {
               if ( iSave == 0 ) {
                  eEffect = EffectDeath(TRUE,FALSE);
               } 
               else if (GetHasMettle(oTarget, SAVING_THROW_WILL)) // Ignores partial effects
               {
                  eEffect = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);
               }
               else
               {
                  eEffect = EffectShaken();
               }
               PerformAttack(oTarget, oPC, eEffect, IntToFloat(iGFKClassLevel));
            } else {
               //Should NEVER enter this code, but here for sanity
               PerformAttack(oTarget, oPC, eEffect);
               //Replace all of these with FloatingTextStrRefOnCreature() later.
               FloatingTextStrRefOnCreature(16832363, oPC, FALSE);
               //FloatingTextStringOnCreature("Failed Frightful Attack: Target is immune to fear.", oPC, FALSE);
            }
         } else {
            PerformAttack(oTarget, oPC, eEffect);
            //Replace all of these with FloatingTextStrRefOnCreature() later.
            FloatingTextStrRefOnCreature(16832364, oPC, FALSE);
            //FloatingTextStringOnCreature("Failed Frightful Attack: Target has too many Hit Dice.", oPC, FALSE);
         }
      } else {
         PerformAttack(oTarget, oPC, eEffect);
         //Replace all of these with FloatingTextStrRefOnCreature() later.
     //16832365
         //FloatingTextStringOnCreature("Failed Frightful Attack: Target must not be immune to sneak attacks, mind affecting effects, or fear.", oPC, FALSE);
         FloatingTextStrRefOnCreature(16832365, oPC, FALSE);
      }
      //Frighten the onlookers.

      //int nDamage;
      effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
      effect eFearE = EffectFrightened();
      effect eShakenE = EffectShaken();
      effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
      effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
      effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
      float fDelay;
      float fDuration = RoundsToSeconds( iGFKClassLevel );
      //Link the fear and mind effects
      effect eLink1 = EffectLinkEffects(eFearE, eMind);
      effect eFear = EffectLinkEffects(eLink1, eDur);
      effect eLink2 = EffectLinkEffects(eShakenE, eMind);
      effect eShaken = EffectLinkEffects(eLink2, eDur);
       
      //Apply Impact
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
      object oCurrentTarget;
      //Get first target in the spell cone
      oCurrentTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation(), TRUE);
      while(GetIsObjectValid(oCurrentTarget)) {
         fDelay = PRCGetRandomDelay();
         //The victim (oTarget) the Ghost-Faced Killer (oPC), and allies of the Ghost-Faced Killer are unaffected.
         if((oCurrentTarget != oTarget) && (!GetIsFriend(oCurrentTarget, oPC)) && (oCurrentTarget != oPC)) {
            //Make a will save
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oCurrentTarget, 10 + iGFKClassLevel + iGFKCharModifier + iDamageBonus, SAVING_THROW_TYPE_FEAR, OBJECT_SELF, fDelay)) {
               //Apply the linked effects and the VFX impact
               int iCurrentHD = GetHitDice( oCurrentTarget );
               if ( iCurrentHD < ( iGFKClassLevel + iGFKCharModifier ) ) {
                  DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oCurrentTarget, fDuration, TRUE, -1, -1));
               } else {
                  DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShaken, oCurrentTarget, fDuration, TRUE, -1, -1));
               }
            }
         }
         //Get next target in the spell cone
         oCurrentTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation(), TRUE);
      }
   }
   
   //delay this to see if we need to cleave
   if(iGFKFrightfulCleave) {
      DelayCommand(0.01, DelayFrightfulAttackCheck(oPC, oTarget));
   }
}

void main() {
   object oPC = OBJECT_SELF;
   object oTarget = PRCGetSpellTargetObject();
   //Is the player trying to Frightful Attack himself?
   if(oPC == oTarget) {
      IncrementRemainingFeatUses(oPC, FEAT_FRIGHTFUL_ATTACK);
      return;
   }
   DoFrightfulAttack(oPC, oTarget);
}

