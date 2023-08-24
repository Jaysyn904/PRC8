/*:://////////////////////////////////////////////
//:: Spell Name Familiar Transposition
//:: Spell FileName XXX_S_FamiliarTr
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation [Teleportation]
    Level: Sor/Wiz 4
    Components: V
    Casting Time: 1 standard action
    Range: Personal
    Duration: Instantaneous
    Saving Throw: None
    Spell Resistance: No
    Source: Various (Fordan)

    This spell instantly transposes the caster and all gear and items he carries
    with his familiar.

    In order for the spell to succeed, the familiar must be within range of the
    empathic link, i.e. in the same area, and actually summoned. The spell does
    not work if the familiar is dead, unconscious, cannot move or under a
    mind-affecting spell or effect.

    M: A piece of glass with the name of the familiar etched on it.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Oh, sure, you can abuse it by unsummoning your familar, but oh well...

    Still, not too bad, and easily scripted.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

// Check familiar
int CheckFamiliar(object oFamiliar);

// Jump to lTarget, using OBJECT_SELF as the person, and doing a VFX.
void DoJump(location lTarget);

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_FAMILIAR_TRANSPOSITION)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oCaster);
    location lTarget = GetLocation(oFamiliar);
    location lCaster = GetLocation(oCaster);

    // Declare effects
    effect eDissappear = EffectVisualEffect(VFX_FNF_TELEPORT_OUT);

    // Make sure we can teleport
    if(!SMP_CannotTeleport(oCaster, lTarget) &&
       !SMP_CannotTeleport(oFamiliar, lCaster))
    {
        // Must be able to move
        // Check the familiar
        if(CheckFamiliar(oFamiliar))
        {
            // Jump to the target location with visual effects
            SMP_ApplyLocationVFX(lCaster, eDissappear);
            SMP_ApplyLocationVFX(lTarget, eDissappear);

            // Move each object to the other place

            // Jump and effects
            DelayCommand(1.0, AssignCommand(oCaster, DoJump(lTarget)));
            DelayCommand(1.0, AssignCommand(oFamiliar, DoJump(lCaster)));
        }
    }
}

// Check familiar
int CheckFamiliar(object oFamiliar)
{
    effect eCheck = GetFirstEffect(oFamiliar);
    while(GetIsEffectValid(eCheck))
    {
        switch(GetEffectType(eCheck))
        {
            case EFFECT_TYPE_CHARMED:
            case EFFECT_TYPE_CONFUSED:
            case EFFECT_TYPE_DAZED:
            case EFFECT_TYPE_DOMINATED:
            case EFFECT_TYPE_ENTANGLE:
            case EFFECT_TYPE_FRIGHTENED:
            case EFFECT_TYPE_PARALYZE:
            case EFFECT_TYPE_PETRIFY:
            case EFFECT_TYPE_SLEEP:
            case EFFECT_TYPE_STUNNED:
            case EFFECT_TYPE_TURNED:
            {
                return FALSE;
            }
            break;
        }
        // Get next effect
        eCheck = GetNextEffect(oFamiliar);
    }
    if(!GetCommandable(oFamiliar))
    {
        return FALSE;
    }
    // TRUE if they can move
    return TRUE;
}

// Jump to lTarget, using OBJECT_SELF as the person, and doing a VFX.
void DoJump(location lTarget)
{
    JumpToLocation(lTarget);
    SMP_ApplyLocationVFX(lTarget, EffectVisualEffect(VFX_FNF_TELEPORT_IN));
}
