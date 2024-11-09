# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* Samuel Herring 
* *email:* scherring@ucdavis.edu

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Very simple and works flawlessly.

___
### Stage 2 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Autoscroll behaves perfectly well. The player is bounded not by their contact with the wall, but by their position moving past the wall, which causes half of the player to phase through the wall. That being said, I don't think this particular detail was specified in the assignment, so it shouldn't detract from the assessment of stage 2.

___
### Stage 3 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Lerp smoothing has absolutely no problems aside from the jittering issues that seem to have been universal for everyone in this assignment. Aside from this, lerp smoothing behaves as expected. 

___
### Stage 4 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Position lead lerp smoothing not only behaves as expected, but actually avoids the jittering issue as well. 

___
### Stage 5 ###

- [ ] Perfect
- [ ] Great
- [x] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Unless I'm wrong about the requirements for stage five, the author had a misunderstanding as to what behavior was expected of the camera. The major flaw is that, rather than being pushed by the player's motion, the speedup zone acts a bit like lerp smoothing, moving the camera towards the player when they're inside it. This makes it impossible, for example, for the player to be touching the right wall but not moving right, and yet to push the camera up or down through contact with the wall. The position correction is also done in a radial fashion rather than the seperation of x and y motion I thought was expected. Lastly, the camera isn't initialized to the player's position. Again this could be my misunderstanding, but I'm pretty sure it was supposed to work differently.
___
# Code Style #

### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####

#### Style Guide Exemplars ####
I've got no issues at all with the code. Variables are named appropriately, comments are short and descriptive, and overall the code does everything it needs to do and nothing more. My one gripe is that there's a lot of old lines of commented out code left lying around, but that's not significant.

___
#### Put style guide infractures ####

___

# Best Practices #

### Description ###

If the student has followed best practices then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####

#### Best Practices Exemplars ####

Same as above. I particularly like the formatting of examples like

var in_pushbox = tpos.x < (cpos.x + pushbox_top_left.x) \
                or tpos.x > (cpos.x + pushbox_bottom_right.x) \
                or tpos.z < (cpos.z + pushbox_top_left.y) \
                or tpos.z > (cpos.z + pushbox_bottom_right.y)

which take full advantage of language features without being hard to read.