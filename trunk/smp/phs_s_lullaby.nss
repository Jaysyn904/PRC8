/*:://////////////////////////////////////////////
//:: Spell Name Lullaby
//:: Spell FileName PHS_S_Lullaby
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Not a hostile spell. 20M range, and living creatures in a 3.3M radius become
    drowsy (will and SR negates) taking a -5 penalty on Listen and Spot checks
    and a -2 penalty on Will saves against sleep effects while the lullaby is in
    effect. Lullaby lasts up to 2 round per caster level.
    The spell is not considered hostile, and affects everyone in the area of
    effect equally, at the time of casting.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is pretty easy. Saving throws Versus sleep are down by 2, and -5
    skill check penalties.

    Affects a medium area. (RADIUS_SIZE_MEDIUM). It also is NOT a hostile spell!

    This could use some loverly sounds and visuals, if we could have them.

    Uses bardsong for now.

    Concentration part of this spell is removed.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_LULLABY)) return;

    // Decalre major variables.
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nSpellSaveDC = PHS_GetSpellSaveDC();

    // Duration in 2 rounds/level
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel * 2, nMetaMagic);

    // Effects (Self)
    effect eImpact = EffectVisualEffect(VFX_DUR_BARD_SONG);

    // Apply to us - refires each time a new one is cast.
    PHS_ApplyDuration(oCaster, eImpact, fDuration);

    // Effects (Everyone else)
    // We have -5 spot, listen and -2 to will saves VS sleep.
    // We apply the -2 VS sleep against any sleep effects. We add 2 to the DC.
    effect eSpot = EffectSkillDecrease(SKILL_SPOT, 5);
    effect eListen = EffectSkillDecrease(SKILL_LISTEN, 5);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eSpot, eListen);
    eLink = EffectLinkEffects(eCessate, eLink);

    // We apply this to anyone who can hear us. We use opposint GetObjectHeard checks.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
    // Only loop creatures.
    while(GetIsObjectValid(oTarget))
    {
        // We don't hit ourselves! But because it is not hostile, it does affect ANYONE
        // except those in PvP
        if(oTarget != oCaster && !GetIsReactionTypeFriendly(oTarget))
        {
            // Signal spell cast at (non-hostile)
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_LULLABY, FALSE);

            // We apply the link to them, after removing all previous ones, IF
            // they fail a will save. If they DO fail a will save, they are immune
            // for the entire duration.
            // If they resist it, they are also made immune.
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // normal will saving throw, includes immunity variable.
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC))
                {
                    // Remove all previous ones cast by us, or anyone.
                    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_LULLABY, oTarget);

                    // Apply penalties.
                    PHS_ApplyDuration(oTarget, eLink, fDuration);
                }
            }
        }
        // Get next creature
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
    }
}
