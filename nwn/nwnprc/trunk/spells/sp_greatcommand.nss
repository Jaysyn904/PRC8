//::///////////////////////////////////////////////
//:: Name      Greater Command
//:: FileName  sp_greatcommand.nss
//:://////////////////////////////////////////////
/**@file Greater Command
Enchantment (Compulsion) [Mind-Affecting]
Level: Cleric 5
Components: V
Casting Time: 1 action
Range: Close (25 ft. + 5 ft/2 levels)
Targets: 1 living creature/level
AoE: 30' Burst
Duration: 1 Round/level
Saving Throw: Will Negates
Spell Resistance: Yes

You give the subjects a single command, which they obey to the best of their ability. At the beginning of each round, the targets get a new saving throw to end the effect.

Approach - The target runs directly towards you for the duration of the spell.
Drop - The target drops what it is holding (This will not work on creatures that cannot be disarmed).
Fall - The target falls to the ground for the duration of the spell.
Flee - The target runs away from the caster for the duration of the spell.
Halt - The target stands in place and takes no action for the duration of the spell.

Author:    Stratovarius
Created:   29/4/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void DoGreaterCommandRecursion(object oCaster, object oTarget, int nSpellId, int nLastBeat, effect eLink, int nDC, int nCaster, int nCurrentBeat = 0)
{
    if(DEBUG) DoDebug("DoGreaterCommandRecursion: SpellId: " + IntToString(nSpellId));
    // Check for expiration
    if(nCurrentBeat <= nLastBeat/* && !PRCGetDelayedSpellEffectsExpired(nSpellId, oTarget, oCaster)*/)
    {
    	if(DEBUG) DoDebug("nCurrentBeat <= nLastBeat");
        // On the first beat, just apply the Command effects
        if (nCurrentBeat == 0)
        {
            if(DEBUG) DoDebug("nCurrentBeat == 0");
            // The duration is only one because this gets called every six seconds and reapplied if they fail the save)
            DoCommandSpell(oCaster, oTarget, nSpellId, 1, nCaster);
        }
        else // They get a new saving throw to beat the spell
        {
            if(DEBUG) DoDebug("Else");
            // Do the saving throw
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                if(DEBUG) DoDebug("Save Again");
                // Apply the effects
                DoCommandSpell(oCaster, oTarget, nSpellId, 1, nCaster);
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0, TRUE,-1,nCaster);
            }
            else // The spell fizzles, and this will shutdown on the next beat
            {
                if(DEBUG) DoDebug("Remove Spell");
                PRCRemoveEffectsFromSpell(oTarget, nSpellId);
            }
        }
        // Schedule next impact
        DelayCommand(6.0f, DoGreaterCommandRecursion(oCaster, oTarget, nSpellId, nLastBeat, eLink, nDC, nCaster, (nCurrentBeat + 1)));
        if(DEBUG) DoDebug("Looping Back");
    }
}

void main()
{
    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);

    // Run the spellhook.
    if (!X2PreSpellCastCode()) return;

    //Define vars
    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    int nSpellId = PRCGetSpellId();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCaster = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = nCaster;
    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
            nDuration = nDuration * 2; //Duration is +100%
    }

    effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eMind, eDur);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && PRCGetIsAliveCreature(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
            if (!PRCDoResistSpell(OBJECT_SELF, oTarget, nCaster+SPGetPenetr()))
            {
                int nDC = PRCGetSaveDC(oTarget, oCaster);
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0, TRUE,-1,nCaster);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    DoGreaterCommandRecursion(oCaster, oTarget, nSpellId, nDuration, eLink, nDC, nCaster);
                }
            }
        }
       //Select the next target within the spell shape.
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    PRCSetSchool();
}
