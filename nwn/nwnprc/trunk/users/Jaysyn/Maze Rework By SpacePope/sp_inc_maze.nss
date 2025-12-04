//::///////////////////////////////////////////////
//:: Maze Generation Include
//:: sp_inc_maze.nss
//:://////////////////////////////////////////////
/*
    Procedural maze generation system for the Maze spell.
    Uses native SetTileJson() to create randomized maze areas
    based on the tcd01 (Classic Dungeon) tileset.
*/
//:://////////////////////////////////////////////

#include "nwnx_object"
// ============================================================================
// CONSTANTS
// ============================================================================

// Maze dimensions (in tiles) - 16x16 area
const int MAZE_WIDTH  = 16;
const int MAZE_HEIGHT = 16;

// Tileset used for maze
const string MAZE_TILESET = "tcd01"; // Classic Dungeon

// Base area resref
const string MAZE_BASE_RESREF = "SpellMaze";

// Direction flags for cell walls
const int MAZE_WALL_NORTH = 1;
const int MAZE_WALL_EAST  = 2;
const int MAZE_WALL_SOUTH = 4;
const int MAZE_WALL_WEST  = 8;
const int MAZE_ALL_WALLS  = 15; // All walls present

// Direction offsets
const int DIR_NORTH = 0;
const int DIR_EAST  = 1;
const int DIR_SOUTH = 2;
const int DIR_WEST  = 3;

// tcd01 Tile IDs for corridor tiles (G series)
// These are corridor tiles that create walled passages through wall terrain
// Reference: tcd01.set file
const int TILE_CORRIDOR_CORNER   = 12;  // g01 - Corner: Bottom=Corridor, Left=Corridor (SW corner)
const int TILE_CORRIDOR_STRAIGHT = 13;  // g02 - Straight: Top=Corridor, Bottom=Corridor (N-S)
const int TILE_CORRIDOR_TJUNCT   = 14;  // g03 - T-junction: Top/Bottom/Left=Corridor (wall on East)
const int TILE_CORRIDOR_CROSS    = 15;  // g04 - Crossroads: all sides=Corridor
const int TILE_CORRIDOR_DEADEND  = 16;  // g05 - Dead-end: Top=Corridor only (opens North)
const int TILE_SOLID_WALL        = 5;   // a10 - Solid wall tile (no passages)

// Debug print to the server log
void Maze_DebugPrint(json jMaze);

// ============================================================================
// MAZE DATA STRUCTURE
// ============================================================================

// Store maze data as a JSON array of integers (wall flags for each cell)
// Index = y * MAZE_WIDTH + x

// Get the index for a cell at (x, y)
int Maze_GetCellIndex(int x, int y)
{
    return y * MAZE_WIDTH + x;
}

// Check if coordinates are valid
int Maze_IsValidCell(int x, int y)
{
    return (x >= 0 && x < MAZE_WIDTH && y >= 0 && y < MAZE_HEIGHT);
}

// Get wall flags for a cell
int Maze_GetCellWalls(json jMaze, int x, int y)
{
    if (!Maze_IsValidCell(x, y)) return MAZE_ALL_WALLS;
    int nIndex = Maze_GetCellIndex(x, y);
    return JsonGetInt(JsonArrayGet(jMaze, nIndex));
}

// Set wall flags for a cell
json Maze_SetCellWalls(json jMaze, int x, int y, int nWalls)
{
    if (!Maze_IsValidCell(x, y)) return jMaze;
    int nIndex = Maze_GetCellIndex(x, y);
    return JsonArraySet(jMaze, nIndex, JsonInt(nWalls));
}

// Check if a cell has been visited (has any wall removed)
int Maze_IsCellVisited(json jMaze, int x, int y)
{
    return Maze_GetCellWalls(jMaze, x, y) != MAZE_ALL_WALLS;
}

// ============================================================================
// MAZE GENERATION (Recursive Backtracking - Iterative)
// ============================================================================

// Get opposite direction
int Maze_GetOppositeDir(int nDir)
{
    switch (nDir)
    {
        case DIR_NORTH: return DIR_SOUTH;
        case DIR_EAST:  return DIR_WEST;
        case DIR_SOUTH: return DIR_NORTH;
        case DIR_WEST:  return DIR_EAST;
    }
    return DIR_NORTH;
}

// Get wall flag for a direction
int Maze_GetWallFlag(int nDir)
{
    switch (nDir)
    {
        case DIR_NORTH: return MAZE_WALL_NORTH;
        case DIR_EAST:  return MAZE_WALL_EAST;
        case DIR_SOUTH: return MAZE_WALL_SOUTH;
        case DIR_WEST:  return MAZE_WALL_WEST;
    }
    return 0;
}

// Get neighbor coordinates for a direction
int Maze_GetNeighborX(int x, int nDir)
{
    if (nDir == DIR_EAST)  return x + 1;
    if (nDir == DIR_WEST)  return x - 1;
    return x;
}

int Maze_GetNeighborY(int y, int nDir)
{
    if (nDir == DIR_NORTH) return y + 1;
    if (nDir == DIR_SOUTH) return y - 1;
    return y;
}

// Remove wall between two adjacent cells
json Maze_RemoveWall(json jMaze, int x1, int y1, int nDir)
{
    int x2 = Maze_GetNeighborX(x1, nDir);
    int y2 = Maze_GetNeighborY(y1, nDir);

    if (!Maze_IsValidCell(x2, y2)) return jMaze;

    // Remove wall from first cell
    int nWalls1 = Maze_GetCellWalls(jMaze, x1, y1);
    nWalls1 = nWalls1 & ~Maze_GetWallFlag(nDir);
    jMaze = Maze_SetCellWalls(jMaze, x1, y1, nWalls1);

    // Remove opposite wall from second cell
    int nWalls2 = Maze_GetCellWalls(jMaze, x2, y2);
    nWalls2 = nWalls2 & ~Maze_GetWallFlag(Maze_GetOppositeDir(nDir));
    jMaze = Maze_SetCellWalls(jMaze, x2, y2, nWalls2);

    return jMaze;
}

// Shuffle an array of 4 directions randomly
json Maze_ShuffleDirections()
{
    json jDirs = JsonArray();
    jDirs = JsonArrayInsert(jDirs, JsonInt(DIR_NORTH));
    jDirs = JsonArrayInsert(jDirs, JsonInt(DIR_EAST));
    jDirs = JsonArrayInsert(jDirs, JsonInt(DIR_SOUTH));
    jDirs = JsonArrayInsert(jDirs, JsonInt(DIR_WEST));

    // Fisher-Yates shuffle
    int i;
    for (i = 3; i > 0; i--)
    {
        int j = Random(i + 1);
        json jTemp = JsonArrayGet(jDirs, i);
        jDirs = JsonArraySet(jDirs, i, JsonArrayGet(jDirs, j));
        jDirs = JsonArraySet(jDirs, j, jTemp);
    }
    return jDirs;
}

// Get unvisited neighbors of a cell
json Maze_GetUnvisitedNeighbors(json jMaze, int x, int y)
{
    json jNeighbors = JsonArray();

    int nDir;
    for (nDir = 0; nDir < 4; nDir++)
    {
        int nx = Maze_GetNeighborX(x, nDir);
        int ny = Maze_GetNeighborY(y, nDir);

        if (Maze_IsValidCell(nx, ny) && !Maze_IsCellVisited(jMaze, nx, ny))
        {
            // Store as packed int: dir * 1000 + ny * 100 + nx
            // (simple encoding since we can't store structs)
            jNeighbors = JsonArrayInsert(jNeighbors, JsonInt(nDir * 10000 + ny * 100 + nx));
        }
    }

    return jNeighbors;
}

// Initialize maze with all walls
json Maze_Initialize()
{
    json jMaze = JsonArray();
    int i;
    for (i = 0; i < MAZE_WIDTH * MAZE_HEIGHT; i++)
    {
        jMaze = JsonArrayInsert(jMaze, JsonInt(MAZE_ALL_WALLS));
    }
    return jMaze;
}

// Check if a cell is a dead-end (only one opening)
int Maze_IsDeadEnd(json jMaze, int x, int y)
{
    int nWalls = Maze_GetCellWalls(jMaze, x, y);
    int nOpenN = !(nWalls & MAZE_WALL_NORTH);
    int nOpenE = !(nWalls & MAZE_WALL_EAST);
    int nOpenS = !(nWalls & MAZE_WALL_SOUTH);
    int nOpenW = !(nWalls & MAZE_WALL_WEST);
    return (nOpenN + nOpenE + nOpenS + nOpenW) == 1;
}

// Get directions to valid neighbors that have a wall between them (potential new passages)
json Maze_GetWalledNeighbors(json jMaze, int x, int y)
{
    json jNeighbors = JsonArray();
    int nWalls = Maze_GetCellWalls(jMaze, x, y);

    int nDir;
    for (nDir = 0; nDir < 4; nDir++)
    {
        int nx = Maze_GetNeighborX(x, nDir);
        int ny = Maze_GetNeighborY(y, nDir);

        // Check if there's still a wall in this direction AND neighbor is valid
        if (Maze_IsValidCell(nx, ny) && (nWalls & Maze_GetWallFlag(nDir)))
        {
            jNeighbors = JsonArrayInsert(jNeighbors, JsonInt(nDir));
        }
    }
    return jNeighbors;
}

// Add extra passages to reduce dead-ends and create more branching
// nBraidPercent: percentage of dead-ends to connect (0-100)
json Maze_AddBranching(json jMaze, int nBraidPercent)
{
    int x, y;

    // First pass: identify and potentially connect dead-ends (braiding)
    for (y = 0; y < MAZE_HEIGHT; y++)
    {
        for (x = 0; x < MAZE_WIDTH; x++)
        {
            if (Maze_IsDeadEnd(jMaze, x, y))
            {
                // Randomly decide whether to remove this dead-end
                if (Random(100) < nBraidPercent)
                {
                    // Get directions where there's still a wall
                    json jWalled = Maze_GetWalledNeighbors(jMaze, x, y);
                    int nCount = JsonGetLength(jWalled);

                    if (nCount > 0)
                    {
                        // Pick a random walled direction and remove it
                        int nRandIdx = Random(nCount);
                        int nDir = JsonGetInt(JsonArrayGet(jWalled, nRandIdx));
                        jMaze = Maze_RemoveWall(jMaze, x, y, nDir);
                    }
                }
            }
        }
    }

    return jMaze;
}

// Add random extra connections throughout the maze for more variety
// nExtraPercent: percentage chance per cell to add an extra connection
json Maze_AddRandomConnections(json jMaze, int nExtraPercent)
{
    int x, y;

    for (y = 0; y < MAZE_HEIGHT; y++)
    {
        for (x = 0; x < MAZE_WIDTH; x++)
        {
            if (Random(100) < nExtraPercent)
            {
                // Get directions where there's still a wall
                json jWalled = Maze_GetWalledNeighbors(jMaze, x, y);
                int nCount = JsonGetLength(jWalled);

                if (nCount > 0)
                {
                    // Pick a random walled direction and remove it
                    int nRandIdx = Random(nCount);
                    int nDir = JsonGetInt(JsonArrayGet(jWalled, nRandIdx));
                    jMaze = Maze_RemoveWall(jMaze, x, y, nDir);
                }
            }
        }
    }

    return jMaze;
}

// Generate a random maze using iterative backtracking
// Starts from top-left corner to ensure full maze coverage
// Returns: JSON array of wall flags for each cell
json Maze_Generate()
{
    json jMaze = Maze_Initialize();

    // Start from top-left corner (x=0, y=MAZE_HEIGHT-1) to ensure full coverage
    int nStartX = 0;
    int nStartY = MAZE_HEIGHT - 1;

    // Use a JSON array as a stack (stores packed x,y coords)
    json jStack = JsonArray();
    jStack = JsonArrayInsert(jStack, JsonInt(nStartY * 100 + nStartX));

    // For the start cell, we need to mark it visited without removing a wall
    // We'll do this by proceeding directly to carving
    jMaze = Maze_SetCellWalls(jMaze, nStartX, nStartY, MAZE_ALL_WALLS - 16); // Use bit 16 as visited marker

    while (JsonGetLength(jStack) > 0)
    {
        // Pop current cell from stack
        int nStackLen = JsonGetLength(jStack);
        int nPacked = JsonGetInt(JsonArrayGet(jStack, nStackLen - 1));
        jStack = JsonArrayDel(jStack, nStackLen - 1);

        int nCurX = nPacked % 100;
        int nCurY = nPacked / 100;

        // Get unvisited neighbors (cells with all walls intact)
        json jNeighbors = JsonArray();
        json jDirs = Maze_ShuffleDirections();

        int i;
        for (i = 0; i < 4; i++)
        {
            int nDir = JsonGetInt(JsonArrayGet(jDirs, i));
            int nx = Maze_GetNeighborX(nCurX, nDir);
            int ny = Maze_GetNeighborY(nCurY, nDir);

            if (Maze_IsValidCell(nx, ny))
            {
                int nWalls = Maze_GetCellWalls(jMaze, nx, ny);
                // Check if truly unvisited (all 4 walls still present, no visit marker)
                if (nWalls == MAZE_ALL_WALLS)
                {
                    jNeighbors = JsonArrayInsert(jNeighbors, JsonInt(nDir * 10000 + ny * 100 + nx));
                }
            }
        }

        // If there are unvisited neighbors
        if (JsonGetLength(jNeighbors) > 0)
        {
            // Push current cell back to stack
            jStack = JsonArrayInsert(jStack, JsonInt(nCurY * 100 + nCurX));

            // Pick a random unvisited neighbor
            int nRandIdx = Random(JsonGetLength(jNeighbors));
            int nNeighborPacked = JsonGetInt(JsonArrayGet(jNeighbors, nRandIdx));

            int nDir = nNeighborPacked / 10000;
            int nNextY = (nNeighborPacked % 10000) / 100;
            int nNextX = nNeighborPacked % 100;

            // Remove wall between current and chosen neighbor
            jMaze = Maze_RemoveWall(jMaze, nCurX, nCurY, nDir);

            // Push neighbor to stack
            jStack = JsonArrayInsert(jStack, JsonInt(nNextY * 100 + nNextX));
        }
    }

    // Clean up visit markers - convert back to proper wall flags
    int x, y;
    for (y = 0; y < MAZE_HEIGHT; y++)
    {
        for (x = 0; x < MAZE_WIDTH; x++)
        {
            int nWalls = Maze_GetCellWalls(jMaze, x, y);
            // Remove the visit marker bit if present, keep only wall bits
            jMaze = Maze_SetCellWalls(jMaze, x, y, nWalls & MAZE_ALL_WALLS);
        }
    }

    // Post-processing: Add more branching paths
    // 1. Remove ~35% of dead-ends to create more T-junctions
    jMaze = Maze_AddBranching(jMaze, 35);

    // 2. Add ~5% random extra connections for variety
    jMaze = Maze_AddRandomConnections(jMaze, 5);

    return jMaze;
}

// ============================================================================
// TILE MAPPING
// ============================================================================

// Determine tile ID and orientation based on wall configuration
// Returns: packed value (orientation * 1000 + tileID)
//
// tcd01 corridor tile base orientations (orientation 0):
// - Dead-end (g05): Opens NORTH (Top=Corridor)
// - Straight (g02): Opens North-South (Top/Bottom=Corridor)
// - Corner (g01): Opens South and West (Bottom/Left=Corridor) = SW corner
// - T-junction (g03): Wall on East, opens N/S/W (Top/Bottom/Left=Corridor)
// - Crossroads (g04): Opens all directions
//
// NWN tile rotation is COUNTER-CLOCKWISE:
// Orientation 0 = 0°, 1 = 90° CCW, 2 = 180°, 3 = 270° CCW
int Maze_GetTileForWalls(int nWalls)
{
    // Count open sides (walls not present)
    int nOpenN = !(nWalls & MAZE_WALL_NORTH);
    int nOpenE = !(nWalls & MAZE_WALL_EAST);
    int nOpenS = !(nWalls & MAZE_WALL_SOUTH);
    int nOpenW = !(nWalls & MAZE_WALL_WEST);
    int nOpenCount = nOpenN + nOpenE + nOpenS + nOpenW;

    int nTileID = 0;
    int nOrientation = 0;

    switch (nOpenCount)
    {
        case 0:
            // Solid wall tile (no passages)
            nTileID = TILE_SOLID_WALL;
            nOrientation = 0;
            break;

        case 1:
            // Dead end - one opening
            // Base (orientation 0) opens NORTH
            // CCW rotation: N -> W -> S -> E
            nTileID = TILE_CORRIDOR_DEADEND;
            if (nOpenN) nOrientation = 0;       // Opens North = default
            else if (nOpenW) nOrientation = 1;  // Opens West = 90° CCW
            else if (nOpenS) nOrientation = 2;  // Opens South = 180°
            else nOrientation = 3;              // Opens East = 270° CCW
            break;

        case 2:
            // Corridor or corner
            if ((nOpenN && nOpenS) || (nOpenE && nOpenW))
            {
                // Straight corridor
                // Base (orientation 0) opens North-South
                nTileID = TILE_CORRIDOR_STRAIGHT;
                nOrientation = (nOpenN && nOpenS) ? 0 : 1;  // 0=N-S, 1=E-W (90° CCW)
            }
            else
            {
                // Corner - two adjacent openings
                // Base (orientation 0) opens South and West (SW corner)
                // CCW rotation: SW -> SE -> NE -> NW
                nTileID = TILE_CORRIDOR_CORNER;
                if (nOpenS && nOpenW) nOrientation = 0;      // SW corner = default
                else if (nOpenS && nOpenE) nOrientation = 1; // SE corner = 90° CCW
                else if (nOpenN && nOpenE) nOrientation = 2; // NE corner = 180°
                else nOrientation = 3;                        // NW corner = 270° CCW
            }
            break;

        case 3:
            // T-junction - one wall (three openings)
            // Base (orientation 0) has wall on EAST (opens N/S/W)
            // CCW rotation: wall-E -> wall-N -> wall-W -> wall-S
            nTileID = TILE_CORRIDOR_TJUNCT;
            if (!nOpenE) nOrientation = 0;      // Wall on East = default
            else if (!nOpenN) nOrientation = 1; // Wall on North = 90° CCW
            else if (!nOpenW) nOrientation = 2; // Wall on West = 180°
            else nOrientation = 3;              // Wall on South = 270° CCW
            break;

        case 4:
            // Crossroads - no walls (four openings)
            nTileID = TILE_CORRIDOR_CROSS;
            nOrientation = 0;
            break;
    }

    return nOrientation * 1000 + nTileID;
}

// ============================================================================
// NATIVE SETTILE INTEGRATION
// ============================================================================

// Build JSON tile data array for SetTileJson from maze data
json Maze_BuildTileDataJson(json jMaze)
{
    json jTileData = JsonArray();

    int x, y;
    for (y = 0; y < MAZE_HEIGHT; y++)
    {
        for (x = 0; x < MAZE_WIDTH; x++)
        {
            int nWalls = Maze_GetCellWalls(jMaze, x, y);
            int nTileInfo = Maze_GetTileForWalls(nWalls);

            int nTileID = nTileInfo % 1000;
            int nOrientation = nTileInfo / 1000;

            int nIndex = Maze_GetCellIndex(x, y);

            // Build tile object for SetTileJson
            json jTile = JsonObject();
            jTile = JsonObjectSet(jTile, "index", JsonInt(nIndex));
            jTile = JsonObjectSet(jTile, "tileid", JsonInt(nTileID));
            jTile = JsonObjectSet(jTile, "orientation", JsonInt(nOrientation));
            jTile = JsonObjectSet(jTile, "height", JsonInt(0));
            jTile = JsonObjectSet(jTile, "animloop1", JsonInt(1));
            jTile = JsonObjectSet(jTile, "animloop2", JsonInt(1));
            jTile = JsonObjectSet(jTile, "animloop3", JsonInt(1));

            jTileData = JsonArrayInsert(jTileData, jTile);
        }
    }

    return jTileData;
}

// Apply maze tiles to an existing area using native SetTileJson
void Maze_ApplyTilesToArea(object oArea, json jMaze)
{
    json jTileData = Maze_BuildTileDataJson(jMaze);

    // Use native SetTileJson to update all tiles at once
    SetTileJson(oArea, jTileData);
}

// Create a randomized maze area for a target
// Returns: The created area object, or OBJECT_INVALID on failure
object Maze_CreateRandomArea(object oTarget, string sBaseAreaResRef = "SpellMaze")
{
    // Generate random maze
    json jMaze = Maze_Generate();

    // Create the area instance first
    string sTag = "MAZE_" + IntToString(d100()) + "_" + IntToString(GetTimeSecond());
    string sName = "The Maze";
    object oMazeArea = CreateArea(sBaseAreaResRef, sTag, sName);

    if (!GetIsObjectValid(oMazeArea))
    {
        WriteTimestampedLogEntry("ERROR: MAZE - Failed to create area from resref: " + sBaseAreaResRef);
        return OBJECT_INVALID;
    }

    // Apply the randomized maze tiles to the area
    Maze_ApplyTilesToArea(oMazeArea, jMaze);

    // Debug: Print maze structure to server log
    Maze_DebugPrint(jMaze);

    // Store maze data on area for potential later use
    SetLocalJson(oMazeArea, "MazeData", jMaze);
    SetLocalObject(oMazeArea, "MazeTarget", oTarget);

    // Define five possible spawn/exit locations:
    // 0: Top-left corner (0, MAZE_HEIGHT-1)
    // 1: Top-right corner (MAZE_WIDTH-1, MAZE_HEIGHT-1)
    // 2: Bottom-left corner (0, 0)
    // 3: Bottom-right corner (MAZE_WIDTH-1, 0)
    // 4: Center (MAZE_WIDTH/2, MAZE_HEIGHT/2)

    // Randomly choose spawn location (0-4)
    int nSpawnLoc = Random(5);
    int nStartX, nStartY;

    switch (nSpawnLoc)
    {
        case 0: // Top-left
            nStartX = 0;
            nStartY = MAZE_HEIGHT - 1;
            break;
        case 1: // Top-right
            nStartX = MAZE_WIDTH - 1;
            nStartY = MAZE_HEIGHT - 1;
            break;
        case 2: // Bottom-left
            nStartX = 0;
            nStartY = 0;
            break;
        case 3: // Bottom-right
            nStartX = MAZE_WIDTH - 1;
            nStartY = 0;
            break;
        default: // Center
            nStartX = MAZE_WIDTH / 2;
            nStartY = MAZE_HEIGHT / 2;
            break;
    }

    // Store start position
    SetLocalInt(oMazeArea, "MazeStartX", nStartX);
    SetLocalInt(oMazeArea, "MazeStartY", nStartY);

    // Exit goes in one of the other four locations (randomly chosen)
    // Pick a random offset (1-4) and add to spawn location, mod 5
    int nExitOffset = Random(4) + 1;  // 1, 2, 3, or 4
    int nExitLoc = (nSpawnLoc + nExitOffset) % 5;
    int nExitX, nExitY;

    switch (nExitLoc)
    {
        case 0: // Top-left
            nExitX = 0;
            nExitY = MAZE_HEIGHT - 1;
            break;
        case 1: // Top-right
            nExitX = MAZE_WIDTH - 1;
            nExitY = MAZE_HEIGHT - 1;
            break;
        case 2: // Bottom-left
            nExitX = 0;
            nExitY = 0;
            break;
        case 3: // Bottom-right
            nExitX = MAZE_WIDTH - 1;
            nExitY = 0;
            break;
        default: // Center
            nExitX = MAZE_WIDTH / 2;
            nExitY = MAZE_HEIGHT / 2;
            break;
    }

    SetLocalInt(oMazeArea, "MazeExitX", nExitX);
    SetLocalInt(oMazeArea, "MazeExitY", nExitY);

    // Destroy any existing exit portal in the new area
    object oOldExit = GetObjectByTag("MazeEXIT");
    if (GetIsObjectValid(oOldExit) && GetArea(oOldExit) == oMazeArea)
    {
        DestroyObject(oOldExit);
    }

    // Create new exit portal at the chosen corner
    float fExitX = (IntToFloat(nExitX) + 0.5) * 10.0;
    float fExitY = (IntToFloat(nExitY) + 0.5) * 10.0;
    location lExit = Location(oMazeArea, Vector(fExitX, fExitY, 0.0), 0.0);

    // Create a waypoint for the map pin
    object oExitWaypoint = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", lExit, FALSE, "MazeExitWP");
    if (GetIsObjectValid(oExitWaypoint))
    {
        NWNX_Object_SetMapNote(oExitWaypoint, "Maze Exit");
        SetMapPinEnabled(oExitWaypoint, TRUE);
        SetName(oExitWaypoint, "Maze Exit");
    }

    // Create the exit portal placeable
    object oExitPortal = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_portal", lExit, FALSE, "MazeEXIT");
    if (GetIsObjectValid(oExitPortal))
    {
        SetEventScript(oExitPortal, EVENT_SCRIPT_PLACEABLE_ON_USED, "cd_maze_ext");
        SetUseableFlag(oExitPortal, TRUE);
        SetPlotFlag(oExitPortal, TRUE);
        SetName(oExitPortal, "Maze Exit");
    }

    // Wipe exploration data for the target
    DelayCommand(2.0, ExploreAreaForPlayer(oMazeArea, oTarget, FALSE));
    return oMazeArea;
}

// Get the spawn location within a maze area
location Maze_GetSpawnLocation(object oMazeArea)
{
    int nStartX = GetLocalInt(oMazeArea, "MazeStartX");
    int nStartY = GetLocalInt(oMazeArea, "MazeStartY");

    // Convert tile coords to world coords (each tile is 10.0 units, spawn in center)
    float fX = (IntToFloat(nStartX) + 0.5) * 10.0;
    float fY = (IntToFloat(nStartY) + 0.5) * 10.0;
    float fZ = 0.0;

    return Location(oMazeArea, Vector(fX, fY, fZ), 0.0);
}

// Clean up a maze area
void Maze_DestroyArea(object oMazeArea)
{
    if (!GetIsObjectValid(oMazeArea)) return;

    string sTag = GetTag(oMazeArea);

    // Destroy the area
    DestroyArea(oMazeArea);
}

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

// Debug: Print maze to server log
void Maze_DebugPrint(json jMaze)
{
    string sLine;
    int x, y;

    WriteTimestampedLogEntry("=== MAZE DEBUG ===");
    for (y = MAZE_HEIGHT - 1; y >= 0; y--)
    {
        // Print top walls
        sLine = "";
        for (x = 0; x < MAZE_WIDTH; x++)
        {
            int nWalls = Maze_GetCellWalls(jMaze, x, y);
            sLine += "+";
            sLine += (nWalls & MAZE_WALL_NORTH) ? "---" : "   ";
        }
        sLine += "+";
        WriteTimestampedLogEntry(sLine);

        // Print side walls and cell
        sLine = "";
        for (x = 0; x < MAZE_WIDTH; x++)
        {
            int nWalls = Maze_GetCellWalls(jMaze, x, y);
            sLine += (nWalls & MAZE_WALL_WEST) ? "|" : " ";
            sLine += "   ";
        }
        // East wall of last cell
        int nLastWalls = Maze_GetCellWalls(jMaze, MAZE_WIDTH - 1, y);
        sLine += (nLastWalls & MAZE_WALL_EAST) ? "|" : " ";
        WriteTimestampedLogEntry(sLine);
    }

    // Print bottom walls of bottom row
    sLine = "";
    for (x = 0; x < MAZE_WIDTH; x++)
    {
        int nWalls = Maze_GetCellWalls(jMaze, x, 0);
        sLine += "+";
        sLine += (nWalls & MAZE_WALL_SOUTH) ? "---" : "   ";
    }
    sLine += "+";
    WriteTimestampedLogEntry(sLine);
    WriteTimestampedLogEntry("==================");
}
