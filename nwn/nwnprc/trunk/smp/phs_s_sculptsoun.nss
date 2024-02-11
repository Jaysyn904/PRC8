/*:://////////////////////////////////////////////
//:: Spell Name Sculpt Sound
//:: Spell FileName PHS_S_SculptSoun
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Brd 3
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Targets: One enemy creature/level within a 10M-radius (30ft) sphere
    Duration: 1 hour/level (D)
    Saving Throw: Will negates (object)
    Spell Resistance: Yes (object)

    You change the sounds that creatures or objects make. You can transform the
    voices of enemies into other sounds. Once the transmutation is made, you
    cannot change it, although it can be dispelled normally. A spellcaster whose
    voice is changed dramatically is unable to cast spells with verbal
    components, and ususally only can utter a strange sound when he tries to.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Will use the spell hook.

    Basically, it can harm spell casters - like Silence, but only ones with
    verbal components.

    Of course, well, we'll add some strange sound FX to play at the end instead
    of casting the spell, to make it funny :-)

    To tell PC's, we'll also have floating text to tell them, as there is no
    effect for this.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(PHS_SpellHookCheck(PHS_SPELL_SCULPT_SOUND)) return;

    // Define major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    object oTarget;
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Delay = distance / 20
    float fDelay;

    // Duration is in hours
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Just a duration visual
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_SONIC);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Loop enemies - and apply the effects.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 10.0, lTarget);
    while(GetIsObjectValid(oTarget))
    {
        // Only affects non-friends. PvP Check. Must be able to be affected
        if(!GetIsFriend(oTarget) && !GetFactionEqual(oTarget) &&
           oTarget != oCaster && GetIsReactionTypeHostile(oTarget) &&
        // Make sure they are not immune to spells
          !PHS_TotalSpellImmunity(oTarget))
        {
            //Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SCULPT_SOUND);

            // Delay for visuals and effects.
            fDelay = GetDistanceBetween(oCaster, oTarget)/20;

            // Resistance and immunity checking. Check fear + mind immunity too
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Normal Will-based saving throw.
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster, fDelay))
                {
                    // Apply visuals and the duration effect
                    FloatingTextStringOnCreature("*Your voice suddenly changes from Sculpt Sound*", oTarget, FALSE);
                    DelayCommand(fDelay, PHS_ApplyDurationAndVFX(oTarget, eVis, eCessate, fDuration));
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 10.0, lTarget);
    }
}
