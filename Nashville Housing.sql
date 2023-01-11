/*

Cleaning Data in SQL

*/

Select *
From Profile..NashvilleHousing


-- Change Date Format


Select SaleDate, CONVERT(Date,SaleDate)
From Profile..NashvilleHousing


Update Profile..NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

Alter Table Profile..NashvilleHousing
add SaleDateConverted Date;

Update Profile..NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted, CONVERT(Date,SaleDate)
From Profile..NashvilleHousing


-- Populate Property Address Data


Select *
From Profile..NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
ISNULL(a.PropertyAddress,b.PropertyAddress)
From Profile..NashvilleHousing a
Join Profile..NashvilleHousing b
     on a.ParcelID = b.ParcelID
     and A.UniqueID <> b.UniqueID
  Where a.PropertyAddress is null 


  Update a
  SET PropertyAddress = 
  ISNULL(a.PropertyAddress,b.PropertyAddress)
  From Profile..NashvilleHousing a
Join Profile..NashvilleHousing b
      on a.ParcelID = b.ParcelID
      and A.UniqueID <> b.UniqueID
  Where a.PropertyAddress is null 


  --Breaking out Address Into Individual Columns (Address, City, State)


Select PropertyAddress
From Profile..NashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID


Select
SUBSTRING(PropertyAddress, 1,
CHARINDEX(',',PropertyAddress)-1) as Address,
 SUBSTRING(PropertyAddress,
 CHARINDEX(',',PropertyAddress)+1 , LEN(PropertyAddress)) as Address
From Profile..NashvilleHousing



Alter Table Profile..NashvilleHousing
add PropertySplitAddress Nvarchar (255);

Update Profile..NashvilleHousing
SET  PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)

Alter Table Profile..NashvilleHousing
add PropertySplitCity Nvarchar (255);

Update Profile..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1 , LEN(PropertyAddress))


SELECT *
FROM Profile..NashvilleHousing


Select OwnerAddress
From Profile..NashvilleHousing
Where OwnerAddress is not null



Select
PARSENAME (Replace(OwnerAddress,',','.'), 3)
, PARSENAME (Replace(OwnerAddress,',','.'), 2)
,PARSENAME (Replace(OwnerAddress,',','.'), 1)
From Profile..NashvilleHousing



Alter Table Profile..NashvilleHousing
add OwnerSplitAddress Nvarchar (255);

Update Profile..NashvilleHousing
SET  OwnerSplitAddress = PARSENAME (Replace(OwnerAddress,',','.'), 3)



Alter Table Profile..NashvilleHousing
add OwnerSplitCity Nvarchar (255);

Update Profile..NashvilleHousing
SET OwnerSplitCity = PARSENAME (Replace(OwnerAddress,',','.'), 2)



Alter Table Profile..NashvilleHousing
add OwnerSplitState Nvarchar (255);

Update Profile..NashvilleHousing
SET OwnerSplitState = PARSENAME (Replace(OwnerAddress,',','.'), 1)



Select *
From Profile..NashvilleHousing
Where OwnerAddress is not null



--Change Y and N to Yes and No in 'Sold Vacant'



Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From Profile..NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
       ELSE SoldAsVacant
       END
From Profile..NashvilleHousing



UPDATE Profile..NashvilleHousing
SET SoldAsVacant =  CASE When SoldAsVacant = 'Y' Then 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
       ELSE SoldAsVacant
       END
From Profile..NashvilleHousing



-- Remove Duplicates



WITH RowNumCTE AS(
SELECT *,
  ROW_NUMBER() OVER(
  PARTITION BY ParcelID,
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   Order by 
			   UniqueID
			   ) row_num
From Profile..NashvilleHousing

)
SELECT*
From RowNumCTE
Where row_num > 1



--Delete Unused Columns



SELECT *
From Profile..NashvilleHousing

ALTER TABLE Profile..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Profile..NashvilleHousing
DROP COLUMN SaleDate

