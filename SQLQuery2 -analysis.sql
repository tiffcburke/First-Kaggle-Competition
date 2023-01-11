/*
Data Analysis

*/

select * from SpaceT..train

-- 50% transported in the 'Train' dataset. 
select Transported, count(*) 
from SpaceT..train
group by Transported

--8693 Passengers on board.
select count(*)
from SpaceT..train


--If you are zero years old, you are 76% more likely to be transported.
--Adding Case when Age = 0 then 'True' in the solution.
Select Transported, AgesRoundedUp, Count(*) as vis
from SpaceT..train
group by Transported, AgesRoundedUp
order by vis desc

--More likley to be transported if you are an 'Infant',
Select Transported, AgeGroups, Count(*) as vis
from SpaceT..train
group by Transported, AgeGroups
order by vis desc

--Looking at the older age groups who were transported.
--Adding Case when AgeGroups = 'retired' and SpentOnBoard = 'yes' then 'False' to the solution.
Select AgeGroups, SpentOnBoard, count(*) CountV
from SpaceT..train
where AgeGroups = 'Retired'
and Transported = 0
group by AgeGroups, SpentOnBoard
order by SpentOnBoard

--Appears infants & children eat for free.
select AgeGroups, TotalSpent, FoodCourt, RoomService, ShoppingMall, Spa, VRDeck, GroupCountTotal
from SpaceT..train
where AgeGroups = 'Infant' 

select AgeGroups, TotalSpent, FoodCourt, RoomService, ShoppingMall, Spa, VRDeck, GroupCountTotal
from SpaceT..train
where AgeGroups <> 'Infant'  and AgeGroups <> 'Child'
and TotalSpent = 0


--Adding case when FoodCourt = 0 and VRDeck = 0 then  'True' to the solution. 67%
select Transported, count(*)
from SpaceT..train
where Foodcourt = 0 and VRDeck = 0
group by Transported

--Luxury? 2044 not transported vs 801 transported
--Case when Luxury <> 0 then 'False'
select Transported, count(*)
from SpaceT..train
where Luxury <> 0
group by Luxury, Transported

select AgeGroups, count(AgeGroups)
from SpaceT..train
where Transported = 1 and FoodCourt = 0 and VRDeck = 0
group by AgeGroups

--Why would Foodcourt values be NULL?
select * 
from SpaceT..train
where FoodCourt IS NULL

--Adding case when cryosleep = 1 then Transported = 1 to the solution.
select CryoSleep, Transported, Count(*) as countvis
from SpaceT..train
group by Transported, CryoSleep
order by countvis

--Danger decks: B, C, F, G
--Safe decks: E,
select Deck, Transported, count(*) CountVisual
from SpaceT..train
group by Deck, Transported
order by CountVisual desc

-- No correltion here. Transportation came from both sides.
select Side, Transported, count(*) CountVisual
from SpaceT..train
group by Side, Transported
order by CountVisual desc

--Which G's were not transported and why?
--G's in cryosleep were not transported.
Select AgeGroups, Count(*) CountVisual
from SpaceT..train
where Deck = 'G' and Transported = 1
group by AgeGroups
order by CountVisual

--Adding Case when Deck = 'G' and CryoSleep = 0 then 'False' to the solution.
select CryoSleep, count(*) as CountV
from SpaceT..train
where Deck = 'G' and Transported = 1
group by CryoSleep

select CryoSleep, count(*) as CountV
from SpaceT..train
where Deck = 'F' and Transported = 1
group by CryoSleep

--8693 passengers in CryoSleep.
select count(cryosleep)
from SpaceT..train


--Adding case when HomePlanet = 'Mars' and Transported = 1 and AgeGroups = 'Child' then 'True' to the solution.
--Adding case when HomePlanet = 'Mars' and Transported = 1 and AgeGroups = 'Infant' then 'True' to the solution.
select count(*)
from SpaceT..train
where HomePlanet = 'Mars' and Transported = 1
and AgeGroups = 'Child'


--Reviewing the above analysis, we have a lot of Transported = 'True'. Let's look into where Transported = 'False'
select * from SpaceT..train
where Transported = 0

--Adding case when Deck = T then 'False' to the solution.
select Deck, count(*) as CountV
from SpaceT..train
where Transported = 1
group by Deck
order by CountV


--Adding case when Destination = 'TRAPPIST-1e' and Side = 'Port' and AgeGroups = 'YoungAdult' and VIP = 0 then 'False' to the solution.
select Transported, count(*)
from SpaceT..train
where Destination = 'TRAPPIST-1e' and Side = 'Port' and AgeGroups = 'YoungAdult' and VIP = 0
group by Transported


