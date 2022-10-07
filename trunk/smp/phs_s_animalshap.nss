/*:://////////////////////////////////////////////
//:: Spell Name Animal Shapes
//:: Spell FileName PHS_S_AnimalShap
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Animal Shapes
    Transmutation
    Level: Animal 7, Drd 8
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Close (8M)
    Targets: Up to 1 ally/level, in a 10M radius.
    Duration: 1 hour/level (D)
    Saving Throw: None; see text
    Spell Resistance: Yes (harmless)

    As polymorph, except you polymorph up to one willing creature per caster
    level into an animal of your choice; the spell has no effect on unwilling
    creatures. All creatures must take the same kind of animal form. Recipients
    remain in the animal form until the spell expires or until you dismiss it
    for all recipients. In addition, an individual subject may choose to resume
    its normal form as a full-round action; doing so ends the spell for that
    subject alone. The maximum HD of an assumed form is equal to the subject’s
    HD or your caster level, whichever is lower, to a maximum of 20 HD at 20th
    level.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Need to add in quite a few polymorphs,

    Example animals:

    - Bears (Polar, Dire, Black, Brown, Kodiak)
    - Dogs (Blinkdog, Dire Wolf, Dog, Fenhound, Shadow Massif, Worg, Winter Wolf, Wolf)
    - Wolves
    - Deer (Stag and Normal)
    - Boars (Dire and Normal)
    - Bat
    - Beetle
    - Chicken
    - Cats (Leopard, Crag Cat, Tiger, Krenshar, Lion, Jaguar, Panther, Cougar, Malar Panther)
    - Falcon
    - Raven
    - Spider (Dire, Giant, Phase, Sword, Wraith) (Is it an animal?)
    - Rat (Dire, Rat)
    - Harpy
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_ANIMAL_SHAPES)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Declare effects
    effect ePolymorph;
}
