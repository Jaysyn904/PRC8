//::///////////////////////////////////////////////
//:: Spell: Dimensional Anchor
//:: sp_dimens_anch
//::///////////////////////////////////////////////
/** @ file
    Dimensional Anchor

    Abjuration
    Level: Clr 4, Sor/Wiz 4
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./level)
    Effect: Ray
    Duration: 1 min./level
    Saving Throw: None
    Spell Resistance: Yes (object)

    A green ray springs from your outstretched hand. You must make a ranged
    touch attack to hit the target. Any creature or object struck by the ray is
    covered with a shimmering emerald field that completely blocks
    extradimensional travel. Forms of movement barred by a dimensional anchor
    include astral projection, blink, dimension door, ethereal jaunt,
    etherealness, gate, maze, plane shift, shadow walk, teleport, and similar
    spell-like or psionic abilities. The spell also prevents the use of a gate
    or teleportation circle for the duration of the spell.

    A dimensional anchor does not interfere with the movement of creatures
    already in ethereal or astral form when the spell is cast, nor does it block
    extradimensional perception or attack forms. Also, dimensional anchor does
    not prevent summoned creatures from disappearing at the end of a summoning
    spell.


    @author Ornedan
    @date   Created  - 2005.10.20
*/
//:://////////////////////////////////////////////
//::Added hold ray functionality - HackyKid
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "prc_inc_teleport"
#include "prc_sp_func"
#include "prc_add_spell_dc"

void DispelMonitor(object oCaster, object oTarget, int nSpellID, int nBeatsRemaining);

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nSaveDC = PRCGetSaveDC(oTarget, oCaster);
    int nSpellID = PRCGetSpellId();
    int nPenetr = nCasterLevel + SPGetPenetr();
    effect eVis    = EffectVisualEffect(VFX_DUR_GLOW_GREEN);
    float fDur     = PRCGetMetaMagicDuration(60.0 * nCasterLevel);

    // Let the AI know
    PRCSignalSpellEvent(oTarget, TRUE, nSpellID, oCaster);

    // Touch Attack
    int iAttackRoll = PRCDoRangedTouchAttack(oTarget);

    // Shoot the ray
    effect eRay = EffectBeam(VFX_BEAM_DISINTEGRATE, oCaster, BODY_NODE_HAND, !(iAttackRoll > 0));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);

    // Apply effect if hit
    if(iAttackRoll > 0)
    {
        // Spell Resistance
        if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
        {
            // No duplicate dimensional anchor spell effects
            if(!GetLocalInt(oTarget, "PRC_DimAnch"))
            {
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDur, TRUE, nSpellID, nCasterLevel);
                // Increase the teleportation prevention counter
                DisallowTeleport(oTarget);
                // Set a marker so the power won't apply duplicate effects
                SetLocalInt(oTarget, "PRC_DimAnch", TRUE);
                // Start the monitor
                DelayCommand(6.0f, DispelMonitor(oCaster, oTarget, nSpellID, (FloatToInt(fDur) / 6) - 1));

                if(DEBUG) DoDebug("sp_dimens_anch: The anchoring will wear off in " + IntToString(FloatToInt(fDur)) + "s");
            }
        }
    }

    return iAttackRoll;    //return TRUE if spell charges should be decremented
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
        if (GetLocalInt(oCaster, PRC_SPELL_HOLD) && GetHasFeat(FEAT_EF_HOLD_RAY, oCaster) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
	if (oCaster != oTarget)	//cant target self with this spell, only when holding charge
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

void DispelMonitor(object oCaster, object oTarget, int nSpellID, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0) ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oCaster)
       )
    {
        if(DEBUG) DoDebug("sp_dimens_anch: The anchoring effect has been removed");
        // Reduce the teleport prevention counter
        AllowTeleport(oTarget);
        // Clear the effect presence marker
        DeleteLocalInt(oTarget, "PRC_DimAnch");
    }
    else
       DelayCommand(6.0f, DispelMonitor(oCaster, oTarget, nSpellID, nBeatsRemaining));
}