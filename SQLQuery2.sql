
--Cleaning Data in SQL

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

--Standardize date format

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate= CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted= CONVERT(Date, SaleDate)

--Populate Property Address Data

SELECT *
From PortfolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress is null 
order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b 
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress= ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b 
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking out Address into Individual columns (Address, City, State)
SELECT PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(225);

UPDATE NashvilleHousing 
SET PropertySplitAddress= SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(225);

Update NashvilleHousing
SET PropertySplitCity= SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT *
From PortfolioProject.dbo.NashvilleHousing

Select 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(225);

UPDATE NashvilleHousing 
SET OwnerSplitAddress= PARSENAME(Replace(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(225);

Update NashvilleHousing
SET OwnerSplitCity= PARSENAME(Replace(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(225);

Update NashvilleHousing
SET OwnerSplitState= PARSENAME(Replace(OwnerAddress,',','.'),1)


SELECT *
From PortfolioProject.dbo.NashvilleHousing

---Chane Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), COUNT (SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE When SoldAsVacant= 'Y' THEN 'Yes'
	   When SoldAsVacant= 'N' THEN 'Yes'
	   ELSE SoldAsVacant		
	   END
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant=  CASE When SoldAsVacant= 'Y' THEN 'Yes'
	   When SoldAsVacant= 'N' THEN 'Yes'
	   ELSE SoldAsVacant		
	   END

--Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalREference
				 ORDER BY
					UniqueID
					) row_num
				
From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select*
From RowNumCTE
Where row_num>1
Order by PropertyAddress

SELECT *
From PortfolioProject.dbo.NashvilleHousing

--Delete unused columns

SELECT *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress 

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate
