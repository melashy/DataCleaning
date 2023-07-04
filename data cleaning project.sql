-- Cleaning data in SQL queries

select *
from Nashvillehousing

--standardize date format (removing the time)

select SaleDate, convert(date, saledate)
from Nashvillehousing

update Nashvillehousing
set SaleDate=convert(date, saledate)

alter table nashvillehousing
add saledateconverted date;

update Nashvillehousing
set saledateconverted=convert(date, saledate)

-- populate property address date(if parcelid has a propertyaddress, we want to populated an address for
-- the same parcelid with null property address)

select *
from Nashvillehousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, b.ParcelID, a.PropertyAddress,b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from Nashvillehousing a
join Nashvillehousing b
on a.ParcelID= b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=isnull(a.PropertyAddress, b.PropertyAddress)
from Nashvillehousing a
join Nashvillehousing b
on a.ParcelID= b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out Address into individual columns ( address, city, state)

select PropertyAddress
from Nashvillehousing

select
SUBSTRING(propertyaddress, 1,charindex(',',propertyaddress)-1) as address
,SUBSTRING(propertyaddress,charindex(',',propertyaddress)+1, len(propertyaddress)) as address
from Nashvillehousing

alter table nashvillehousing
add propertysplitaddress nvarchar(255);

update Nashvillehousing
set propertysplitaddress=SUBSTRING(propertyaddress, 1,charindex(',',propertyaddress)-1)

alter table nashvillehousing
add propertysplitcity nvarchar(255);

update Nashvillehousing
set propertysplitcity=SUBSTRING(propertyaddress,charindex(',',propertyaddress)+1, len(propertyaddress))

select *
from Nashvillehousing

select OwnerAddress
from Nashvillehousing

select
PARSENAME(replaceowneraddress,1)
from Nashvillehousing

-- Create new columns 'address', 'city', and 'state' to store the separated values
ALTER TABLE nashvillehousing
ADD address VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255);

-- Update the new columns with the separated values from the 'owner address' column
UPDATE nashvillehousing
SET
    address = CASE 
                  WHEN CHARINDEX(',', [owneraddress]) > 0 THEN LEFT([owneraddress], CHARINDEX(',', [owneraddress]) - 1)
                  ELSE [owneraddress]
              END,
    city = CASE 
               WHEN CHARINDEX(',', [owneraddress]) > 0 THEN LTRIM(RTRIM(SUBSTRING([owneraddress], CHARINDEX(',', [owneraddress]) + 1, CHARINDEX(',', [owneraddress], CHARINDEX(',', [owneraddress]) + 1) - CHARINDEX(',', [owneraddress]) - 1)))
               ELSE ''
           END,
    state = CASE 
                WHEN CHARINDEX(',', [owneraddress]) > 0 THEN LTRIM(RTRIM(SUBSTRING([owneraddress], CHARINDEX(',', [owneraddress], CHARINDEX(',', [owneraddress]) + 1) + 1, LEN([owneraddress]) - CHARINDEX(',', [owneraddress], CHARINDEX(',', [owneraddress]) + 1))))
                ELSE ''
            END;
-- Remove the 'owner address' column if no longer needed and unused columns

ALTER TABLE nashvillehousing
DROP COLUMN address1;

ALTER TABLE nashvillehousing
DROP COLUMN city1;

ALTER TABLE nashvillehousing
DROP COLUMN state2;

ALTER TABLE nashvillehousing
DROP COLUMN owneraddress;

ALTER TABLE nashvillehousing
DROP COLUMN propertyaddress;

ALTER TABLE nashvillehousing
DROP COLUMN saledate;

select *
from Nashvillehousing

--Change Y and N to Yes and No in "sold as vacant" field

select distinct(soldasvacant), count(soldasvacant)
from Nashvillehousing
group by SoldAsVacant
order by 2

select soldasvacant,
case when soldasvacant = 'Y' Then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
end
from Nashvillehousing

update Nashvillehousing
set SoldAsVacant=case when soldasvacant = 'Y' Then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
end
from Nashvillehousing


