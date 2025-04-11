----1.initializes the database for the Pet Adoption Platform-PetPals.
CREATE DATABASE PetPalsDB;

USE PetPalsDB;

---1 to 4.  Database Setup
---Create tables for Pets, Shelters, Donations, AdoptionEvents, and Participants

---Table Pet
CREATE TABLE Pets (
    PetID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Breed VARCHAR(100),
    Type VARCHAR(50),
    AvailableForAdoption BIT
);

---Shelter
CREATE TABLE Shelters (
    ShelterID INT PRIMARY KEY,
    Name VARCHAR(100),
    Location VARCHAR(255)
);

---Donation
CREATE TABLE Donations (
    DonationID INT PRIMARY KEY,
    DonorName VARCHAR(100),
    DonationType VARCHAR(50),
    DonationAmount DECIMAL(10, 2),
    DonationItem VARCHAR(100),
    DonationDate DATETIME
);

---AdoptionEvents
CREATE TABLE AdoptionEvents (
    EventID INT PRIMARY KEY,
    EventName VARCHAR(100),
    EventDate DATETIME,
    Location VARCHAR(255)
);

---Participants
CREATE TABLE Participants (
    ParticipantID INT PRIMARY KEY,
    ParticipantName VARCHAR(100),
    ParticipantType VARCHAR(50),
    EventID INT,
    FOREIGN KEY (EventID) REFERENCES AdoptionEvents(EventID)
);

INSERT INTO Shelters (ShelterID, Name, Location) VALUES
(1, 'Happy Paws Shelter', 'Chennai'),
(2, 'Safe Haven Shelter', 'Bangalore'),
(3, 'Care & Love Shelter', 'Chennai');

INSERT INTO Pets (PetID, Name, Age, Breed, Type, AvailableForAdoption, ShelterID, OwnerID) VALUES
(1, 'Bruno', 2, 'Labrador', 'Dog', 1, 1, NULL),
(2, 'Kitty', 4, 'Persian Cat', 'Cat', 1, 2, NULL),
(3, 'Max', 1, 'Labrador', 'Dog', 0, 1, 101),
(4, 'Snowy', 3, 'Persian Cat', 'Cat', 1, 3, NULL),
(5, 'Rocky', 6, 'Beagle', 'Dog', 0, 1, 102),
(6, 'Luna', 2, 'Beagle', 'Dog', 1, 2, NULL);

INSERT INTO AdoptionEvents (EventID, EventName, EventDate, Location, ShelterID) VALUES
(1, 'Pet Fest 2023', '2023-06-01', 'Chennai', 1),
(2, 'Adoptathon', '2023-07-15', 'Bangalore', 2),
(3, 'Love a Pet Day', '2023-08-10', 'Chennai', 3);

INSERT INTO Participants (ParticipantID, ParticipantName, ParticipantType, EventID) VALUES
(1, 'Happy Paws Shelter', 'Shelter', 1),
(2, 'Safe Haven Shelter', 'Shelter', 2),
(3, 'Anjali Rao', 'Adopter', 1),
(4, 'Ramesh Kumar', 'Adopter', 3),
(5, 'Care & Love Shelter', 'Shelter', 3);

INSERT INTO Donations (DonationID, DonorName, DonationType, DonationAmount, DonationItem, DonationDate, ShelterID) VALUES
(1, 'Rajesh Sharma', 'Cash', 1000.00, NULL, '2023-05-01', 1),
(2, 'Anita Verma', 'Item', NULL, 'Dog Food', '2023-05-10', 2),
(3, 'Global Pet Corp', 'Cash', 2500.00, NULL, '2023-06-20', 1),
(4, 'Meera K', 'Item', NULL, 'Cat Litter', '2023-07-01', 3),
(5, 'Pet Lovers Foundation', 'Cash', 500.00, NULL, '2023-08-15', 3);

INSERT INTO Adoptions (AdoptionID, PetID, AdopterName, AdoptionDate) VALUES
(1, 3, 'Ravi Menon', '2023-06-05'),
(2, 5, 'Divya Patel', '2023-07-10');


----5. Available Pets. Lists pets marked as available for adoption.
SELECT Name, Age, Breed, Type
FROM Pets
WHERE AvailableForAdoption = 1;

---6. Participants for a Specific Event. Shows participants of a specific event (by EventID).
SELECT ParticipantName, ParticipantType
FROM Participants
WHERE EventID = 3;  -- replace 3 with any event ID


---7. Stored procedure to update shelter name and location by ID.
CREATE PROCEDURE UpdateShelterInfo
    @ShelterID INT,
    @NewName VARCHAR(100),
    @NewLocation VARCHAR(255)
AS
BEGIN
    -- Update the shelter's name and location
    UPDATE Shelters
    SET Name = @NewName,
        Location = @NewLocation
    WHERE ShelterID = @ShelterID;
END;

EXEC UpdateShelterInfo 1, 'Care & Paws Shelter', 'Velachery, Chennai';


---8. Write an SQL query that calculates and retrieves the total donation amount for each shelter (by shelter name) from the "Donations" table. 
---Step 1: Add ShelterID to Donations Table
ALTER TABLE Donations
ADD ShelterID INT;

---Step 2: Query for Total Donation Per Shelter
SELECT S.Name AS ShelterName,
       ISNULL(SUM(D.DonationAmount), 0) AS TotalDonations
FROM Shelters S
LEFT JOIN Donations D ON S.ShelterID = D.ShelterID
GROUP BY S.Name;


---9.Write an SQL query that retrieves the names of pets from the "Pets" table that do not have an owner
ALTER TABLE Pets
ADD OwnerID INT;  -- This can later be linked to a Users or Adopters table

SELECT Name, Age, Breed, Type
FROM Pets
WHERE OwnerID IS NULL;


---10.Write an SQL query that retrieves the total donation amount for each month and year (e.g., January 2023) from the "Donations" table.
SELECT 
    FORMAT(DonationDate, 'MMMM yyyy') AS MonthYear,
    SUM(DonationAmount) AS TotalDonation
FROM Donations
GROUP BY FORMAT(DonationDate, 'MMMM yyyy')
ORDER BY MIN(DonationDate);

---11. Retrieve a list of distinct breeds for all pets that are either aged between 1 and 3 years or older than 5 years.
SELECT DISTINCT Breed
FROM Pets
WHERE (Age BETWEEN 1 AND 3) OR (Age > 5);


---12. Retrieve a list of pets and their respective shelters where the pets are currently available for adoption.

ALTER TABLE Pets
ADD ShelterID INT;

SELECT P.Name AS PetName,
       P.Breed,
       P.Type,
       S.Name AS ShelterName
FROM Pets P
JOIN Shelters S ON P.ShelterID = S.ShelterID
WHERE P.AvailableForAdoption = 1;

---13. Find the total number of participants in events organized by shelters located in a specific city. For example: City = Chennai
ALTER TABLE AdoptionEvents
ADD ShelterID INT;

SELECT COUNT(P.ParticipantID) AS TotalParticipants
FROM Participants P
JOIN AdoptionEvents AE ON P.EventID = AE.EventID
JOIN Shelters S ON AE.ShelterID = S.ShelterID
WHERE S.Location LIKE '%Chennai%';

---14. Retrieve a list of unique breeds for pets whose ages are between 1 and 5 years.
SELECT DISTINCT Breed
FROM Pets
WHERE Age BETWEEN 1 AND 5;

---15. Find the pets that have not been adopted by selecting their information from the Pets table.
CREATE TABLE Adoptions (
    AdoptionID INT PRIMARY KEY,
    PetID INT,
    AdopterName VARCHAR(100), -- optional
    AdoptionDate DATE
);

SELECT PetID, Name, Age, Breed, Type
FROM Pets
WHERE PetID NOT IN (SELECT PetID FROM Adoptions);


---16. Retrieve the names of all adopted pets along with the adopter's name from the Adoptions and Pets tables.
SELECT P.Name AS PetName,
       A.AdopterName
FROM Adoptions A
JOIN Pets P ON A.PetID = P.PetID;


---17. Retrieve a list of all shelters along with the count of pets currently available for adoption in each shelter.
SELECT S.Name AS ShelterName,
       COUNT(P.PetID) AS AvailablePets
FROM Shelters S
LEFT JOIN Pets P ON S.ShelterID = P.ShelterID AND P.AvailableForAdoption = 1
GROUP BY S.Name;


---18. Find pairs of pets from the same shelter that have the same breed.
SELECT P1.Name AS Pet1,
       P2.Name AS Pet2,
       P1.Breed,
       S.Name AS ShelterName
FROM Pets P1
JOIN Pets P2 ON P1.Breed = P2.Breed
            AND P1.ShelterID = P2.ShelterID
            AND P1.PetID < P2.PetID
JOIN Shelters S ON P1.ShelterID = S.ShelterID;

---19. List all possible combinations of shelters and adoption events.
SELECT S.Name AS ShelterName,
       AE.EventName AS EventName
FROM Shelters S
CROSS JOIN AdoptionEvents AE;


---20. Determine the shelter that has the highest number of adopted pets.
SELECT TOP 1 S.Name AS ShelterName,
             COUNT(*) AS AdoptedPetCount
FROM Adoptions A
JOIN Pets P ON A.PetID = P.PetID
JOIN Shelters S ON P.ShelterID = S.ShelterID
GROUP BY S.Name
ORDER BY COUNT(*) DESC;












   


