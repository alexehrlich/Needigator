# Needigator
Needigator is an acronym of "needs" and "navigator". This is an application for any kind of market with listed products.
The user is able to search products and put them onto a shopping list. If a product is not available, the user is able to request it.
After selecting all the desired products this application calculates the shortest route through the supermarket to collect all the goods.
The user can watch the route on a 2D map (imaginary market) and follow the animated shopping baskets. When finsished the user is able to mark this list as a
favorite shopping list. Next time he can choose this list and start right from here.

# Purpose
This was a serious app project, which was presented to a local market. The feedback was great, but we did not get the deal, because the cooperative of this market
didn't want us to acces their product data base system - which of course is nessecary for this application.

Nevertheless I put a bunch of work in this and learned so much. Therefore I want to share it in my portfolio.

# Functionality
- Search prducts from market
- Select products with amount and add them to the shopping list
- Make product requests, when not available
- Search offers in market
- Calculate the route 
- Get a 2D map with pins at the nodes with seleced productss 
- Check the collected products at the node 
- Save the List as a favorite List with date and name
- Chose a favorite list as a starting point to plan a new shopping event

# Techniques
- CoreData
- Networking (Using API to AWS data base from team member)
- Protocols and Delegates
- TableView / ScrollView
- ImageManipulation (The route is drawn pixle per pixle)


# Algortihm
The calculation bases on the simulated annelaing algorithm which solves the travelling salesman problem (k.a. TSP).

# Showroom

Find all screenshots of the functionality in the ./Screens folder
![](./Screens/welcome.png)
![](./Screens/selectedProducts.png)
![](./Screens/search.png)
![](./Screens/list.png)
![](./Screens/routing.png)
![](./Screens/addingList.png)
