/*:://////////////////////////////////////////////
//:: Spell Name Wolfskin
//:: Spell FileName XXX_S_Wolfskin
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Drd 2, Rgr 3
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 minute/level (D)
    Saving Throw: None
    Spell Resistance: No (harmless)
    Source: Various (WotC)

    You take the shape of a normal wolf as if you had the wild shape ability of
    a 5th-level druid.

    Focus: The skin of a wolf, dire wolf, werewolf, worg, or winter wolf. The
    skin melds with your body while the spell is in  effect, and it returns to
    normal when you assume your own shape.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Can even use Bioware's own defined Wolf for the Wild Shape ability for this,
    which is nice.

    It is not instant - it can still be dispelled normally, well, I interpert
    it that way.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/
#include "pnp_shft_poly"
#include "prc_inc_spells"

void main()
{
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));

    if (!X2PreSpellCastCode()) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF
    int nCasterLevel = PRCGetCasterLevel();
    int nMetaMagic = PRCGetMetaMagicFeat();

    // Get duration - 1 minute/level
    int nDuration = nCasterLevel;

    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2;   //Duration is +100%
    }

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect eWolf = EffectPolymorph(POLYMORPH_TYPE_WOLF);// * Same as from nw_s2_wildshape

    // Signal Spell cast at
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WOLFSKIN, FALSE));

    // abort if mounted
    if (!GetLocalInt(GetModule(),"X3_NO_SHAPESHIFT_SPELL_CHECK"))
    { // check to see if abort due to being mounted
        if (PRCHorseGetIsMounted(oTarget))
        { // abort
            if (GetIsPC(oTarget)) FloatingTextStrRefOnCreature(111982,oTarget,FALSE);
              return;
        } // abort
    } // check to see if abort due to being mounted

    //this command will make shore that polymorph plays nice with the shifter
    ShifterCheck(oTarget);

    AssignCommand(oTarget, ClearAllActions()); // prevents an exploit

    // Apply polymorph
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWolf, oTarget, TurnsToSeconds(nDuration),TRUE,-1,nCasterLevel);
    DelayCommand(1.5,ActionCastSpellOnSelf(SPELL_SHAPE_INCREASE_DAMAGE));

    PRCSetSchool();
}
