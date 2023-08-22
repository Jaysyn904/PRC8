/*:://////////////////////////////////////////////
//:: Spell Name Disintegrate : Destory NPC.
//:: Spell FileName SMP_AIL_Disinteg
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Executed from SMP_DisintegrateDamage(), using ExecuteScript after a 0.1
    second delay on any NPC who should have died.

    Only NPC's are destroyed utterly by the ray (using cutseen invsibility,
    and damage, then destruction of body).

    Objects of the NPC's are placed randomly around (if droppable).

    Only affects destroyable things. Damage is in magical. Should bypass all
    reductions. (I hope!)

    The second script does the destroying of NPCs, as it is much easier to
    ExecuteScript rather then assign command (which won't work on a dead person!)

    It will:
    - Set destroyable status (OBJECT_SELF)
    - Create a dust thingy, move inventory.
    - Destroy self.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Check if we are dead!
    if(!GetIsDead(OBJECT_SELF)) return;

    // Declare, and stop
    location lSelf = GetLocation(OBJECT_SELF);
    ClearAllActions();

    SetIsDestroyable(FALSE, FALSE, FALSE);

    // Apply cutseen invisibility
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), OBJECT_SELF);

    // We create a new dust thing
    object oDust = CreateObject(OBJECT_TYPE_PLACEABLE, "SMP_dust", lSelf);

    // Copy inventory
    object oToCopy = GetFirstItemInInventory();
    while(GetIsObjectValid(oToCopy))
    {
        // Droppable?
        if(GetDroppableFlag(oToCopy))
        {
            // + Copy vars, when copied across.
            CopyItem(oToCopy, oDust, TRUE);
            DelayCommand(0.0, DestroyObject(oToCopy));
        }
        oToCopy = GetNextItemInInventory();
    }
    // Re-destroyable
    SetIsDestroyable(TRUE, FALSE, FALSE);

    // Destroy self
    DelayCommand(0.1, DestroyObject(OBJECT_SELF));
}
