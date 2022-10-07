//:://////////////////////////////////////////////
//:: Name     Favor of the Martyr
//:: FileName   sp_favormartyr.nss
//:://////////////////////////////////////////////
/** @file 
Necromancy
Level: Paladin 4,
Components: V, S,
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Target: One willing creature
Duration: 1 minute/level
Saving Throw: None
Spell Resistance: Yes (harmless)

Calling upon the saints of your order, you imbue the person 
in need with the power to resist the dire forces arrayed 
against you.

The subject gains immunity to nonlethal damage, charm and 
compulsion effects, and attacks that function specifically 
by causing pain, such as the wrack spell (see page 243). it
is further immune to effects that would cause it to be dazed,
exhausted, fatigued, nauseated, sickened, staggered, or stunned.
The subject remains conscious at -1 to -9 hit points and can 
take a single action each round while in that state, and does
not lose hit point for acting. If any of the above conditions 
were in effect on the subject at the time of casting, they are 
suspended for the spell's duration. (Thus, an unconscious 
subject becomes conscious and functional.)

When the spell ends, any effects suspended by the spell that
have not expired in the interim (such as the fatigued condition,
which normally requires 8 hours of rest to recover from) return.
Effects that expired during the duration of this spell do not 
resume when it ends.

In addition to these effects, the subject gains the benefit of
the Endurance feat for the duration of the spell.

*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 6/29/22	
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  60.0f * (nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        object oTarget = PRCGetSpellTargetObject();
        
        //Immunities
        effect eLink = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_CHARM), EffectImmunity(IMMUNITY_TYPE_DAZED));
        eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_STUN));
                        
        //+4 Save vs Death
        eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_DEATH));
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
       
        PRCSetSchool();
}