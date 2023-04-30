Select * from portfolioproject.dbo.NashvilleData


--Change the Saledate

Alter table NashvilleData alter column SaleDate Date

Select * from portfolioproject.dbo.NashvilleData


--Populate Property Address data

Select a.parcelID,b.parcelID,a.PropertyAddress,b.PropertyAddress, ISNULL (a.PropertyAddress,b.PropertyAddress)
from portfolioproject.dbo.NashvilleData a
join portfolioproject.dbo.NashvilleData b
on a.ParcelID=b.ParcelID
and  a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is NULL


Update a
set PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
from portfolioproject.dbo.NashvilleData a
join portfolioproject.dbo.NashvilleData b
on a.ParcelID=b.ParcelID
and  a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is NULL



--Breakin down Address into indivdual columns

Select PropertyAddress from portfolioproject.dbo.NashvilleData

Select Substring(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) As Address,
Substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address2
from portfolioproject.dbo.NashvilleData

Alter Table NashvilleData Add PropertySplitAddress nvarchar(255);

  Update NashvilleData Set PropertySplitAddress = Substring(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

 Alter Table NashvilleData Add PropertyAddressCity nvarchar(255);
 
  Update NashvilleData Set PropertyAddressCity = Substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


  select * from portfolioproject.dbo.NashvilleData

 --Split columnData uusing ParseName
 
Select PARSENAME(Replace(OwnerAddress,',','.'), 3),
 PARSENAME(Replace(OwnerAddress,',','.'), 2),
  PARSENAME(Replace(OwnerAddress,',','.'), 1)

 from portfolioproject.dbo.NashvilleData


 Alter Table NashvilleData Add OwnerSplitAddress nvarchar(255);

  Update NashvilleData Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'), 3)

 Alter Table NashvilleData Add OwnerCityAddress nvarchar(255);
 
  Update NashvilleData Set OwnerCityAddress =  PARSENAME(Replace(OwnerAddress,',','.'), 2)
   
    Alter Table NashvilleData Add OwnerStateAddress nvarchar(255);

  Update NashvilleData Set OwnerStateAddress = PARSENAME(Replace(OwnerAddress,',','.'), 1)

  Select * from portfolioproject.dbo.NashvilleData


  --Change Y and N to Yes and NO in SoldAsVacant column using Case

  Select distinct(SoldAsVacant), count(SoldAsVacant)   From portfolioproject.dbo.NashvilleData
  group by SoldAsVacant
  order by 2

  UPDATE NashvilleData
SET SoldAsVacant =  
  CASE 
    WHEN SoldAsVacant = 'Y' THEN 'Yes' 
	WHEN SoldAsVacant = 'N' THEN 'No' 
    ELSE SoldAsVacant
  END
   
  Select SoldAsVacant From portfolioproject.dbo.NashvilleData


  --Remove Duplicates
  With RowNumCTE as (
  Select *, ROW_NUMBER() over (partition by 
								ParcelID,
								PropertyAddress,
								SalePrice,
								SaleDate,
								LegalReference
								order by UniqueID) row_num
	
								from portfolioproject.dbo.NashvilleData
								)
select * from RowNumCTE where row_num>1 

--Delete Unused Columns
Alter Table  portfolioproject.dbo.NashvilleData 
drop column OwnerAddress, TaxDistrict, PropertyAddress

