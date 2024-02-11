//:://////////////////////////////////////////////
//:: Name     Conduit of Life
//:: FileName   sp_conduitlife.nss
//:://////////////////////////////////////////////
/** @file Conjuration (Healing)
Level: Cleric 2, Paladin 2,
Components: V, S,
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 10 minutes/level or until discharged

A small kernel of positive energy grows within your 
heart, warming your whole body.

The next time you use a class feature or racial ability
to channel positive energy (such as turn undead or lay on hands),
you also heal a number of points of damage to yourself equal to 
2d10+1/caster level (maximum 10).

If you are already subject to an ongoing healing effect 
(such as vigor), or if you receive a cure spell while conduit 
of life is still in effect, this spell instead heals a number of 
points of damage equal to 3d8+1/caster level and it is discharged.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 8/5/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_CONJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  nCasterLvl * 600.0f;
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
                
        //Apply VFX
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AURA_PULSE_YELLOW_WHITE), oPC, fDur);
        
        //Ongoing healing triggering
        effect eTest = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eTest))
        {
        	if (eTest == EffectRegenerate())
        	{        		
        		SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectHeal(d8(3) + nCasterLvl), oPC);
        		PRCRemoveSpellEffects(SPELL_CONDUIT_OF_LIFE, oPC, oPC);
        		break;
        	}
        	eTest = GetNextEffect(oTarget);
        }  
        PRCSetSchool();
}