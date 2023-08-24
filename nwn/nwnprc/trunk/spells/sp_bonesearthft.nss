/*
Bones of the Earth

Conjuration (Creation) [Earth]
Level: Druid 6
Components: V, S
Casting Time: 1 standard action
Range: 60 ft.
Effect: One 5-ft.-diameter pillar of stone per round
Duration: 1 round/2 levels
Saving Throw: Reflex negates
Spell Resistance: No

You point your finger upward and utter a curt shout. Immediately, a pillar of rock explodes upwards from the ground.

Each round as a standard action, you conjure a pillar of rock anywhere within range. A creature standing atop the pillar will take 4d6 damage, Reflex negates, and will be knocked prone for one round if they fail their save.

To create a pillar, you must use the feat called Bones of the Earth on your character radial.
*/

#include "prc_sp_func"
#include "prc_add_spell_dc"

void main()
{
    object oCaster = OBJECT_SELF;
    PRCSetSchool(GetSpellSchool(SPELL_BONES_OF_THE_EARTH));
    object oTarget = PRCGetSpellTargetObject();
    int nMetaMagic = GetLocalInt(oCaster, "BonesEarth");
    int nSaveDC = PRCGetSaveDC(oTarget, oCaster, SPELL_BONES_OF_THE_EARTH);

    int nDam = d6(4);
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_COM_CHUNK_STONE_SMALL);
    effect eHold = EffectLinkEffects(EffectKnockdown(), EffectVisualEffect(VFX_DUR_STONEHOLD));
    
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Resolve metamagic
        if ((nMetaMagic & METAMAGIC_MAXIMIZE))
            nDam = 24;
        if ((nMetaMagic & METAMAGIC_EMPOWER))
            nDam += nDam / 2; 
		if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nSaveDC, SAVING_THROW_TYPE_SPELL))
		{
			nDam += SpellDamagePerDice(oCaster, 4);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_BLUDGEONING), oTarget);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eHold), oTarget, 6.0);
		}	
		CreateObject(OBJECT_TYPE_PLACEABLE, "x3_plc_boulder1", PRCGetSpellTargetLocation());
    }
    PRCSetSchool();
}
