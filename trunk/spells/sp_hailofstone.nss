#include "prc_inc_sp_tch"

void main()
{
     // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
     if (!X2PreSpellCastCode()) return;
    
     PRCSetSchool(SPELL_SCHOOL_CONJURATION);
     
     // Get the spell target location as opposed to the spell target.
     location lTarget = PRCGetSpellTargetLocation();

     // Apply area vfx.
     ApplyEffectAtLocation(DURATION_TYPE_INSTANT, 
          EffectVisualEffect(VFX_COM_CHUNK_STONE_SMALL), lTarget);
     ApplyEffectAtLocation(DURATION_TYPE_INSTANT, 
          EffectVisualEffect(356 /*VFX_FNF_SCREEN_SHAKE2*/), lTarget);
     
     float fDelay;
     
     // Determine damage dice.
     int nCasterLvl = PRCGetCasterLevel();
     int nDice = nCasterLvl;
     if (nDice > 5) nDice = 5;
     int nPenetr = nCasterLvl + SPGetPenetr();

     // Declare the spell shape, size and the location.  Capture the first target object in the shape.
     // Cycle through the targets within the spell shape until an invalid object is captured.
     int nTargets = 0;
     object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, FALSE, 
          OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
     while (GetIsObjectValid(oTarget))
     {
          fDelay = PRCGetSpellEffectDelay(lTarget, oTarget);
          if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
          {
               // Fire cast spell at event for the specified target
               PRCSignalSpellEvent(oTarget);

               if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr))
               {
                    // Make touch attack, saving result for possible critical
                    int nTouchAttack = PRCDoRangedTouchAttack(oTarget);;
                    if (nTouchAttack > 0)
                    {
                         // Roll the damage of (1d6+1) / level, doing double damage on a crit.
                         int nDamage = PRCGetMetaMagicDamage(DAMAGE_TYPE_BLUDGEONING, 
                              1 == nTouchAttack ? nDice : (nDice * 2), 4);
                         
                         nDamage += SpellDamagePerDice(OBJECT_SELF, nDice);

                         // Apply the damage and the damage visible effect to the target.                
                         SPApplyEffectToObject(DURATION_TYPE_INSTANT, 
                         PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_BLUDGEONING), oTarget);
                         PRCBonusDamage(oTarget);
//TODO: need VFX
//                       SPApplyEffectToObject(DURATION_TYPE_INSTANT, 
//                            EffectVisualEffect(VFX_IMP_FROST_S), oTarget);
                    }
               }
          }
          
          oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, FALSE, 
               OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
     }
     
     PRCSetSchool();
}
