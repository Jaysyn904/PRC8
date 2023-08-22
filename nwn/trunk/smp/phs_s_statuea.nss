/*:://////////////////////////////////////////////
//:: Spell Name Statue - On Spawn
//:: Spell FileName PHS_S_StatueA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    The creature will apply the first effects, too. It'll use the effects
    creator to determine which are the granite effects.

    On Spawn

    Sets to listen for "move" and "statue", and applies effects to move through
    things.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

void main()
{
    // Apply cutscene effects
    effect eGhost = EffectCutsceneGhost();
    effect eInvis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
    effect eGone = EffectEthereal();
    effect eLink = EffectLinkEffects(eGhost, eInvis);
    eLink = EffectLinkEffects(eLink, eGone);
    eLink = SupernaturalEffect(eLink);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);

    // Set listening patterns
    SetListening(OBJECT_SELF, TRUE);
    // 50 = no statue, 60 = statue.
    SetListenPattern(OBJECT_SELF, "*move*", 50);
    SetListenPattern(OBJECT_SELF, "*statue*", 60);
}
