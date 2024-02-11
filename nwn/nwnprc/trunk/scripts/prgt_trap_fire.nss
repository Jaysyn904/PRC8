#include "prc_alterations"
#include "prgt_inc"
#include "prc_inc_racial"

void main()
{
//SendMessageToPC(GetFirstPC(), "Firing Trap");
    object oTarget = GetLocalObject(OBJECT_SELF, "Target");
    if(!GetIsObjectValid(oTarget))
        oTarget = GetLastUsedBy();
    if(!GetIsObjectValid(oTarget))
        oTarget = GetEnteringObject();
    struct trap tTrap = GetLocalTrap(OBJECT_SELF, "TrapSettings");
    //if no trap exists, create a random one
    struct trap tInvalid;
    if(tTrap == tInvalid)
        tTrap = CreateRandomTrap(GetECL(oTarget));
    //for traps that duplicate spells    
    if(tTrap.nSpellID)
    {
        ActionCastSpell(tTrap.nSpellID, 
            tTrap.nSpellLevel, 
            0, 
            tTrap.nSpellDC, 
            tTrap.nSpellMetamagic, 
            CLASS_TYPE_INVALID, 
            FALSE, 
            FALSE, 
            oTarget);
    }
    else
    {
        float fRadius = IntToFloat(tTrap.nRadius);

        effect eTrapVFX;
        if(tTrap.nTrapVFX)
            eTrapVFX = EffectVisualEffect(tTrap.nTrapVFX);
        if(GetIsEffectValid(eTrapVFX))
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eTrapVFX, GetLocation(OBJECT_SELF));

        effect eTargetVFX;
        if(tTrap.nTargetVFX)
            eTargetVFX = EffectVisualEffect(tTrap.nTargetVFX);

        effect eBeamVFX;
        if(tTrap.nBeamVFX)
            eBeamVFX = EffectBeam(tTrap.nBeamVFX, OBJECT_SELF, BODY_NODE_CHEST);

        int i = 1;
        object oVictim = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF), TRUE);
        if(fRadius == 0.0)
            oVictim = oTarget;

        while(GetIsObjectValid(oVictim))
        {

            int nDamage;
            int nDiceCount;
            while(nDiceCount < tTrap.nDamageDice)
            {
                nDamage += Random(tTrap.nDamageSize)+1;
                nDiceCount++;
            }
            nDamage+= tTrap.nDamageBonus;
            
            effect eDamage;
            //handle negative vs undead and positive vs non-undead
            if((tTrap.nDamageType == DAMAGE_TYPE_NEGATIVE
                    && (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
                    || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD)
                    || GetLocalInt(oTarget, "AcererakHealing"))
                || (tTrap.nDamageType == DAMAGE_TYPE_POSITIVE
                    && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD
                    && !(GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD))))
            {
                eDamage = EffectHeal(nDamage);
            }
            else
            {
                if(tTrap.nAllowReflexSave)
                    nDamage = PRCGetReflexAdjustedDamage(nDamage, oVictim, tTrap.nSaveDC, SAVING_THROW_TYPE_TRAP);
                if(tTrap.nAllowFortSave)
                {
                    int nSave = PRCMySavingThrow(SAVING_THROW_FORT, oVictim, SAVING_THROW_TYPE_TRAP);
                    if(nSave)
                    {
                        nDamage /= 2; 
			if (GetHasMettle(oTarget, SAVING_THROW_FORT))
			// This script does nothing if it has Mettle, bail
				nDamage = 0;                          
                    }    
                }   
                if(tTrap.nAllowWillSave)
                {
                    int nSave = PRCMySavingThrow(SAVING_THROW_WILL, oVictim, SAVING_THROW_TYPE_TRAP);
                    if(nSave)
                        nDamage /= 2; 
                }    
                eDamage = EffectDamage(nDamage, tTrap.nDamageType);
            }

            if(GetIsEffectValid(eTargetVFX))
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eTargetVFX, oVictim);
            if(GetIsEffectValid(eBeamVFX))
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eBeamVFX, oVictim);
            if(GetIsEffectValid(eDamage))
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oVictim);
            if(!tTrap.nFakeSpell)
                ActionCastFakeSpellAtObject(tTrap.nFakeSpell, oVictim);
            if(!tTrap.nFakeSpellLoc)
                ActionCastFakeSpellAtLocation(tTrap.nFakeSpell, GetLocation(oVictim));

            i++;
            if(fRadius == 0.0)
                oVictim = OBJECT_INVALID;
            else
                oVictim = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF), TRUE);
        }
    }
    DoTrapXP(OBJECT_SELF, oTarget, TRAP_EVENT_TRIGGERED);
}
