//::///////////////////////////////////////////////
//:: Name      Blade of Blood
//:: FileName  sp_blade_blood.nss
//:://////////////////////////////////////////////
/**@file Blade of Blood
Necromancy
Level: Assassin 1, blackguards 1, cleric 1,
       duskblade 1, sorcerer/wizard 1
Components: V,S
Casting Time: 1 swift action
Range: Touch
Target: Weapon touched
Duration: 1 round/level or until dicharged
Saving Throw: None
Spell Resistance: No

This spell infuses the weapon touched with baleful
energy.  The next time this weapon strikes a 
living creature, blade of blood discharges. The
spell deals an extra 1d6 points of damage against
the target of the attack.  You can voluntarily take
5 hit points of damage to empower the weapon to deal
an extra 2d6 points of damage(for a total of 3d6 
points of extra damage).
The weapon loses this property if its wielder drops 
it or otherwise loses contact with it.

**/
#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
        
        object oPC = OBJECT_SELF;
        object oTarget = IPGetTargetedOrEquippedMeleeWeapon();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nSpell = PRCGetSpellId();
        float fDur = RoundsToSeconds(nCasterLvl);       
        int nMetaMagic = PRCGetMetaMagicFeat();
        
        if(nMetaMagic & METAMAGIC_EXTEND)
        {
        	fDur += fDur;
        }
        
        if(nSpell == SPELL_BLADE_OF_BLOOD_EMP)
        {
        	SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, 5, DAMAGE_TYPE_MAGICAL), oPC);
        }
        
        //Set local ints
        SetLocalInt(oTarget, "PRC_BLADE_BLOOD_METAMAGIC", nMetaMagic);
        SetLocalInt(oTarget, "PRC_BLADE_BLOOD_SPELLID", nSpell);
                
        //Set up removal
        itemproperty ipHook = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
        
        IPSafeAddItemProperty(oTarget, ipHook, fDur);
        
        
        AddEventScript(oTarget, EVENT_ITEM_ONHIT, "prc_event_bladeb", FALSE, FALSE);
        if (DEBUG) DoDebug("Blade of Blood: oPC - "+GetName(oPC)+" oTarget - "+GetName(oTarget)+" nSpell - "+IntToString(nSpell)+" fDur - "+FloatToString(fDur)); 
        
        PRCSetSchool();
}