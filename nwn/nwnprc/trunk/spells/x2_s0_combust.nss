/*
    x2_s0_combust

    The initial eruption of flame causes  2d6 fire damage +1
    point per caster level(maximum +10)
    with no saving throw.

    Further, the creature must make
    a Reflex save or catch fire taking a further 1d6 points
    of damage. This will continue until the Reflex save is
    made.

    There is an undocumented artificial limit of
    10 + casterlevel rounds on this spell to prevent
    it from running indefinitly when used against
    fire resistant creatures with bad saving throws

    By: Georg Zoeller
    Created: 2003/09/05
    Modified: Jun 30, 2006
*/

#include "prc_sp_func"
#include "x2_inc_toollib"
#include "prc_add_spell_dc"
void RunCombustImpact(object oTarget, object oCaster, int nLevel, int nMetaMagic,int EleDmg)
{
    if (PRCGetDelayedSpellEffectsExpired(SPELL_COMBUST,oTarget,oCaster)) return;

    if (GetIsDead(oTarget) == FALSE)
    {
        int nDC = GetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_COMBUST));
        if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE))
        {
            int nDamageLimit = nLevel;
            if (nDamageLimit > 10) nDamageLimit = 10;
            int nDamage = nDamageLimit + d6();
            if ((nMetaMagic & METAMAGIC_MAXIMIZE))
            {
                nDamage = nDamageLimit + 6;
            }
            if ((nMetaMagic & METAMAGIC_EMPOWER))
            {
                nDamage = nDamage + (nDamage/2);
            }
			nDamage += SpellDamagePerDice(oCaster, nDamageLimit);
            effect eDmg = PRCEffectDamage(oTarget, nDamage,EleDmg);
            effect eVFX = EffectVisualEffect(VFX_IMP_FLAME_S);

            SPApplyEffectToObject(DURATION_TYPE_INSTANT,eDmg,oTarget);
            PRCBonusDamage(oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX,oTarget);

            DelayCommand(6.0f,RunCombustImpact(oTarget,oCaster, nLevel,nMetaMagic,EleDmg));
        }
        else
        {
            DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_COMBUST));
            GZPRCRemoveSpellEffects(SPELL_COMBUST, oTarget);
        }
   }
}

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nDC = (PRCGetSaveDC(oTarget,oCaster));
    int EleDmg = ChangedElementalDamage(oCaster, DAMAGE_TYPE_FIRE);
    int nDamageLimit = nCasterLevel;
    if (nDamageLimit > 10)
    {
        nDamageLimit = 10;
    }
    int nDamage = nDamageLimit + d6(2);
    int nMetaMagic = PRCGetMetaMagicFeat();
    if ((nMetaMagic & METAMAGIC_MAXIMIZE))
    {
        nDamage = nDamageLimit + 12;//Damage is at max
    }
    if ((nMetaMagic & METAMAGIC_EMPOWER))
    {
        nDamage += nDamage / 2;//Damage/Healing is +50%
    }
    nDamage += SpellDamagePerDice(oCaster, nDamageLimit);
    //nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);
    int nDuration = 10 + nCasterLevel;
    if (nDuration < 1)
    {
        nDuration = 10;
    }
    effect eDam      = PRCEffectDamage(oTarget, nDamage, EleDmg);
    effect eDur      = EffectVisualEffect(498);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_COMBUST));
        if(!PRCDoResistSpell(OBJECT_SELF, oTarget,nCasterLevel+SPGetPenetr()))
        {
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            TLVFXPillar(VFX_IMP_FLAME_M, GetLocation(oTarget), 5, 0.1f,0.0f, 2.0f);
            if (GetHasSpellEffect(GetSpellId(),oTarget) || GetHasSpellEffect(SPELL_INFERNO,oTarget)  )
            {
                FloatingTextStrRefOnCreature(100775,oCaster,FALSE);
                return TRUE;
            }
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nDuration));
            SetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_COMBUST), nDC);
            DelayCommand(6.0, RunCombustImpact(oTarget,oCaster,nCasterLevel, nMetaMagic,EleDmg));
        }
    }

    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}