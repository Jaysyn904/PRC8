//::///////////////////////////////////////////////
//:: Name      Melf's Acid Arrow
//::           Greater Shadow Conjuration: Melf's Acid Arrow
//:: FileName  nw_s0_acidarrow.nss
//:: Copyright (c) 2000 Bioware Corp.
/*:://////////////////////////////////////////////
Melf's Acid Arrow
Conjuration (Creation) [Acid]
Level:            Sor/Wiz 2
Components:       V, S, M, F
Casting Time:     1 standard action
Range:            Long (400 ft. + 40 ft./level)
Effect:           One arrow of acid
Duration:         1 round + 1 round per three levels
Saving Throw:     None
Spell Resistance: No

A magical arrow of acid springs from your hand and
speeds to its target. You must succeed on a ranged
touch attack to hit your target. The arrow deals
2d4 points of acid damage with no splash damage.
For every three caster levels (to a maximum of 18th),
the acid, unless somehow neutralized, lasts for
another round, dealing another 2d4 points of damage
in that round.

Material Component
Powdered rhubarb leaf and an adder’s stomach.

Focus
A dart.
//:://////////////////////////////////////////////
//:: Created By: xwarren
//:: Created On: 2011-01-07
//::*/////////////////////////////////////////////

#include "prc_inc_sp_tch"

void ArrowImpact(object oTarget, object oCaster, int nDuration, int nMetaMagic, int iAttackRoll, int nSpellID);
void PerRoundDamage(object oTarget, object oCaster, int nDuration, int nMetamagic, int EleDmg, int nSpellID);

void main()
{
    if(!X2PreSpellCastCode()) return;

    int nSpellID = PRCGetSpellId();
    int nSchool;

    switch(nSpellID)
    {
        case SPELL_MELFS_ACID_ARROW: nSchool = SPELL_SCHOOL_CONJURATION; break;
        case SPELL_GREATER_SHADOW_CONJURATION_ACID_ARROW: nSchool = SPELL_SCHOOL_ILLUSION; break;
    }

    PRCSetSchool(nSchool);

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int CasterLvl = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eArrow = EffectVisualEffect(VFX_DUR_MIRV_ACID);

    int nDuration = (CasterLvl / 3);
    if(nDuration > 6) nDuration = 6;
    if(nMetaMagic & METAMAGIC_EXTEND)
        nDuration *= 2;

    CasterLvl += SPGetPenetr();

    if(!GetIsReactionTypeFriendly(oTarget, oCaster))
    {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID));

        int iAttackRoll = PRCDoRangedTouchAttack(oTarget);
        if(iAttackRoll > 0)
        {
            float fDelay = GetDistanceToObject(oTarget) / 25.0f;

            if(!PRCDoResistSpell(oCaster, oTarget, CasterLvl, fDelay))
            {
                DelayCommand(fDelay, ArrowImpact(oTarget, oCaster, nDuration, nMetaMagic, iAttackRoll, nSpellID));
            }
            else
            {
                // Indicate Failure
                effect eSmoke = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
                DelayCommand(fDelay+0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSmoke, oTarget));
            }
         }
    }
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eArrow, oTarget);

    PRCSetSchool();
}

void ArrowImpact(object oTarget, object oCaster, int nDuration, int nMetaMagic, int iAttackRoll, int nSpellID)
{
    int EleDmg = ChangedElementalDamage(oCaster, DAMAGE_TYPE_ACID);

    // Setup VFX
    effect eVis   = EffectVisualEffect(VFX_IMP_ACID_L);
    effect eDur   = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    // Set the VFX to be non dispelable, because the acid is not magic
           eDur   = ExtraordinaryEffect(eDur);

    // Calculate damage
    int nDamage = d4(2);
    if(nMetaMagic & METAMAGIC_MAXIMIZE)
        nDamage = 8;
    if(nMetaMagic & METAMAGIC_EMPOWER)
        nDamage += nDamage / 2;
                // Acid Sheath adds +1 damage per die to acid descriptor spells
                if (GetHasDescriptor(nSpellID, DESCRIPTOR_ACID) && GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oCaster))
                	nDamage += 2;         
	nDamage += SpellDamagePerDice(oCaster, 2);
    // Apply the VFX and initial damage
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nDuration), FALSE);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyTouchAttackDamage(oCaster, oTarget, iAttackRoll, nDamage, EleDmg);
    PRCBonusDamage(oTarget);

    nDuration--;
    DelayCommand(6.0f, PerRoundDamage(oTarget, oCaster, nDuration, nMetaMagic, EleDmg, nSpellID));
}

void PerRoundDamage(object oTarget, object oCaster, int nDuration, int nMetaMagic, int EleDmg, int nSpellID)
{
    if(GetIsDead(oTarget))
        return;

    // Calculate damage
    int nDamage = d4(2);
    if(nMetaMagic & METAMAGIC_MAXIMIZE)
        nDamage = 8;
    if(nMetaMagic & METAMAGIC_EMPOWER)
        nDamage += nDamage / 2;
                // Acid Sheath adds +1 damage per die to acid descriptor spells
                if (GetHasDescriptor(nSpellID, DESCRIPTOR_ACID) && GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oCaster))
                	nDamage += 2;         
	nDamage += SpellDamagePerDice(oCaster, 2);
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eDam = PRCEffectDamage(oTarget, nDamage, EleDmg);
           eDam = EffectLinkEffects(eVis, eDam);

    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);

    if(nDuration--)
        DelayCommand(6.0f, PerRoundDamage(oTarget, oCaster, nDuration, nMetaMagic, EleDmg, nSpellID));
}
