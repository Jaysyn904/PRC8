/*
31/01/21 by Stratovarius

Psion's Eyes
Descriptor: None
Classes: Incarnate
Chakra: Brow
Saving Throw: None

You shape incarnum into blue-green lensed spectacles. While perched on your nose, these spectacles give you peculiar visual acuity, heightening your sensitivity to psychic details while granting you insight into the meaning and significance of those details.

With this soulmeld, you summon forth soul energy from generations of psions to grant you acuity and psychic aptitude.

While you wear the psion's eyes, you gain a +4 insight bonus on Concentration, Psicraft, and Use Magical Device checks.

Essentia: Every point of essentia you invest in your psion's eyes increases the insight bonus granted by +2.

Chakra Bind (Brow)

Instead of spectacles perched on your nose, your psion's eyes appear as a third eye embedded in your forehead, and its iris glows a rich azure blue.

You can use the call to mind power at will for the duration of this soulmeld.
*/

#include "moi_inc_moifunc"
#include "psi_inc_psifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF; 

	UsePower(POWER_CALLTOMIND, CLASS_TYPE_PSION, TRUE, GetMeldshaperLevel(oMeldshaper, GetPrimaryIncarnumClass(oMeldshaper), MELD_PSIONS_EYES));
}