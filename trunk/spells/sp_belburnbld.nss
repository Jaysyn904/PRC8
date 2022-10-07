#include "prc_inc_spells"
#include "prc_add_spell_dc"

//
// This function runs the burning blood effect for a round, then recursing itself one
// round later to do the effect again.  It relies on a dummy visual effect to act
// as the spell's timer, expiring itself when the effect expires.
//
void RunSpell(object oCaster, object oTarget, int nMetaMagic, int nSpellID,
     float fDuration,int nCasterLvl )
{
     // If our timer spell effect has worn off (or been dispelled) then we are
     // done, just exit.
    if (PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oCaster)) return;

     // If the target is dead then there is no point in going any further.
    if (GetIsDead(oTarget)) return;

     if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget,oCaster), SAVING_THROW_TYPE_SPELL))
     {
          // Give feedback that a save was made.
          SPApplyEffectToObject(DURATION_TYPE_INSTANT,
               EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE), oTarget);
     }
     else
     {
          // The bad thing happens, 1d8 acid and fire damage, and slowed for 1 round.
          int nDamage = PRCGetMetaMagicDamage(DAMAGE_TYPE_FIRE, 1, 8, 0, 0, nMetaMagic);
          nDamage += SpellDamagePerDice(oCaster, 1);
          effect eDamage = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_FIRE);
          eDamage = EffectLinkEffects(eDamage, EffectVisualEffect(VFX_IMP_FLAME_S));
          SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
          PRCBonusDamage(oTarget);

          nDamage = PRCGetMetaMagicDamage(DAMAGE_TYPE_ACID, 1, 8, 0, 0, nMetaMagic);
                // Acid Sheath adds +1 damage per die to acid descriptor spells
                if (GetHasDescriptor(nSpellID, DESCRIPTOR_ACID) && GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oCaster))
                	nDamage += 1; 
          nDamage += SpellDamagePerDice(oCaster, 1);      	
          eDamage = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_ACID);
          eDamage = EffectLinkEffects(eDamage, EffectVisualEffect(VFX_IMP_ACID_S));
          SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);

          eDamage = EffectSlow();
          SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage, oTarget, RoundsToSeconds(1),FALSE);
     }

     // Decrement our duration counter by a round and if we still have time left keep
     // going.
     fDuration -= RoundsToSeconds(1);
     if (fDuration > 0.0)
          DelayCommand(RoundsToSeconds(1), RunSpell(oCaster, oTarget, nMetaMagic, nSpellID, fDuration,nCasterLvl));
}


void main()
{
     // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
     if (!X2PreSpellCastCode()) return;

     PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

     object oTarget = PRCGetSpellTargetObject();
     int nRacial = MyPRCGetRacialType(oTarget);
     //Doesn't affect creatures of th construct, elemental, ooze, plant or undead types
     if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)
       && nRacial != RACIAL_TYPE_CONSTRUCT
       && nRacial != RACIAL_TYPE_ELEMENTAL
       && nRacial != RACIAL_TYPE_OOZE
       && nRacial != RACIAL_TYPE_PLANT
       && nRacial != RACIAL_TYPE_UNDEAD)
     {
          int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
             int nPenetr = nCasterLvl+SPGetPenetr();

          // Get the target and raise the spell cast event.
          PRCSignalSpellEvent(oTarget);

          if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr))
          {
               // Determine the spell's duration, taking metamagic feats into account.
               float fDuration = PRCGetMetaMagicDuration(RoundsToSeconds(nCasterLvl));

               // Apply a persistent vfx to the target.
               // RunSpell uses our persistant vfx to determine it's duration.
               SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                    EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), oTarget, fDuration,FALSE);

               // Stick OBJECT_SELF into a local because it's a function under the hood,
               // and we need a real object reference.
               object oCaster = OBJECT_SELF;
               DelayCommand(0.5, RunSpell(oCaster, oTarget, PRCGetMetaMagicFeat(), PRCGetSpellId(), fDuration,nCasterLvl));
          }
     }

     PRCSetSchool();
}
