#include "x0_i0_position"
#include "inc_constants"

/* This include has one purpose: a function which leaves behind a number from 1-8
 * when a mine tile is destroyed. The reason I put this separately is for reuse is
 * I have many grids, or at the VERY least to keep this separate visually.
 */

//Given a start location and a number between 1 and 8, CreateNumber will create a visual
//representation of a number, using dots (like dominoes) in a 1.25m radius around the
//center.
void CreateNumber(int nNumber, location lCenter);

void CreateNumber(int nNumber, location lCenter)
{
    int nGridSize = GridSize();
    string sNewTag = "Mark_" + IntToString(nGridSize) + "_NumberPoint";
    location lTargetLocation;
    float fAngle; //Hey, I can use fAngle as a control variable!

    //nNumber should be between 1 and 8, NOTHING ELSE is acceptable in a square grid.
    switch (nNumber)
    {
        /* In all the following case statements, here is the common behavior:
         *
         * nNumber is even: nNumber points created around center location
         * nNumber is odd: nNumber-1 points created around center location, and 1 point
         *                 created in the center. This is not quite like dominoes, but close
         */
        case 1: CreateObject(OBJECT_TYPE_PLACEABLE, "mark_numberpoint", lCenter, FALSE, sNewTag);

                break;

        case 2: fAngle = 45.0;
                while (fAngle < 360.0)
                {
                    lTargetLocation = GenerateNewLocationFromLocation(
                                      lCenter, 0.5, fAngle, 0.0);
                    CreateObject(OBJECT_TYPE_PLACEABLE, "mark_numberpoint", lTargetLocation, FALSE, sNewTag);
                    fAngle += 180.0;
                }

                break;

        case 3: fAngle = 45.0;
                while (fAngle < 360.0)
                {
                    lTargetLocation = GenerateNewLocationFromLocation(
                                      lCenter, 0.5, fAngle, 0.0);
                    CreateObject(OBJECT_TYPE_PLACEABLE, "mark_numberpoint", lTargetLocation, FALSE, sNewTag);
                    fAngle += 180.0;
                }
                CreateObject(OBJECT_TYPE_PLACEABLE, "mark_numberpoint", lCenter, FALSE, sNewTag);

                break;

        case 4: fAngle = 45.0;
                while (fAngle < 360.0)
                {
                    lTargetLocation = GenerateNewLocationFromLocation(
                                      lCenter, 0.5, fAngle, 0.0);
                    CreateObject(OBJECT_TYPE_PLACEABLE, "mark_numberpoint", lTargetLocation, FALSE, sNewTag);
                    fAngle += 90.0;
                }

                break;

        case 5: fAngle = 45.0;
                while (fAngle < 360.0)
                {
                    lTargetLocation = GenerateNewLocationFromLocation(
                                      lCenter, 0.5, fAngle, 0.0);
                    CreateObject(OBJECT_TYPE_PLACEABLE, "mark_numberpoint", lTargetLocation, FALSE, sNewTag);
                    fAngle += 90.0;
                }
                CreateObject(OBJECT_TYPE_PLACEABLE, "mark_numberpoint", lCenter, FALSE, sNewTag);

                break;

        case 6: fAngle = 30.0;
                while (fAngle < 360.0)
                {
                    lTargetLocation = GenerateNewLocationFromLocation(
                                      lCenter, 0.5, fAngle, 0.0);
                    CreateObject(OBJECT_TYPE_PLACEABLE, "mark_numberpoint", lTargetLocation, FALSE, sNewTag);
                    fAngle += 60.0;
                }

                break;

        case 7: fAngle = 30.0;
                while (fAngle < 360.0)
                {
                    lTargetLocation = GenerateNewLocationFromLocation(
                                      lCenter, 0.5, fAngle, 0.0);
                    CreateObject(OBJECT_TYPE_PLACEABLE, "mark_numberpoint", lTargetLocation, FALSE, sNewTag);
                    fAngle += 60.0;
                }
                CreateObject(OBJECT_TYPE_PLACEABLE, "mark_numberpoint", lCenter, FALSE, sNewTag);

                break;

        case 8: fAngle = 22.5;
                while (fAngle < 360.0)
                {
                    lTargetLocation = GenerateNewLocationFromLocation(
                                      lCenter, 0.5, fAngle, 0.0);
                    CreateObject(OBJECT_TYPE_PLACEABLE, "mark_numberpoint", lTargetLocation, FALSE, sNewTag);
                    fAngle += 45.0;
                }
                break;
        default: return;
    }
}
