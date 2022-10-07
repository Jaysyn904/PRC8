/*
   ----------------
   Insanity

   sp_insanity
   ----------------

   25/2/05 by Stratovarius

   Class: Sorc/wiz 7
   Power Level: 7
   Range: Medium
   Target: One Humanoid
   Duration: Permanent
   Saving Throw: Will negates
   Spell Resistance: Yes

   Creatures affected by this power are permanently confused, as the spell.

    Modifed from psionic version by Primogenitor
*/

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);

/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    int nDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
    int nCaster = PRCGetCasterLevel(OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eConfuse = PRCEffectConfused();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eMind, eConfuse);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = SupernaturalEffect(eLink);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INSANITY));
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        if (!PRCDoResistSpell(OBJECT_SELF, oTarget, nCaster+SPGetPenetr()))
        {
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0, TRUE,-1,nCaster);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}