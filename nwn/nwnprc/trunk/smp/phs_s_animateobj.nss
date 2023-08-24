/*:://////////////////////////////////////////////
//:: Spell Name Animate Objects
//:: Spell FileName PHS_S_AnimateObj
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Brd 6, Chaos 6, Clr 6
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Targets: One Small object per caster level; see text
    Duration: 1 round/level
    Saving Throw: None
    Spell Resistance: No

    Description.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Rating: 8: need more appearances, as creatures, so maybe can animate chests
    to attack and so on. Chest already exsists for this. Might work fine.

    Placeholder script.

    What might happen:

    - Targets placables
    - If not plot, and not containing items (but can be trapped still) we check the tag
    - Depending on the tag, we destroy the placable, and replace it with a monster
      we have animated (or it failes if the tag doesn't match anything).
    - We copy the placable we destroy to a location in the spells area (yeah,
      at one point) which is then stored on the module/spells area/creature.

    - End of the duration, recopy the object back to where the new location is
      and destroy the copy of the original. This new copy will then occupy that
      spot (which might get in the way of non-PC things, so maybe a variable
      for them so monsters keep attacking the object).


    Notes:

    - Should Animated Objects still have thier hardness? Probably so (in
      a way), but have bad stats (be damage soakers). That'll mean 5DR to everything
      then, normally.
    - The AI is so basic it probably won't follow the master and just attacks
      things it "see's".
    - Added as a henchman? Or a cutscene dominated thing?
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{

}
