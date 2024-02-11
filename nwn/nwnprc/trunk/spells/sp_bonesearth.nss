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

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    int nMetaMagic = PRCGetMetaMagicFeat();
	float fDuration = RoundsToSeconds(nCasterLevel/2);    
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;    

	SetLocalInt(oCaster, "BonesEarth", nMetaMagic);
	DelayCommand(fDuration, DeleteLocalInt(oCaster, "BonesEarth"));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectVisualEffect(VFX_DUR_STONEHOLD)), oCaster, fDuration);
    IPSafeAddItemProperty(GetPCSkin(oCaster), ItemPropertyBonusFeat(IP_CONST_FEAT_BONES_EARTH), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    PRCSetSchool();
}
