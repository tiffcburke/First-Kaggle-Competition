/*
Cleaning the data from the Space train excel sheet.

*/

--1. 
--Create two separate columns from the PassengerId column. 
--The GroupNum (first 4 numbers) - number assigned to each group.
--GroupCountTotal (Last two numbers) - this is total people per group.

--Adding column GroupNum
alter table SpaceT..train
add GroupNum int;
update SpaceT..train
set GroupNum = substring(PassengerId, 1, charindex('_', PassengerId)-1)

--Adding column GroupCountTotal
alter table SpaceT..train
add GroupCountTotal int;
update SpaceT..train
set GroupCountTotal = right(PassengerId, 2)


--2.
--Cabin column is made up of Deck/ Number / Ship Side. We can split this into 2 columns for better analytics.

-- Create column for Deck:
Alter table SpaceT..train
Add Deck varchar(10);
Update SpaceT..train
set Deck = left(Cabin, 1);

--Create column for Side:
Alter table SpaceT..train
Add Side varchar(10);
Update SpaceT..train
set Side = right(Cabin, 1);

--Updating Side to say Port or Starboard:
Update SpaceT..train
Set Side = case when Side = 'S' then 'Starboard'
	 when Side = 'P' then 'Port'
	 else NULL
	 end

--3.
--Creating two different columns to categorize age.

--Grouping Age into categories that hold culture meaning:
alter table SpaceT..train
add AgeGroups varchar(15);
update SpaceT..train
set AgeGroups = case when Age > 65 and Age <9999 then 'Retired'
	when Age <= 65 and Age > 50 then 'MiddleAged'
	when Age <= 50 and Age >= 40 then 'Adult'
	when Age < 40 and Age >= 22 then 'YoungAdult'
	when Age < 22 and Age >= 13 then 'Adolescent'
	when Age < 13 and Age >= 1 then 'Child'
	when Age = 0 then 'Infant'
	else NULL
	end

--Creating a second column where passengers are grouped based on 10 year age gaps:
alter table SpaceT..train
add AgesRoundedUp int;
update SpaceT..train
set AgesRoundedUp = case when  Age <> 9999 then ceiling(Age/10) * 10
else NULL 
end 


--4.
--Adding column TotalSpent which will represent the amount each passenger has spent on board.
--Adding another column for SpentOnBOard which will tell us if the passenger spent on board (Yes/No).

--Total Spent Column:
alter table SpaceT..train
add TotalSpent int;
update SpaceT..train
set TotalSpent = coalesce(RoomService,0) + coalesce(FoodCourt,0) + coalesce(ShoppingMall,0) + coalesce(Spa,0) + coalesce(VRDeck,0)

--SpentOnBoard Column:
alter table SpaceT..train
add SpentOnBoard varchar(10);
update SpaceT..train
set SpentOnBoard = 
	case when Totalspent = 0 then 'No'
	else 'Yes' end

--5. Filling NULL to assist with the TotalSpentColumn. Here we are imputing NULL values with zero if all other spent columns are also equal to zero.
Update SpaceT..train
set FoodCourt = case when RoomService = 0 and ShoppingMall = 0 and Spa = 0 and VRDeck = 0 then 0
	else FoodCourt
	end
Update SpaceT..train
set ShoppingMall = case when RoomService = 0 and FoodCourt = 0 and Spa = 0 and VRDeck = 0 then 0
	else ShoppingMall
	end
Update SpaceT..train
set Spa = case when RoomService = 0 and FoodCourt = 0 and ShoppingMall = 0 and VRDeck = 0 then 0
	else Spa
	end
Update SpaceT..train
set VRDeck = case when RoomService = 0 and FoodCourt = 0 and ShoppingMall = 0 and Spa = 0 then 0
	else VRDeck
	end
Update SpaceT..train
set RoomService = case when VRDeck = 0 and FoodCourt = 0 and ShoppingMall = 0 and Spa = 0 then 0
	else RoomService
	end

--6.
alter table SpaceT..train
add Luxury int;
update SpaceT..train
set Luxury = coalesce(RoomService,0) + coalesce(Spa,0) + coalesce(VRDeck,0)



