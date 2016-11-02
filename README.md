# MusicRecommender

## Introduction
Build a music recommendation system, based on listening history of users for some musi-cians. 
Specifically, we know for each user a listening count for some of the artists that he listened to. 
By intuition, we know that each user cannot listen to all the artists which is an important information to take into account when training data i.e. a zero count does not mean anything. 
This will allow us to predict listening count of existing users (Weak generalization), for example artists that they didn’t listened to, but this is not sufficient to predict counts for unknown users (Strong generalization). 
For this problem, we are also given social networking information about users so we can know who is friends with who.

## Dataset
The provided dataset consists of a total of 15082 artists and 1774 users while we only have 60617 user-artist relations which is approximately 0.2% of the total number of user-artist pairs. 
Therefore, as we have noticed before a majority of potential counts are missing which is challenging since the given matrices are sparse.
