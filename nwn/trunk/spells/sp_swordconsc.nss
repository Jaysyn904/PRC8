/*
   ----------------
   Sword of Conscience

   sp_swordconsc
   ----------------

   25/2/05 by Stratovarius

Enchantment
Level: Clr 4, Rgr 4
Components: V, DF
Casting Time: 1 action
Range: Close.
Target: One Evil Creature.
Duration: Instantaneous
Saving Throw: Will Negates
Spell Resistance: Yes

The target creature takes Wisdom and Charisma damage equal to its Evil Power rating.

Creature/Object     Evil Power
Evil creature       HD / 5
Undead creature     HD / 2
Evil elemental      HD / 2
Evil outsider       HD
Cleric of an evil deity     Caster Level   
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
    
            int nRawStrength = 0;
	if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
	{
            int nRace = MyPRCGetRacialType(oTarget);
            if(nRace == RACIAL_TYPE_OUTSIDER)
                nRawStrength = GetHitDice(oTarget);
            else if(nRace == RACIAL_TYPE_UNDEAD || nRace == RACIAL_TYPE_ELEMENTAL)
                nRawStrength = GetHitDice(oTarget)/2;
            else
                nRawStrength = GetHitDice(oTarget)/5;
            if(GetPrCAdjustedCasterLevel(CLASS_TYPE_CLERIC, oTarget) > nRawStrength)
                nRawStrength = GetPrCAdjustedCasterLevel(CLASS_TYPE_CLERIC, oTarget);    
        }
        else
     {
	// End the spell, it only works on evils
	FloatingTextStringOnCreature("The Target is not evil, spell failed", oCaster, FALSE);
	return;
     }

    int nDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
    int nCaster = PRCGetCasterLevel(OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_IMP_NEGBLAST_ENERGY);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
    if (!PRCDoResistSpell(OBJECT_SELF, oTarget, nCaster+SPGetPenetr()))
    {
    	if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
        {
        	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyAbilityDamage(oTarget, ABILITY_WISDOM,       nRawStrength, DURATION_TYPE_PERMANENT, TRUE);
    		ApplyAbilityDamage(oTarget, ABILITY_CHARISMA,     nRawStrength, DURATION_TYPE_PERMANENT, TRUE);
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}