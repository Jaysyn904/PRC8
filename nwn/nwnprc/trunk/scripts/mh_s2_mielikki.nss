//::///////////////////////////////////////////////
//:: Name mh_s2_mielikki
//:: FileName mh_s2_mielikki
//:://////////////////////////////////////////////
/*
    Don verite de Mielikki
*/
//:://////////////////////////////////////////////
//:: Created By: Age
//:: Created On: 23 janvier 2004
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{

     //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    string str;
    if(MyPRCGetRacialType(oTarget) != RACIAL_TYPE_ANIMAL)
    {
    FloatingTextStrRefOnCreature(16825237,OBJECT_SELF,TRUE);
    IncrementRemainingFeatUses(OBJECT_SELF,FEAT_MIELIKKI);
    //FloatingTextStringOnCreature("Vous devez cibler une cible animale",OBJECT_SELF,TRUE);
    return;
    }
    if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF ))
    {
        object oMaster = GetMaster(oTarget);
        if(GetIsObjectValid(oMaster))
        {
            if( GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget )
            {
                //on revoque ici la creature avec un message
                effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_MIELIKKI));
                //Determine correct save
                int nSpellDC = 15;
                //Make SR and will save checks
                if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nSpellDC))
                {
                    //Apply the VFX and delay the destruction of the summoned monster so
                    //that the script and VFX can play.
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    DestroyObject(oTarget, 0.5);
                }
                //str = GetName(oTarget) + " est une creature invoquee par " + GetName(oMaster);
                //FloatingTextStringOnCreature(str,OBJECT_SELF,TRUE);
                return ;
            }
            /*
            else if( GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster) == oTarget )
            {
                str = GetName(oTarget) + " est le familier de " + GetName(oMaster);
                FloatingTextStringOnCreature(str,OBJECT_SELF,TRUE);
                // indique si il s'agit d'un familier ou d'un compagnon animal,
                // ou eventuellement d'un compagnon
            }
            else if( GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster) == oTarget )
            {
                str = GetName(oTarget) + " est le compagnion animal de " + GetName(oMaster);
                FloatingTextStringOnCreature(str,OBJECT_SELF,TRUE);
            }
            else if( GetAssociate(ASSOCIATE_TYPE_DOMINATED, oMaster) == oTarget )
            {
                str = GetName(oTarget) + " est une creature dominee par " + GetName(oMaster);
                FloatingTextStringOnCreature(str,OBJECT_SELF,TRUE);
            }*/
        }
        else if(PRCGetHasEffect(EFFECT_TYPE_POLYMORPH,oTarget) )
        {
            //on annule l'effet de polymorphie
            effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_MIELIKKI));
            //Determine correct save
            int nSpellDC = 15;
            //Make SR and will save checks
            if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nSpellDC))
            {
                //Apply the VFX and delay the destruction of the summoned monster so
                //that the script and VFX can play.
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                effect eTest = GetFirstEffect(oTarget);
                while(GetEffectType(eTest) != EFFECT_TYPE_POLYMORPH)
                {
                    eTest = GetNextEffect(oTarget);
                }
                RemoveEffect(oTarget,eTest);
            }
            return;
        }
        //enleve tout les effets positifs
        effect eVisual = EffectVisualEffect(VFX_IMP_HEAD_ODD);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_MIELIKKI));
         int nSpellDC = 15;
            //Make SR and will save checks
            if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nSpellDC))
            {
                effect eGood = GetFirstEffect(oTarget);
                //Search for negative effects
                while(GetIsEffectValid(eGood))
                    {
                        if (GetEffectType(eGood) == EFFECT_TYPE_ABILITY_INCREASE ||
                        GetEffectType(eGood) == EFFECT_TYPE_AC_INCREASE ||
                        GetEffectType(eGood) == EFFECT_TYPE_ATTACK_INCREASE ||
                        GetEffectType(eGood) == EFFECT_TYPE_DAMAGE_INCREASE ||
                        GetEffectType(eGood) == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE ||
                        GetEffectType(eGood) == EFFECT_TYPE_SAVING_THROW_INCREASE ||
                        GetEffectType(eGood) == EFFECT_TYPE_SPELL_RESISTANCE_INCREASE ||
                        GetEffectType(eGood) == EFFECT_TYPE_SKILL_INCREASE ||
                        GetEffectType(eGood) == EFFECT_TYPE_CONCEALMENT ||
                        GetEffectType(eGood) == EFFECT_TYPE_DAMAGE_RESISTANCE)
                        {
                            //Remove effect if it is negative.
                            RemoveEffect(oTarget, eGood);
                        }
                eGood = GetNextEffect(oTarget);
            }
        }
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
    }
    else
    {
        effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION);
        int bValid;

        effect eBad = GetFirstEffect(oTarget);
        //Search for negative effects
        while(GetIsEffectValid(eBad))
        {
            if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
                GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
                GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
                GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
                GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
                GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
                GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
                GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
                GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
                GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
                GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
                GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL)
                {
                    //Remove effect if it is negative.
                    RemoveEffect(oTarget, eBad);
                }
            eBad = GetNextEffect(oTarget);
        }
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF,SPELLABILITY_MIELIKKI, FALSE));

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
    }
}
