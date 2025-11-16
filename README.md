# sword-swinger

#### Info
This is a reupload of my CS50x final project, since the course repo is private and not forkable.

#### Description
A game written in lua using the love2d framework. This is my final project for Harvard's CS50x course.

#### How to run
##### On Linux
1. Install the love2d framework (using your package manager or download from https://love2d.org)
2. Download sword-swinger.love from this repository and navigate to your download directory
3. Run the game using `love sword-swinger.love`
##### On Windows
1. Download sword-swinger.exe from this repository
2. Run the executable (by double clicking/pressing enter or whatever)

##### Running from source code
1. Install the love2d framework (available at https://love2d.org)
2. Download and unzip the files in this directory
3. On Linux (and probably MacOS): navigate to the directory containing main.lua and the other files and run `love .`  
   On Windows: Using left mouse click, pull the folder containing main.lua and the other files onto love.exe or a shortcut thereof, then let go of left mouse click

#### About the project

Controls: Move with WASD, attack with arrow keys. Space to activate a special spin attack when rage is at max. Gain rage by hitting enemies. Press ESC at any time to quit the program.
Four enemy types with different behaviour exist. There are five waves of enemies to beat in order to win the game. If you run out of HP, you lose (duh).
The game is quite easy as it is now. However, it is easy to change or add stuff later.
It was quite challenging to get everything working as intended. If anyone is actually going to try this game out, have fun!

#### About the creation process
I tried to write my own code and not rely on libraries/other people's code as much as possible. The only thing I included is class.lua. I learned enough about lua metatables that I understand what class.lua does, and I could have written the program without it, but it is convenient and makes it less messy.
I also used the games50 github (specifically the zelda repo) to learn, and there are some parts in my program which are very similar or the same (such as the state machine implementation).
I made all the sprites and sounds myself. None of it is great, but ayy. I used Aseprite for making the sprites and Audacity for recording and editing the audio. I wanted to have some background music as well, but I realized making music is a whole other rabbit hole to get into. That detour would have probably delayed this project by a long time, so I decided to skip it.

Some stuff encountered while working this project:
I learned the hard way that division by zero in lua does not throw an error, but results in infinity. Took me quite long to find a bug where this was the underlying issue.
At some point I wanted to make rotated hitboxes for the spinning sword attacks. However, the AABB collision detection i wss using does not work on rotated rectangles; I would have to use the more complex SAT collision detection method instead to make it work. Because it would have taken a long time to learn and to rewrite my code, I went with using non-rotated rectangles to approximate the desired hitboxes.
I used love.keyboard.isScancodeDown instead of isKeyDown so it would work the same on any keyboard layout (like AZERTY).
I originally had 3 separate player states for idle, walk and sword attack. But later I combined them into one "normal state". The initial reason was wanting to be able to walk and attack at the same time.
I made a vector class and modified its metatable to implement vector arithmetics, allowing me to add/subtract/compare vectors using just the regular operators on them. I like that this is possible in lua.

#### Explanation of the files

**main.lua**
The starting point of the program. Loads everything else and contains important global variables.
**dependencies.lua**
Imports ("requires") all the game files and assets.  
**class.lua**
this is the implementation which allows creating classes and to simplify object oriented programming in lua. I took this from the games50 github, original author is Matthias Richter.  
**defAnimations.lua**
Defines all the animations used in the game.  
**Animation.lua**
A class used to create animations.  
**Hitbox.lua**
A class used to create hitboxes.  
**Vector.lua**
A class used to create vectors with custom arithmetic operations.  
**Bloodstain.lua**
A class used to create bloodstains, which will render for a while after an entity in the game dies.  
**Field.lua**
The game "world" (just a static area).  
**Entity.lua**
A class which all entities inherit from.  
**StateMachine.lua**
A class used to create state machines. Taken mostly from the games50 github.  
**BaseState.lua**
There to avoid defining empty methods for unused methods in states. Also from the games50 github.  
**StartState.lua**
The starting state of the game. Shows a message on how to start the game.  
**PlayState.lua**
The state the game is in when it is being played.  
**GameOverState.lua**
The state the game after losing.  
**GameWinState.lua**
The state the game after winning.  
**waves.lua**
Defines which enemies spawn where and when as the game progresses.  
**Player.lua**
A class for the player entity.  
**NormalState.lua**
The normal state of the player, in which the player can move and attack.  
**SpinAttackState.lua**
The state of the player after activating the spin special attack, which lasts for 5 seconds.  
**PushedBackState.lua**
The state of the player after taking damage from an enemy. The player will be pushed back a bit.  
**Enemy.lua**
A class that enemy entities inherit from.  
**Roach.lua**
A class for the roach enemy.  
**Goblin.lua**
A class for the goblin enemy.  
**Charger.lua**
A class for the charger enemy.  
**ChargerNormalState.lua**
The initial state of the charger enemy. Walks slowly towards the player.  
**ChargerChargingState.lua**
The state of the charger enemy when it is "charging up" his charge.  
**ChargerChargeState.lua**
The state of the charger enemy when it charging at the player.  
**ChargerRecoverState.lua**
The state of the charger enemy when it has hit a wall during its charge. Returns to normal state after.  
**Giant.lua**
A class for the giant enemy.  
**GiantNormalState.lua**
The initial state of the giant enemy. Walks around slowly.  
**GiantWindupState.lua**
The state of the giant enemy after the player moves into its attack range. Prepares for attack.  
**GiantSwingState.lua**
The attack state of the giant enemy. Swings a huge sword in a circle.  
