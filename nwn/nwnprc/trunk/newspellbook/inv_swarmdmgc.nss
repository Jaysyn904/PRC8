
#include "inv_inc_invfunc"

void main()
{
    SetAllAoEInts(GetLocalInt(GetAreaOfEffectCreator(), "SwarmDmgType"),OBJECT_SELF, GetSpellSaveDC());

    int nCasterLevel = GetInvokerLevel(GetAreaOfEffectCreator(), CLASS_TYPE_WARLOCK);
    
    object oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE , GetAreaOfEffectCreator())
            && !GetLocalInt(oTarget, "IgnoreSwarmDmg")
            && oTarget != GetAreaOfEffectCreator()
            && GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE)
        {
            //Fire cast spell at event for the target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(),
                GetLocalInt(GetAreaOfEffectCreator(), "SwarmDmgType")));
                
            effect eDamage = EffectDamage(d6(), DAMAGE_TYPE_PIERCING);
            if(GetLocalInt(GetAreaOfEffectCreator(), "SwarmDmgType") == INVOKE_TENACIOUS_PLAGUE)
                eDamage = EffectDamage(d6(2), DAMAGE_TYPE_PIERCING, DAMAGE_POWER_PLUS_ONE);
            if(GetLocalInt(GetAreaOfEffectCreator(), "SwarmDmgType") == INVOKE_DARK_DISCORPORATION)
                eDamage = EffectDamage(d6(4), DAMAGE_TYPE_PIERCING, DAMAGE_POWER_PLUS_FOUR);
            eDamage = EffectLinkEffects(eDamage, EffectVisualEffect(VFX_IMP_MAGBLUE));
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
            effect eAddlEffect;
            effect eVis;
            
            if(GetLocalInt(GetAreaOfEffectCreator(), "SwarmDmgType") == INVOKE_SUMMON_SWARM_BAT
               && !GetLocalInt(oTarget, "SwarmBleeding"))
            {
                ApplyOnHitAbilities(oTarget, GetAreaOfEffectCreator(), GetLocalObject(GetAreaOfEffectCreator(), "SwarmWeapon"));
                eVis = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                SetLocalInt(oTarget, "SwarmBleeding", TRUE);
            }
            
            if(GetLocalInt(GetAreaOfEffectCreator(), "SwarmDmgType") == INVOKE_SUMMON_SWARM_RAT
               && !GetHasSpellEffect(INVOKE_SUMMON_SWARM_RAT, oTarget))
            {
                eAddlEffect = EffectDisease(DISEASE_FILTH_FEVER);
                eVis = EffectVisualEffect(VFX_IMP_DISEASE_S);
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eAddlEffect, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
            
            int nNauseaDC = 12;
            if(GetLocalInt(GetAreaOfEffectCreator(), "SwarmDmgType") == INVOKE_TENACIOUS_PLAGUE)
                nNauseaDC += GetAbilityModifier(ABILITY_CHARISMA, GetAreaOfEffectCreator());
            //save or be nauseated
    		if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nNauseaDC, SAVING_THROW_TYPE_NONE))
    		{
    		    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNausea(oTarget, 6.0), oTarget, RoundsToSeconds(1));
    		}
        }
        oTarget = GetNextInPersistentObject();
    }


}
