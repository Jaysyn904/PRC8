/*:://////////////////////////////////////////////
//:: Spell Name Phase Door
//:: Spell FileName PHS_S_PhaseDoor
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Creation)
    Level: Sor/Wiz 7, Travel 8
    Components: V
    Casting Time: 1 standard action
    Range: 20M
    Effect: Invisible opening leading from current position to chosen location
    Duration: One usage per two levels
    Saving Throw: None
    Spell Resistance: No

    This spell creates an ethereal passage. The phase door is invisible and
    inaccessible to all creatures except your party members. You disappear when
    you enter the phase door and appear when you exit. To find an entrance or
    exit, activate your power (as your allies also can). The door disappears
    after a few seconds unless you can see it (see below). You can only have
    one Phase Door open at any one time.

    The door does not allow light, sound, or spell effects through it, nor can
    you see through it without using it. Thus, the spell can provide an escape
    route. Spells such as See invisiblity and True Seeing will allow anyone to
    see the door, but not allow its use.

    A phase door is subject to dispel magic, although no one will be in it as
    distance between the two points is so small the time to move is instant.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Uses a creature who invisiblieses themselves.

    Each creature (an entrance, point 1, and an exit, point 2) will be created.

    A power will remove the invisibility off it. They should have a visual
    from the spell. The invisiblity will be applied as thier own (undispellable)
    effect.

    Click on one for conversation, it takes you to the other.

    One of the creatures is the "master" of the two, and is set to the caster.
    Thats all, else, if one exsists and one doesn't, they both go.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_PHASE_DOOR)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    location lCaster = GetLocation(oCaster);
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();

    // 1 use/2 levels
    int nUses = PHS_LimitInteger(nCasterLevel/2);

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    effect eDur = EffectVisualEffect(PHS_VFX_DUR_PHASE_DOOR);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oCaster, PHS_SPELL_PHASE_DOOR, FALSE);

    // Check for previous ones, destroy any.
    object oPrevious = GetLocalObject(oCaster, "PHS_PHASE_DOOR_PREVIOUS");
    if(GetIsObjectValid(oPrevious))
    {
        // Force him to go
        PHS_CompletelyDestroyObject(oPrevious);
    }

    // Create new ones.
    object oMasterDoor = CreateObject(OBJECT_TYPE_CREATURE, "phs_phasedoor", lCaster);
    object oServantDoor = CreateObject(OBJECT_TYPE_CREATURE, "phs_phasedoor", lTarget);

    // Set the master to the caster - raster plaster blaster
    SetLocalObject(oCaster, "PHS_PHASE_DOOR_PREVIOUS", oMasterDoor);

    // Set, on each other, the doors.
    SetLocalObject(oServantDoor, "PHS_PHASE_DOOR_TARGET", oMasterDoor);
    SetLocalObject(oMasterDoor, "PHS_PHASE_DOOR_TARGET", oServantDoor);

    // Set the "charges"
    SetLocalInt(oServantDoor, "PHS_PHASE_DOOR_CHARGES", nUses);
    SetLocalInt(oMasterDoor, "PHS_PHASE_DOOR_CHARGES", nUses);

    // Apply effects
    PHS_ApplyPermanentAndVFX(oServantDoor, eVis, eDur);
    PHS_ApplyPermanentAndVFX(oMasterDoor, eVis, eDur);
}
