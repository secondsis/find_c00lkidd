Adding this back in because I really don't care anymore what you think about my (maybe-haphazard) process

TODO: 

SWAP OUT ALL TELEPORT PASSWORDS FOR NEW ONES BECAUSE THE STUFF IS ON GITHUB...
test whether the get up button works (Roblox-only)
test "easy mode" when dying to lava 2 times (Roblox-only)
test that the endings kill the boss sufficiently
test and adapt time per ending - WHY DOES IT NOT WORK
fix Bribe ending in main game?

fix when timer reaches 0 and u just barely get the trophy but dont, it bugs out for the rest of the game - honestly this is so rare i think ima leave it until its a real issue cuz idk how to fix rn


fix shedletsky trophy falling down in the b&w scene
fix the trophies not being positioned correctly in the black and white view
fix the player not walking in the way of the camera bleh controls suck

create the list of ending trophies (yeah) in minigame, / implementing the main game way of doing it

also make something happen at the end of the battle

Figure out how to give client permission by server to: view a cutscene, view dialogue, get ending

Necessary Features: 
    => CUTSCENE REVAMP
    
    1. Final Battle
        Figure out how to introduce Spectre in the battle
    2. Animate Christmas Scene
        Also find a place to fit it in the game
    3. NG+ Pages of Lore
        Last page activated by TV prompt. Implement the TV animation I made already for this. 
    4. c00ler Ending
        You need to make it better. Revamp ending portal
    6. Mobile/PC UI Scaling
    7. Revamped Dialogue System
   
Known Bugs: 
    1. Camera "rolls" when you try to rotate it in certain cutscenes
        I think this is because of AreaManager constantly trying to put the player in first person, causing the cxn to run
    2. I think the battle still continues for the current attack upon death, so some sound effects from battle can still be heard and tat no gud

Other Features: 
    1. Donation Leaderboard
    2. Evil 007e7 in mirror (mirror cracks over time as player collects endings)
        Make sky redder too
    3. Hidden Tile secret ending
    4. Tester in-game and outside game bug report form (in-game gets sent to Discord message?)
    5. Bluuworld subplace? Teleporting players to Bluuworld itself is fine I guess
    6. Random Generator
        Random stuff happens based on FUN values
    7. Backrooms ending?
    8. Lightswitches
        Also makes the game darker by default
    9. NG+ Jump item in shop
    10. Faster Countdown in Delusional scene
    11. NG+ Sprint item in shop
        Disable sprinting in normal game
    12. 

Optimizations: 
    1. Make AreaManager use .Touched or similar


Script Etiquette: 
Comment "UNUSED" in a script if it is unused
Comment "FOREVER CONNECTION" if a RBXScriptConnection is never disconnected
Comment "INEFFICIENT" for anything that is obviously badly written

Use "---" instead of "--" on top of function headers to create documentation (so you can see it upon hovering over the function)

Syntax for multi-line docs --[=[
 This can return Humanoid or nil
 @param player Player -- The player including a character
 @return Humanoid
]=]

Dialogue cmds: 
disableMovement_false
enableMovementAfter_false
enablePromptsAfter_false
fastDialogue_true -- For cutscenes, for example

Endings: (13)
McDarndolds
Rig?
Delusional
SPEEN
Escaped
Drink
Snack
Bribe
Frogs.
Cola Addiction
Shedletsky
Sleep
NileGreen


Secret Attributes:
0 = Bluuworld

007n7 color: 1d87d3


BEFORE PUBLISHING:
Anti-exploits
Delete local animation keyframes
	