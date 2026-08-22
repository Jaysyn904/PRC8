#include "prc_inc_assoc"
#include "prc_inc_spells"

//;;
//;; prc_ai_xag_spawn.nss
//;;

void main()
{
    object oComp = OBJECT_SELF;

    ExecuteScript("nw_ch_ac9", oComp);
    ExecuteScript("prc_npc_spawn", oComp);


    if (!GetIsObjectValid(oComp))
        return; //No point working 
    
    // Immune to non-magical weapons, ignore physical objects
    effect eIncorporeal = EffectLinkEffects(EffectDamageReduction(100, DAMAGE_POWER_PLUS_ONE, 0), EffectCutsceneGhost());
           eIncorporeal = EffectLinkEffects(eIncorporeal, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 50)); // 50% chance of magical weapons not working. Done as 50% Damage Immunity
           eIncorporeal = EffectLinkEffects(eIncorporeal, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 50));
           eIncorporeal = EffectLinkEffects(eIncorporeal, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 50));
           eIncorporeal = EffectLinkEffects(eIncorporeal, EffectMissChance(50, MISS_CHANCE_TYPE_VS_MELEE)); // 50% melee miss chance to hit non-incorporeal targets. That's going to be everything
           eIncorporeal = EffectLinkEffects(eIncorporeal, EffectSkillIncrease(SKILL_MOVE_SILENTLY, 99)); // Cannot be heard
           eIncorporeal = EffectLinkEffects(eIncorporeal, EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK));
		   eIncorporeal = EffectLinkEffects(eIncorporeal, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT)); 
		   eIncorporeal = EffectLinkEffects(eIncorporeal, EffectConcealment(50, MISS_CHANCE_TYPE_NORMAL));
    
    SetLocalInt(oComp, "Incorporeal", TRUE);
    
	eIncorporeal = ExtraordinaryEffect(eIncorporeal);
	eIncorporeal = UnyieldingEffect(eIncorporeal); 	
        
    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eIncorporeal, oComp);

}