//::///////////////////////////////////////////////
//:: Name      Halt Undead
//:: FileName  sp_halt_undd.nss
//:://////////////////////////////////////////////
/**@file Halt Undead
Necromancy
Level:            Sor/Wiz 3, Dn 3
Components:       V, S, M
Casting Time:     1 standard action
Range:            Medium (100 ft. + 10 ft./level)
Targets:          Up to three undead creatures, no
                  two of which can be more than 30 ft. apart
Duration:         1 round/level
Saving Throw:     Will negates (see text)
Spell Resistance: Yes

This spell renders as many as three undead creatures
immobile. A nonintelligent undead creature gets no
saving throw; an intelligent undead creature does.
If the spell is successful, it renders the undead
creature immobile for the duration of the spell
(similar to the effect of hold person on a living
creature). The effect is broken if the halted
creatures are attacked or take damage.

Material Component
A pinch of sulfur and powdered garlic.
**/

#include "prc_inc_spells"
#include "prc_add_spell_dc"

int BiowareHoldPerson (int nPenetr, int nCasterLvl, int nMeta, object oTarget, float fDelay);

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLvl+SPGetPenetr();
    int nTargets = 0;
    float fDuration;
    float fDelay;

    effect eLink = EffectLinkEffects(EffectCutsceneParalyze(), EffectVisualEffect(VFX_DUR_PARALYZED));
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PARALYZE_HOLD));
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SOUND_BURST), lTarget);

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            //Make sure the target is an undead
            if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD && oTarget != oCaster)
            {
                fDelay = PRCGetSpellEffectDelay(lTarget, oTarget);
                nTargets++;

                PRCSignalSpellEvent(oTarget);

                //Make SR Check
                if(!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))
                {
                    // mindless - no save
                    if(GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) < 11
                    || !PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, oCaster), SAVING_THROW_TYPE_SPELL))
                    {
                        fDuration = PRCGetMetaMagicDuration(RoundsToSeconds(PRCGetScaledDuration(nCasterLvl, oTarget)));
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration,TRUE,-1,nCasterLvl));
                    }
                }
            }
        }
        if(nTargets >= 3) break;

        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    PRCSetSchool();
}