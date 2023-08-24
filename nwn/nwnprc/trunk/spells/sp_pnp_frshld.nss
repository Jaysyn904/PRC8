//::///////////////////////////////////////////////
//:: Name      
//:: FileName  sp_.nss
//:://////////////////////////////////////////////
/**@file Fire Shield
Evocation [Fire or Cold]
Level: Fire 5, Sor/Wiz 4, Sun 4 
Components: V, S, M/DF 
Casting Time: 1 standard action 
Range: Personal 
Target: You 
Duration: 1 round/level (D)

This spell wreathes you in flame and causes damage
to each creature that attacks you in melee. The 
flames also protect you from either cold-based or 
fire-based attacks (your choice).

Any creature striking you with its body or a 
handheld weapon deals normal damage, but at the 
same time the attacker takes 1d6 points of damage
+1 point per caster level (maximum +15). This
damage is either cold damage (if the shield 
protects against fire-based attacks) or fire 
damage (if the shield protects against cold-based
attacks). If the attacker has spell resistance, 
it applies to this effect. Creatures wielding 
weapons with exceptional reach are not subject to
this damage if they attack you.

When casting this spell, you appear to immolate 
yourself, but the flames are thin and wispy, 
giving off light equal to only half the 
illumination of a normal torch (10 feet). The 
special powers of each version are as follows.

Warm Shield: The flames are warm to the touch. 
You take only half damage from cold-based attacks.
If such an attack allows a Reflex save for half 
damage, you take no damage on a successful save.

Chill Shield: The flames are cool to the touch. 
You take only half damage from fire-based attacks.
If such an attack allows a Reflex save for half 
damage, you take no damage on a successful save.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_EVOCATION);
        
        object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nSpell = GetSpellId();
        int nMetaMagic = PRCGetMetaMagicFeat();
        int nDam = min(15,nCasterLvl);
        float fDur = RoundsToSeconds(nCasterLvl);
        effect eShield;
        effect eVis;
        effect eReduce;

        //Extend
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;

        if(nSpell == SPELL_PNP_FIRE_SHIELD_RED)
        {
                eVis = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
                eShield = EffectDamageShield(nDam, DAMAGE_BONUS_1d6, ChangedElementalDamage(oPC, DAMAGE_TYPE_FIRE));
                eReduce = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 50);
                
        }
        
        else if(nSpell == SPELL_PNP_FIRE_SHIELD_BLUE)
        {
                eVis = EffectVisualEffect(VFX_DUR_CHILL_SHIELD);
                eShield = EffectDamageShield(nDam, DAMAGE_BONUS_1d6, ChangedElementalDamage(oPC, DAMAGE_TYPE_COLD));
                eReduce = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50);
        }
                
        else
        {
                PRCSetSchool();
                return;
        }
        
        effect eLink = EffectLinkEffects(eShield, eVis);
               eLink = EffectLinkEffects(eLink, eReduce);
        
        //apply
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur, TRUE, nSpell, nCasterLvl);
        
        PRCSetSchool();
}