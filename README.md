[![Build Status](https://travis-ci.org/NikantVohra/TouristHelper.svg)](https://travis-ci.org/NikantVohra/TouristHelper)

# TouristHelper
App to help tourists find sights to see wherever they may be.The App presents a maximum of 100 places of interest around the user's current location and displays a path connecting all these places. The user has an option of choosing a different location and filtering places on the basis of various types. 

![](Screenshot.png?raw=true)
 
 # Algorithm Used
This app tries to solve the classic [Travelling Salesman Problem](https://simple.wikipedia.org/wiki/Travelling_salesman_problem) by using an approximation algorithm called the [Greedy Nearest Neighbour for all starting places]((https://web.archive.org/web/20131202232743/http://nbviewer.ipython.org/url/norvig.com/ipython/TSPv3.ipynb)) which gives a solution usually within 10 or 20% of the shortest possible and can handle thousands of cities. 
 
 # Instructions for app installation
 1. Clone the repository.
 2. Run pod install inside the repository.
 3. Open TouristHelper.xcworkspace.
 4. Run or test various scenarios. 
