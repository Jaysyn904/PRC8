/*
Sudden Stalagmite

Conjuration (Creation) [Earth]
Level: Druid 4,
Components: V, S,
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Target: One creature
Duration: Instantaneous
Saving Throw: Reflex half
Spell Resistance: No

You point your finger upward and utter a curt shout. Immediately, a razor-sharp stalagmite bursts from the ground to impale your foe.

This spell creates a stalagmite about 1 foot wide at its base and up to 10 feet tall. The stalagmite grows from the ground under the target creature and shoots upward. 

The stalagmite deals 1d6 points of piercing damage per caster level (maximum 10d6). In addition, a target that fails to make a saving throw against this spell and takes damage from it is impaled on the stalagmite and 
cannot move from its current location. The victim can break free with a DC 25 Strength check, although doing this deals it 3d6 points of slashing damage.

A creature's damage reduction, if any, applies to the damage from this spell. The damage from sudden stalagmite is treated as piercing for the purpose of overcoming damage reduction.
*/

#include "prc_sp_func"
#include "prc_add_spell_dc"

void StalagmiteBreak(object oTarget, object oCaster, effect eHold)
{
    int nStrChk = d20() + GetAbilityModifier(ABILITY_STRENGTH, oTarget);
    if(nStrChk >= 25)
    {
        PRCRemoveSpellEffects(SPELL_SUDDEN_STALAGMITE, oCaster, oTarget);
        FloatingTextStringOnCreature("*Strength check successful!*", oTarget, FALSE);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, d6(3), DAMAGE_TYPE_PIERCING), oTarget);
    }
    else 
    {
        DelayCommand(6.0, StalagmiteBreak(oTarget, oCaster, eHold));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eHold), oTarget, 6.0);
    }    
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nSaveDC = PRCGetSaveDC(oTarget, oCaster);
    int nDice = nCasterLevel;
    // 10d6 Max
    if (nDice > 10) nDice = 10;
    int nDam = d6(nDice);
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_COM_CHUNK_STONE_SMALL);
    effect eHold = EffectLinkEffects(EffectParalyze(), EffectVisualEffect(VFX_DUR_STONEHOLD));
    
    int iAttackRoll = 0;

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Resolve metamagic
        if ((nMetaMagic & METAMAGIC_MAXIMIZE))
            nDam = 6 * nDice;
        else
            //Roll damage for each target
            nDam = d6(nDice);
        if ((nMetaMagic & METAMAGIC_EMPOWER))
            nDam += nDam / 2; 
		nDam += SpellDamagePerDice(oCaster, nDice);            
        int nCheck = nDam;    
		nDam = PRCGetReflexAdjustedDamage(nDam, oTarget, nSaveDC, SAVING_THROW_TYPE_SPELL);        
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_PIERCING), oTarget);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		CreateObject(OBJECT_TYPE_PLACEABLE, "x3_plc_boulder1", PRCGetSpellTargetLocation());
		if (nDam == nCheck) // If the damage is the same after the reflex save, they failed it.
		{
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eHold), oTarget, 6.0); //Extraordinary because it's just a piece of stone, not magical, at this point
			DelayCommand(6.0, StalagmiteBreak(oTarget, oCaster, eHold));
		}
    }
    PRCSetSchool();
}
