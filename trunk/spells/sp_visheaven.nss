/*
   ----------------
   Vision of Heaven

   sp_visheaven
   ----------------

   25/2/05 by Stratovarius

Enchantment
Level: Clr 1
Components: V
Casting Time: 1 action
Range: Close.
Target: One Evil Creature.
Duration: Instantaneous
Saving Throw: Will Negates
Spell Resistance: Yes

The target creature is dazed for one round.
*/

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDaze = EffectDazed();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eMind, eDaze);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDuration = 1;
    //check meta magic for extend
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = 2;
    }

    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nPenetr = CasterLvl + SPGetPenetr();

    // Evil only
    if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
        {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
               //Make SR check
               if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr))
               {
                    //Make Will Save to negate effect
                    if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                        //Apply VFX Impact and daze effect
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    }
                }
        }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name

}
