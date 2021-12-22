update Object set FloorText = cast(substring(ApartmentNo, 2, 2) as int) - 10
where isnumeric(substring(ApartmentNo, 2, 2)) = 1
