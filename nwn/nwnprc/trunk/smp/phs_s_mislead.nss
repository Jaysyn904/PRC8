/*:://////////////////////////////////////////////
//:: Spell Name Mislead
//:: Spell FileName PHS_S_Mislead
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Illusion (Figment, Glamer)
    Level: Brd 5, Luck 6, Sor/Wiz 6, Trickery 6
    Components: S
    Casting Time: 1 standard action
    Range: Close (8M)
    Target/Effect: You/one illusory double
    Duration: 1 round/level (D) and concentration + 3 rounds; see text
    Saving Throw: None or Will disbelief (if interacted with); see text
    Spell Resistance: No

    You become invisible (as improved invisibility, a glamer), and at the same
    time, an illusory double of you (as major image, a figment) appears. You are
    then free to go elsewhere while your double moves away. The double appears
    within range but thereafter moves as you direct it. You can make the figment
    appear superimposed perfectly over your own body so that observers don’t
    notice an image appearing and you turning invisible. The double moves at
    your speed and can talk and gesture as if it were real, but it cannot
    attack or cast spells, though it can pretend to do so.

    Actions you can give it as a henchmen is "Follow" "Do nothing (stand ground)"
    "Attack (Pretend to attack)".

    The illusory double lasts as long as you concentrate upon it, plus 3
    additional rounds. After you cease concentration, the illusory double
    continues to carry out the same activity until the duration expires. The
    improved invisibility lasts for 1 round per level, regardless of concentration.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell says. This can be done in part (but never perfectly, it is
    a real-time computer game).

    The illusion is a CopyObject() of the person. It has full consealment against
    attacks and is plotted.

    A temp effect is added so the illusion can be dispelled.

    An additional, a heartbeat is added to the copy so it can do actions (fake ones).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_CONCENTR"

void main()
{
    // If we are concentrating, and cast at the same spot, we set the integer
    // for the misleading concentration up by one.
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();

    // Check the function
    if(PHS_ConcentatingContinueCheck(PHS_SPELL_MISLEAD, lTarget, PHS_AOE_TAG_PER_MISLEAD, 18.0, oCaster)) return;

    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MISLEAD)) return;

    // Declare Major Variables
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    string sName = GetName(oCaster);

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oCaster)) return;

    // We set the "Concentration" thing to 18 seconds
    // This also returns the array we set people affected to, and does the new
    // action.
    string sArrayLocal = PHS_ConcentatingStart(PHS_SPELL_MISLEAD, 1000, lTarget, PHS_AOE_PER_MISLEAD, 18.0, oCaster);
    int nArrayCount;

    // Havn't already got one
    int nCnt = 1;
    object oHenchmen = GetHenchman(oCaster, nCnt);
    while(GetIsObjectValid(oHenchmen))
    {
        // We check its name
        if(GetName(oHenchmen) == sName)
        {
            // Stop it
            FloatingTextStringOnCreature("You cannot have more then one Misleading Image present", oCaster, FALSE);
            return;
        }
        // Add one, check next henchman
        nCnt++;
        oHenchmen = GetHenchman(oCaster, nCnt);
    }

    // Determine duration in rounds for invisiblity
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eInvisibility = EffectInvisibility(INVISIBILITY_TYPE_IMPROVED);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eConseal = EffectConcealment(100);
    effect eMiss = EffectMissChance(100);
    effect eImmune = EffectSpellLevelAbsorption(9);
    effect eGhost = EffectCutsceneGhost();

    // Link effects
    effect eLink = EffectLinkEffects(eInvisibility, eCessate);
    effect eLink2 = EffectLinkEffects(eConseal, eCessate);
    eLink2 = EffectLinkEffects(eLink2, eImmune);
    eLink2 = EffectLinkEffects(eLink2, eMiss);
    eLink2 = EffectLinkEffects(eLink2, eGhost);

    // Remove pervious castings of it
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_MISLEAD, oCaster);

    // Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oCaster, PHS_SPELL_MISLEAD, FALSE);

    // We create the image
    object oImage = CopyObject(oCaster, lTarget);

    // Plot it
    SetPlotFlag(oImage, TRUE);

    // Add it as a henchman
    AddHenchman(oCaster, oImage);

    // We apply the effects
    PHS_ApplyPermanent(oImage, eLink2);

    // Add to the array for Mislead array concentrating
    nArrayCount++;
    SetLocalObject(oCaster, sArrayLocal + IntToString(nArrayCount), oImage);
    // Set the max people in the array
    SetLocalInt(oCaster, sArrayLocal, nArrayCount);

    // We will start the heartbeat
    DelayCommand(6.0, ExecuteScript("phs_s_mislead_x", oImage));

    // Apply VNF and effect.
    PHS_ApplyDuration(oCaster, eLink, fDuration);
}
