-- Cleaning Data in SQL Queries

Select *
from NashvilleHousing

-- Standardizing Date Format


Select SaleDateConverted, CONVERT(Date,SaleDate)
From NashvilleHousing

Update NashvilleHousing,
SET SaleDate = CONVERT(date, saledate)

Alter table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT(Date,SaleDate)


-- Populating Property Address data

Select *
From NashvilleHousing
--Where PropertyAddress is Null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null 


-- Breaking out Property address into individual columns being address, city, state

Select PropertyAddress
From NashvilleHousing
--Where PropertyAddress is Null
--order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address

From NashvilleHousing

Alter table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))

Select *
From NashvilleHousing


-- Breaking out owner address into individual columns being address, city, state


Select OwnerAddress
From NashvilleHousing

Select
PARSENAME(Replace(OwnerAddress, ',', '.'), 3)
, PARSENAME(Replace(OwnerAddress, ',', '.'), 2)
, PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
From NashvilleHousing

Alter table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)

Alter table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)

Alter table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)

Select *
From NashvilleHousing

--- Change Y and N to "Yes" and "No" in the "Sold as vacant field

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, Case When SoldAsVacant = 'Y' then 'Yes'
       When SoldAsVacant = 'N' then 'No'
	   Else SoldAsVacant 
	   End
From NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' then 'Yes'
       When SoldAsVacant = 'N' then 'No'
	   Else SoldAsVacant 
	   End

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
Order by 2

--- Removing duplicates 

WITH RowNumCTE AS(
Select *,
Row_Number() Over (
Partition by ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order By
			 UniqueID
			 ) row_num 
From NashvilleHousing
--Order by ParcelID
)
Delete
From RowNumCTE
Where row_num >1
--Order by PropertyAddress

--- Removing un-used columns 

Select *
From NashvilleHousing

Alter table NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter table NashvilleHousing
Drop Column SaleDate
