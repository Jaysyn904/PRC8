/*:://////////////////////////////////////////////
//:: Spell Name Invisibility
//:: Spell FileName PHS_S_Invis
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Illusion (Glamer)
    Level: Brd 2, Sor/Wiz 2, Trickery 2
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Personal or touch
    Target: One creature touched
    Duration: 1 min./level (D)
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    The creature or object touched becomes invisible, vanishing from sight, even
    from darkvision. If the recipient is carrying gear, that vanishes, too. If
    you cast the spell on someone else, neither you nor your allies can see the
    subject, unless you can normally see invisible things or you employ magic to
    do so.

    Items dropped or put down by an invisible creature become visible; items
    picked up disappear if tucked into the clothing or pouches worn by the
    creature.

    Of course, the subject is not magically silenced, and certain other conditions
    can render the recipient detectable (such as stepping in a puddle). The spell
    ends if the subject attacks any creature. For purposes of this spell, an
    attack includes any spell targeting a foe or whose area or effect includes a
    foe. (Exactly who is a foe depends on the invisible character’s perceptions.)
    Causing harm indirectly is not an attack. Thus, an invisible being can open
    doors, talk, eat, climb stairs, summon monsters and have them attack, cut the
    ropes holding a rope bridge while enemies are on the bridge, remotely trigger
    traps, open a portcullis to release attack dogs, and so forth. If the subject
    attacks directly, however, it immediately becomes visible along with all its
    gear. Spells such as bless that specifically affect allies but not foes are
    not attacks for this purpose, even when they include foes in their area.

    Arcane Material Component: An eyelash encased in a bit of gum arabic.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell description.

    Cannot make items invisible.

    Also note that the description included is good - it is to what NwN does
    (hostile actions cancle it, AOE spells which hit allies do, and actions
    which are not attacks do not).

    And the hearing (IE: You are not magically silenced) part is in.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_INVISIBILITY)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Determine duration in minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eInvisibility = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eInvisibility, eCessate);

    // Remove pervious castings of it
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_INVISIBILITY, oTarget);

    // Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_INVISIBILITY, FALSE);

    // Apply VNF and effect.
    PHS_ApplyDuration(oTarget, eLink, fDuration);
}
