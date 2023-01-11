/*
Solution to the Space Transportation Kaggle Question. Submission needs to have one column for Transported and one for the outcome in True/Flase form.
*/





--74%!
Select distinct PassengerID,
	Case when HomePlanet = 'Mars' and AgeGroups = 'Child' then 'True'
    when HomePlanet = 'Mars' and AgeGroups = 'Infant' then 'True'
	when Luxury <> 0 then 'False'
	when FoodCourt = 0 and VRDeck = 0 then  'True'
	when Age = 0 then 'True'
	when Deck = 'T' then 'False'
	when Destination = 'TRAPPIST-1e' and Side = 'Port' and AgeGroups = 'YoungAdult' and VIP = 0 then 'False'
	when AgeGroups = 'Retired' and SpentOnBoard = 'Yes' then  'True'
	when Deck = 'E' then 'False'
	when Deck = 'G' and CryoSleep = 0 then  'False'
	when Deck = 'F' or Deck = 'G' then 'True'
	when cryosleep = 1 then 'True'
	else 'False'
	end as Transported
from SpaceT..test


Select distinct PassengerID,
	Case when HomePlanet = 'Mars' and AgeGroups = 'Child' then 'True'
    when HomePlanet = 'Mars' and AgeGroups = 'Infant' then 'True'
	when Luxury <> 0 then 'False'
	when FoodCourt = 0 and VRDeck = 0 then  'True'
	when Age = 0 then 'True'
	when Deck = 'T' then 'False'
	when Destination = 'TRAPPIST-1e' and Side = 'Port' and AgeGroups = 'YoungAdult' and VIP = 0 then 'False'
	when AgeGroups = 'Retired' and SpentOnBoard = 'Yes' then  'True'
	when Deck = 'E' then 'False'
	when Deck = 'G' and CryoSleep = 0 then  'False'
	when Deck = 'F' or Deck = 'G' then 'True'
	when cryosleep = 1 then 'True'
	else 'False'
	end as Transported
into #Tester9
from SpaceT..test

select Transported, count(*) 
from #tester9
group by Transported



--Data Cleaning for the Test data below:


--1. 
--Adding column GroupNum
alter table SpaceT..test
add GroupNum int;
update SpaceT..test
set GroupNum = substring(PassengerId, 1, charindex('_', PassengerId)-1)

--Adding column GroupCountTotal
alter table SpaceT..test
add GroupCountTotal int;
update SpaceT..test
set GroupCountTotal = right(PassengerId, 2)



--2.
-- Create column for Deck
Alter table SpaceT..test
Add Deck varchar(10);
Update SpaceT..test
set Deck = left(Cabin, 1);

--Creat column for Side
Alter table SpaceT..test
Add Side varchar(10);
Update SpaceT..test
set Side = right(Cabin, 1);

--Updating Side to say Port or Starboard
Update SpaceT..test
Set Side = case when Side = 'S' then 'Starboard'
	 when Side = 'P' then 'Port'
	 else NULL
	 end



--4.
--Creating own categories to group by age:
alter table SpaceT..test
add AgeGroups varchar(15);
update SpaceT..test
set AgeGroups = case when Age > 65 and Age <9999 then 'Retired'
	when Age <= 65 and Age > 50 then 'MiddleAged'
	when Age <= 50 and Age >= 40 then 'Adult'
	when Age < 40 and Age >= 22 then 'YoungAdult'
	when Age < 22 and Age >= 13 then 'Adolescent'
	when Age < 13 and Age >= 1 then 'Child'
	when Age = 0 then 'Infant'
	else NULL
	end

--Creating a second column where passengers are grouped based on 10 year age gaps.
alter table SpaceT..test
add AgesRoundedUp int;
update SpaceT..test
set AgesRoundedUp = case when  Age <> 9999 then ceiling(Age/10) * 10
else NULL 
end 


--5.
--Total Spent Column
alter table SpaceT..test
add TotalSpent int;
update SpaceT..test
set TotalSpent = coalesce(RoomService,0) + coalesce(FoodCourt,0) + coalesce(ShoppingMall,0) + coalesce(Spa,0) + coalesce(VRDeck,0)

Update SpaceT..test
Set RoomService = NULL where RoomService = 9999

Update SpaceT..test
Set FoodCourt = NULL where FoodCourt = 9999

Update SpaceT..test
Set ShoppingMall = NULL where ShoppingMall = 9999

Update SpaceT..test
Set Spa = NULL where Spa = 9999

Update SpaceT..test
Set VRDeck= NULL where VRDeck = 9999

--SpentOnBoard with Yes or No entries
alter table SpaceT..test
add SpentOnBoard varchar(10);
update SpaceT..test
set SpentOnBoard = 
	case when Totalspent = 0 then 'No'
	else 'Yes' end


--Updating NULLS
Update SpaceT..test
set FoodCourt = case when RoomService = 0 and ShoppingMall = 0 and Spa = 0 and VRDeck = 0 then 0
	else FoodCourt
	end

Update SpaceT..test
set ShoppingMall = case when RoomService = 0 and FoodCourt = 0 and Spa = 0 and VRDeck = 0 then 0
	else ShoppingMall
	end

Update SpaceT..test
set Spa = case when RoomService = 0 and FoodCourt = 0 and ShoppingMall = 0 and VRDeck = 0 then 0
	else Spa
	end

Update SpaceT..test
set VRDeck = case when RoomService = 0 and FoodCourt = 0 and ShoppingMall = 0 and Spa = 0 then 0
	else VRDeck
	end

Update SpaceT..test
set RoomService = case when VRDeck = 0 and FoodCourt = 0 and ShoppingMall = 0 and Spa = 0 then 0
	else RoomService
	end


--6.
alter table SpaceT..test
add Luxury int;
update SpaceT..test
set Luxury = coalesce(RoomService,0) + coalesce(Spa,0) + coalesce(VRDeck,0)






