# Boomtown Railroad
***
## Task
Use the code given (Bubbles.pde) to create a game using Java and Processing.
***
## Criteria
* Use the exploding bubble game mechanic
* Create a start screen
* Implement a pause menu with "p"
* Show an ending screen that reflects player success (scoreboard)
* Add a story or theme
***
## Summary
Boomtown Railroad is a Processinng game built with  Java. The assignment was to create a game derived from the given mechanic (Bubbles.pde). The "bubbles" expand when touched by a neighboring bubble, then rapidly shrink. My adaptation was to have the bubbles generated through cursor clicks act as dynamite. The dynamite can explode tumbleweed or whiskey bubbles, which are randomly generated (within the given range) at the start of the game. The player needs to clear the tumbleweeds while avoiding the whiskey.
***
## Functionality
The player can click "space" to start the game from the start menu, "p" to pause during play, and "esc" to exit the game. On the final screen "space" will restart the game once again. The left mouse click creates TNT on the screen where the red "X" is at the time.
***
## Design
The game art was created with free assets found on itch.io and self-made images. The music is from Zitrion sound. The "wild west" theme seemed fitting for a mechanic based on explosions.

The game will setup by allocating space to asesets and building the scene. The start state displays the menu screen. States switch within an update loop to direct the player to the main game area or appropriate ending screen.
***
## Run Locally
* Load boomtown.pde into processing
* Download song library from imports
* Compile/run code
