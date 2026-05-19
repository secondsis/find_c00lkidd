Adding this back in because I really don't care anymore what you think about my (maybe-haphazard) process

TODO: 

Figure out how to give client permission by server to: view a cutscene, view dialogue, get ending
Need to work on making the introduction work


Necessary Features: 
    => INTRODUCTION / CUTSCENE REVAMP

    1. Final Battle
        Figure out how to introduce Spectre in the battle
    2. Animate Christmas Scene
        Also find a place to fit it in the game
    3. NG+ Pages of Lore
        Last page activated by TV prompt. Implement the TV animation I made already for this. 
    4. c00ler Ending
        You need to make it better. Revamp ending portal
    5. Thomas Ending
    6. Mobile/PC UI Scaling
    7. Revamped Dialogue System
   
Known Bugs: 
    1. 

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
	