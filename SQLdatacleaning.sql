--data cleaning in sql
select*
From protfolioproject.dbo.NashvilleHousing

----standardize data format

select SaleDateConverted, CONVERT(Date,SaleDate)
From protfolioproject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--populate property address data

select*
FROM protfolioproject.dbo.NashvilleHousing
ORDER by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM protfolioproject.dbo.NashvilleHousing a
join protfolioproject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID 
AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null 

update a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM protfolioproject.dbo.NashvilleHousing a
join protfolioproject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID 
AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADRESS,CITY,STATE)

Select PropertyAddress
FROM Protfolioproject.dbo.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
FROM Protfolioproject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD propertyspilitAddress Nvarchar(255);

Update NashvilleHousing
SET propertyspilitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

ALTER TABLE NashvilleHousing
ADD propertyspilitCity Nvarchar(255);

Update NashvilleHousing
SET propertyspilitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

--spilt owner address

select OwnerAddress
FROM Protfolioproject.dbo.NashvilleHousing

select 
PARSENAME(REPLACE(OwnerAddress,',','-'),3)
,PARSENAME(REPLACE(OwnerAddress,',','-'),2)
,PARSENAME(REPLACE(OwnerAddress,',','-'),1)
FROM Protfolioproject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD ownerspilitAddress Nvarchar(255);

Update NashvilleHousing
SET propertyspilitAddress = PARSENAME(REPLACE(OwnerAddress,',','-'),3)

ALTER TABLE NashvilleHousing
ADD ownerspilitCity Nvarchar(255);

Update NashvilleHousing
SET propertyspilitCity = PARSENAME(REPLACE(OwnerAddress,',','-'),2)

ALTER TABLE NashvilleHousing
ADD ownerspilitState Nvarchar(255);

Update NashvilleHousing
SET propertyspilitState = PARSENAME(REPLACE(OwnerAddress,',','-'),1)


--change Y and NO in 'sold as value'field
select DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM Protfolioproject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
order BY 2

select SoldAsVacant
,CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
	   FROM Protfolioproject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
	   FROM Protfolioproject.dbo.NashvilleHousing
--------------------------------------------------------
--REMOVE DUPLICATES
WITH ROWNumCTE AS
(
SELECT*,
   ROW_NUMBER() OVER(
   PARTITION BY ParcelID,
   propertyAddress,
   SalePrice,
   SaleDate,
   LegalReference
   ORDER BY
   UniqueID
   )row_num

 FROM Protfolioproject.dbo.NashvilleHousing
 --order by ParcelID

 )
 SELECT*
 FROM ROWNumCTE
 WHERE row_num > 1
  
  ---delete un used columns
  select*
  FROM Protfolioproject.dbo.NashvilleHousing

  ALTER TABLE Protfolioproject.dbo.NashvilleHousing
  DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress

  ALTER TABLE Protfolioproject.dbo.NashvilleHousing
  DROP COLUMN SaleDate



























