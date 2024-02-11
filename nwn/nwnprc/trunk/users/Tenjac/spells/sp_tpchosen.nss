//:://////////////////////////////////////////////
//:: Name     True Prayer of the Chosen
//:: FileName   sp_tpchosen.nss
//:://////////////////////////////////////////////
/** @file Transmutation
Level: Paladin 3, Cleric 4,
Components: V, S, DF, TN,
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 round/level

Raising your eyes to the skies, you speak your own
truename to your patron deity, asking for protection
as your mission takes you into harm's way.
A golden coruscation surrounds you.

True prayer of the chosen grants you a +3 insight
bonus on saving throws and to Armor Class.
For the duration of the spell, you are protected by 
the power of your deity, who gives you divine insight
into the threats you're about to face.

Truename Component: When you cast this spell, you must
correctly speak your personal truename.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 8/3/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"
#include "true_inc_trufunc"
#include "true_utterhook"

void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  RoundsToSeconds(nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        
        struct utterance utter = EvaluateUtterance(oPC, oPC, METAUTTERANCE_NONE/* Use METAUTTERANCE_NONE if it has no Metautterance usable*/, LEXICON_EVOLVING_MIND /* Uses the same DC formula*/);
	
	if(utter.bCanUtter)
	{
		effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_AURA_ORANGE), EffectSavingThrowIncrease(SAVING_THROW_ALL, 3));
		eLink = EffectLinkEffects(eLink, EffectACIncrease(3));
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
        }
        PRCSetSchool();
}