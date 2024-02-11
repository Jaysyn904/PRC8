/*:://////////////////////////////////////////////
//:: Spell Name Shatter
//:: Spell FileName PHS_S_Shatter
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Sonic]
    Level: Brd 2, Chaos 2, Clr 2, Destruction 2, Sor/Wiz 2
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One door or placable, or one crystalline creature
    Duration: Instantaneous
    Saving Throw: Will negates; or Fortitude half; see text
    Spell Resistance: Yes

    Shatter creates a loud, ringing noise that breaks brittle, nonmagical
    objects; or damages a crystalline creature.

    You can target shatter against a single solid placable or door, regardless
    of composition, weighing up to 10 pounds per caster level.

    Targeted against a crystalline creature (of any weight), shatter deals 1d6
    points of sonic damage per caster level (maximum 10d6), with a Fortitude
    save for half damage.

    Arcane Material Component: A chip of mica.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Removed all small destroying of porcilin and so on. NwN doesn't have much
    in the way of that.

    If the module builder does, they can add crystaline creatures (Crystal golems
    come to mind) Can be therefore quite effective against them.

    Placeables/doors targeted can be destroyed according to wieght and stuff.
    Weight is set via. variables box on the door. No weight == cannot be destroyed.

    - Could use custom VFX
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SHATTER)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nTargetType = GetObjectType(oTarget);
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nDice = PHS_LimitInteger(nCasterLevel, 10);
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nDam, nSave;

    // Declare visual effects
    effect eAOE = EffectVisualEffect(VFX_FNF_SOUND_BURST);
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);

    // Apply AOE visual whatever
    PHS_ApplyLocationVFX(GetLocation(oTarget), eAOE);

    // Signal spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SHATTER);

    // Check if door or placeable
    if(nTargetType == OBJECT_TYPE_DOOR ||
       nTargetType == OBJECT_TYPE_PLACEABLE)
    {
        // Check "weight".
        int nWeight = GetLocalInt(oTarget, PHS_PLACEABLE_WEIGHT);
        // Check caster level against weight, making sure it is not 0.
        if(nWeight > 0 && nCasterLevel * 10 >= nWeight)
        {
            // Will negates
            if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_SONIC))
            {
                // Apply damage and effects
                PHS_ApplyDeathByDamageAndVFX(oTarget, eVis);
            }
        }
    }
    // Check reaction type
    else if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Check if they are crystalline
        if(PHS_GetIsCrystalline(oTarget))
        {
            // Check spell resistance
            if(PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Get damage
                nDam = PHS_MaximizeOrEmpower(6, nDice, nMetaMagic);

                // Fortitude save halfs it
                nDam = PHS_GetAdjustedDamage(SAVING_THROW_FORT, nDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_SONIC);

                // Damage and VFX
                PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_SONIC);
            }
        }
    }
}
