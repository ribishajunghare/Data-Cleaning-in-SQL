--Cleaning Data in SQL Queries

SELECT *
 FROM [PROJECT 1].[dbo].[NashvilleHousing];


 --Standardize Date Format

SELECT SaleDate
FROM [PROJECT 1].[dbo].[NashvilleHousing];

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM [PROJECT 1].[dbo].[NashvilleHousing];

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate);

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM [PROJECT 1].[dbo].[NashvilleHousing];


 --Populate Property Address data

SELECT PropertyAddress
FROM [PROJECT 1].[dbo].[NashvilleHousing]
WHERE PropertyAddress IS NULL


SELECT *
FROM [PROJECT 1].[dbo].[NashvilleHousing]
WHERE PropertyAddress IS NULL

SELECT *
FROM [PROJECT 1].[dbo].[NashvilleHousing]
ORDER BY ParcelID


 SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)        
 FROM [PROJECT 1].[dbo].[NashvilleHousing] AS a
 JOIN [PROJECT 1].[dbo].[NashvilleHousing] AS b
 ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
 WHERE a.PropertyAddress IS NULL


 UPDATE a
 SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
 FROM [PROJECT 1].[dbo].[NashvilleHousing] AS a
 JOIN [PROJECT 1].[dbo].[NashvilleHousing] AS b
 ON a.ParcelID = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
 WHERE a.PropertyAddress IS NULL  


 --Breaking out Address into Individual Columns (Address, City, State)

 SELECT PropertyAddress
 FROM [PROJECT 1].[dbo].[NashvilleHousing]
 
SELECT
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
 SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) AS Address
 FROM [PROJECT 1].[dbo].[NashvilleHousing]
 
 
 ALTER TABLE NashvilleHousing
 ADD PropertySplitAddress Nvarchar(255);

 UPDATE NashvilleHousing
 SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

 ALTER TABLE NashvilleHousing
 ADD PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
 SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))

SELECT *
FROM [PROJECT 1].[dbo].[NashvilleHousing] 


SELECT OwnerAddress
FROM [PROJECT 1].[dbo].[NashvilleHousing] 

 SELECT 
 PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
 PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
 PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
 FROM [PROJECT 1].[dbo].[NashvilleHousing] 

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

 UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

 SELECT *
 FROM [PROJECT 1].[dbo].[NashvilleHousing]


 --Change Y and N to Yes and NO in "Sold as Vacant" field

 SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
 FROM [PROJECT 1].[dbo].[NashvilleHousing] 
 GROUP BY SoldAsVacant
 ORDER BY 2


 SELECT SoldAsVacant,
 CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
 WHEN SoldAsVacant = 'N' THEN 'No'
 ELSE SoldAsVacant
 END
FROM [PROJECT 1].[dbo].[NashvilleHousing] 


UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
 WHEN SoldAsVacant = 'N' THEN 'No'
 ELSE SoldAsVacant
 END




-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
    ROW_NUMBER() OVER(
    PARTITION BY ParcelID,
	             PropertyAddress, 
				 SalePrice, 
				 SaleDate, 
				 LegalReference
                 ORDER BY 
				    UniqueID
					) row_num

FROM [PROJECT 1].[dbo].[NashvilleHousing]
)

DELETE
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY Propertyaddress





Select *
FROM [PROJECT 1].[dbo].[NashvilleHousing]


--Delete Unused Columns


Select *
FROM [PROJECT 1].[dbo].[NashvilleHousing]


ALTER TABLE [PROJECT 1].[dbo].[NashvilleHousing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
