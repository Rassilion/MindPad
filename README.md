# MindPad
## Introduction
The topic of this project is a mental exercise game, involving solving basic arithmetic problems. CoreML is used to recognize the drawn answers of the user.

## Description
The user first chooses a game mode. These modes are:

-	Normal: A specific number of questions without any time limits. Score is based on the difficulty of questions whose answers are correct, and total time elapsed.
-	Survival: The game goes on until the user inputs an incorrect answer. Score is based on the total number of questions answered and total time elapsed.
-	Time Attack: The user must answer as many questions as possible in a specific time limit. The score is the number of correct answers.

For each question, the app generates an arithmetic operation (addition, subtraction, multiplication, division) and two operands. The difficulty of the question is the size of the operands (or, to be precise, the number of digits in the result). One of the digits in the result is concealed. The player must calculate this digit and write it on the canvas on the screen. This answer is converted to an integer value using CoreML, and checked if correct. The answer is graded, and the game proceeds in accordance to the mode selected.
When the game ends, the score and the total time (not in Time Attack) is displayed, and the player is prompted to play again.

## Scenes
Excluding the splash screen, there are four main scenes in the application.

### Main Menu
This is the first scene the user sees. Each game mode has a button, all followed by the button for the Highscores scene.

<p align="center">
<img src="screens/Simulator%20Screen%20Shot%20-%20iPhone%208%20Plus%20-%202018-01-02%20at%2019.08.05.png?raw=true" width="300">
</p>
 
### Game Scene
This is the scene in which gameplay occurs. In the top bar, the player’s accumulated score is displayed. In the upper half, the question is presented in an easily visible style. The drawing canvas exists in the lower half, right below the CoreML prediction. Buttons for clearing the canvas and submitting the answer are also here. The Submit button is disabled by default, and whenever the canvas is cleared. It is enabled only when the player draws on the canvas.

At the bottom of the screen, the total time is displayed. Normally, this display counts up, but in Time Attack, it counts down from 150 seconds.

When the player draws, the canvas is dynamically converted to a 28 by 28 image, which is analyzed with CoreML to convert the drawing to a digit. This digit is displayed on the screen as the user draws, so that they know what answer they’ll be submitting at any time.

<p align="center">
<img src="screens/Simulator%20Screen%20Shot%20-%20iPhone%208%20Plus%20-%202018-01-02%20at%2019.08.55.png?raw=true" width="300">
</p>

### Results Scene
This is where the player sees their performance. The accumulated score and total time are displayed. Total time is omitted if the mode was Time Attack, since it is always 150 seconds.

Here, the player can choose to play the same mode again, share their results on Facebook or go back to the main menu.

<p align="center">
<img src="screens/Simulator%20Screen%20Shot%20-%20iPhone%208%20Plus%20-%202018-01-02%20at%2019.09.43.png?raw=true" width="300">
</p>

### Highscores Scene
Here, the past highscores of the player can be seen, which are stored in UserDefaults. A reset button at the top of the screen can be used to revert these values to 0.

<p align="center">
<img src="screens/Simulator%20Screen%20Shot%20-%20iPhone%208%20Plus%20-%202018-01-02%20at%2019.09.52.png?raw=true" width="300">
</p>
