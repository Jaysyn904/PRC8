/*:://////////////////////////////////////////////
//:: Spell Name Ghost Sound
//:: Spell FileName PHS_S_Ghostsnd
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Illusion (Figment)
    Level: Brd 0, Sor/Wiz 0
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Close (8M)
    Effect: Illusory sounds
    Duration: 1 round/level (D)
    Saving Throw: Will disbelief (if interacted with)
    Spell Resistance: No

    Ghost sound allows you to create a volume of sound that rises, recedes,
    approaches, or remains at a fixed place. You choose what type of sound ghost
    sound creates when casting it and cannot thereafter change the sound’s basic
    character.

    The volume of sound created depends on your level. You can produce as much
    noise as four normal humans per caster level (maximum twenty humans). Thus,
    talking, singing, shouting, walking, marching, or running sounds can be
    created. The noise a ghost sound spell produces can be virtually any type
    of sound within the volume limit. A horde of rats running and squeaking is
    about the same volume as eight humans running and shouting. A roaring lion
    is equal to the noise from sixteen humans, while a roaring dire tiger is
    equal to the noise from twenty humans.

    Ghost sound can enhance the effectiveness of a silent image spell.

    Ghost sound can be made permanent with a permanency spell.

    Material Component: A bit of wool or a small lump of wax.



    Choose a set from the menu, and uses PlaySound for the sound effects.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Ghost sounds...

    This can be one of 4 pre-set sounds, which are castable by anyone (IE
    the sounds is of 4 humans).

    It is not a hostile spell, but DM's can make NPC's react accordingly, and
    it can be used for roleplay.

    There is a 5th spell which opens a conversation which can choose a sound
    according to level and cast it.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_GHOST_SOUND)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // The duration is 1 round/level, of the selected sound.
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    int nSpellId = GetSpellId();

    // First, check if custom, or the base spell.
    switch(nSpellId)
    {
        case PHS_SPELL_GHOST_SOUND_CUSTOM:
        {
            // If it is not a PC, run normal human sounds.
            if(!GetIsPC(oCaster))
            {
                // Sounds set as human
                SetLocalInt(oCaster, PHS_GHOST_SOUND_SOUNDS_CUSTOM, PHS_SOUNDS_HUMAN);
            }
            // If a PC, run any sound conversation
            else
            {
                // Jass - none for now
                SetLocalInt(oCaster, PHS_GHOST_SOUND_SOUNDS_CUSTOM, PHS_SOUNDS_HUMAN);
            }
        }
        break;
        // Else, we apply
        case PHS_SPELL_GHOST_SOUND_HUMANS:
        {
            SetLocalInt(oCaster, PHS_GHOST_SOUND_SOUNDS_CUSTOM, PHS_SOUNDS_HUMAN);
        }
        break;
        case PHS_SPELL_GHOST_SOUND_ORCS:
        {
            SetLocalInt(oCaster, PHS_GHOST_SOUND_SOUNDS_CUSTOM, PHS_SOUNDS_ORCS);
        }
        break;
        case PHS_SPELL_GHOST_SOUND_RATS:
        {
            SetLocalInt(oCaster, PHS_GHOST_SOUND_SOUNDS_CUSTOM, PHS_SOUNDS_RATS);
        }
        break;
        // Default to wind
        default: //case PHS_SPELL_GHOST_SOUND_WIND:
        {
            SetLocalInt(oCaster, PHS_GHOST_SOUND_SOUNDS_CUSTOM, PHS_SOUNDS_WIND);
        }
        break;
    }
    // Apply it to a location.
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_GHOST_SOUND);
    PHS_ApplyLocationDuration(lTarget, eAOE, fDuration);
}
